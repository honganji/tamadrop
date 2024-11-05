import 'dart:async';
import 'dart:io';

import 'package:ffmpeg_kit_flutter_audio/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_audio/return_code.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tamadrop/features/download/domain/entities/video.dart';
import 'package:tamadrop/features/download/domain/repos/video_repo.dart';
import 'package:tamadrop/features/layout/presentation/cubits/progress_cubit.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

class DownloadVideoRepo implements VideoRepo {
  final ProgressCubit progressCubit;
  DownloadVideoRepo(this.progressCubit);
  Future<String> _runFFmpeg(String command) async {
    var session = await FFmpegKit.execute(command);
    var returnCode = await session.getReturnCode();
    if (ReturnCode.isSuccess(returnCode)) {
      return 'success';
    } else {
      return (await session.getOutput())!;
    }
  }

  Future<String> _downloadVideo(
    String url,
    String appDocDir,
    String time,
    YoutubeExplode yt,
  ) async {
    // Get the instance which holds video info
    var video = await yt.videos.get(url);
    StreamManifest manifest = await yt.videos.streams.getManifest(video.id);
    if (manifest.audioOnly.isEmpty || manifest.videoOnly.isEmpty) {
      throw Exception("No audio or video streams available for this video.");
    }
    var streamAudioInfo = manifest.audioOnly.withHighestBitrate();
    var streamVideoInfo = manifest.videoOnly.firstWhere(
      (stream) => stream.qualityLabel == '1080p',
      orElse: () => manifest.videoOnly.withHighestBitrate(),
    );
    var audioStream = yt.videos.streams.get(streamAudioInfo);
    var videoStream = yt.videos.streams.get(streamVideoInfo);

    // Define the file paths
    const videoDirName = "videos";
    final relativeVideoPath = "$videoDirName/$time.mp4";
    final videoDir = Directory('$appDocDir/$videoDirName');
    if (!await videoDir.exists()) {
      await videoDir.create(recursive: true);
    }
    var audioFilePath = path.join(
        appDocDir, '${video.id}_audio.${streamAudioInfo.container.name}');
    var videoFilePath = path.join(
        appDocDir, '${video.id}_video.${streamVideoInfo.container.name}');
    var outputFilePath = path.join(appDocDir, relativeVideoPath);
    var audioFile = File(audioFilePath);
    var videoFile = File(videoFilePath);

    // Write video and audio info into a file
    var audioFileStream = audioFile.openWrite();
    var videoFileStream = videoFile.openWrite();

    var totalData = streamAudioInfo.size.totalBytes.toInt() +
        streamVideoInfo.size.totalBytes.toInt();
    var downloadedData = 0;

    await for (var data in audioStream) {
      downloadedData += data.length;
      progressCubit.updateProgress(downloadedData / totalData * 100);
      audioFileStream.add(data);
    }

    await for (var data in videoStream) {
      downloadedData += data.length;
      progressCubit.updateProgress(downloadedData / totalData * 100);
      videoFileStream.add(data);
    }
    progressCubit.updateProgress(0);

    // Close the files
    await audioFileStream.flush();
    await audioFileStream.close();
    await videoFileStream.flush();
    await videoFileStream.close();

    // Merge audio and video using ffmpeg_kit_flutter
    var mergeCommand =
        '-i $videoFilePath -i $audioFilePath -c:v copy -c:a aac $outputFilePath';
    late var mergeResult;
    try {
      mergeResult = await _runFFmpeg(mergeCommand);
    } catch (e) {
      Exception(e.toString());
    }

    if (mergeResult != 'success') {
      Exception('Error during merging: $mergeResult');
    }

    // Clean up temporary files
    await audioFile.delete();
    await videoFile.delete();

    return relativeVideoPath;
  }

  Future<String> _downloadThumbnail(
    String url,
    String appDocDir,
    Video video,
    String time,
  ) async {
    const thumbnailDirName = "thambnails";
    final relativeThumbnailPath = "$thumbnailDirName/${time}.jpg";
    final thumbnailDir = Directory('$appDocDir/$thumbnailDirName');
    if (!await thumbnailDir.exists()) {
      await thumbnailDir.create(recursive: true);
    }
    final thumbnailFilePath = path.join(appDocDir, relativeThumbnailPath);
    // Fetch the image from the URL
    final response = await http.get(Uri.parse(video.thumbnails.highResUrl));

    // Save the image to the local storage
    final thumbnailFile = File(thumbnailFilePath);
    await thumbnailFile.writeAsBytes(response.bodyBytes);
    return relativeThumbnailPath;
  }

  @override
  Future<LocalVideo?> downloadVideo(String url) async {
    LocalVideo localVideo;
    var yt = YoutubeExplode();
    var video = await yt.videos.get(url);
    var appDocDir = await getApplicationDocumentsDirectory();
    var time = DateTime.now().millisecondsSinceEpoch.toString();
    final videoPath = await _downloadVideo(url, appDocDir.path, time, yt);
    final thumbnailPath =
        await _downloadThumbnail(url, appDocDir.path, video, time);

    yt.close();
    localVideo = LocalVideo(
      vid: time,
      path: videoPath,
      createdAt: DateTime.now(),
      thumbnailFilePath: thumbnailPath,
      title: video.title,
      volume: ((await File(path.join(appDocDir.path, videoPath)).length()) /
              1024 /
              1024)
          .toInt(),
      length: video.duration?.inSeconds ?? 0,
    );
    return localVideo;
  }
}

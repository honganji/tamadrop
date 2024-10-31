import 'dart:io';

import 'package:ffmpeg_kit_flutter_audio/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_audio/return_code.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tamadrop/features/download/domain/entities/video.dart';
import 'package:tamadrop/features/download/domain/repos/video_repo.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:path/path.dart' as path;

class DownloadVideoRepo implements VideoRepo {
  Future<String> runFFmpeg(String command) async {
    var session = await FFmpegKit.execute(command);
    var returnCode = await session.getReturnCode();
    if (ReturnCode.isSuccess(returnCode)) {
      return 'success';
    } else {
      return (await session.getOutput())!;
    }
  }

  @override
  Future<LocalVideo?> downloadVideo(String url) async {
    LocalVideo localVideo;
    // Get the instance which holds video info
    var yt = YoutubeExplode();
    var time = DateTime.now().millisecondsSinceEpoch.toString();
    var video = await yt.videos.get(url);
    StreamManifest manifest = await yt.videos.streams.getManifest(video.id);
    if (manifest.audioOnly.isEmpty || manifest.videoOnly.isEmpty) {
      print('No audio or video streams available for this video.');
      return null;
    }
    var streamAudioInfo = manifest.audioOnly.withHighestBitrate();
    var streamVideoInfo = manifest.videoOnly.withHighestBitrate();
    var audioStream = yt.videos.streams.get(streamAudioInfo);
    var videoStream = yt.videos.streams.get(streamVideoInfo);

    // Define the file paths
    // TODO deal with if there is the same video
    var appDocDir = await getApplicationDocumentsDirectory();
    var audioFilePath = path.join(
        appDocDir.path, '${video.id}_audio.${streamAudioInfo.container.name}');
    var videoFilePath = path.join(
        appDocDir.path, '${video.id}_video.${streamVideoInfo.container.name}');
    var outputFilePath = path.join(appDocDir.path, '${time}.mp4');
    var audioFile = File(audioFilePath);
    var videoFile = File(videoFilePath);

    // Write video and audio info into a file
    var audioFileStream = audioFile.openWrite();
    var videoFileStream = videoFile.openWrite();
    await audioStream.pipe(audioFileStream);
    await videoStream.pipe(videoFileStream);

    // Close the files
    await audioFileStream.flush();
    await audioFileStream.close();
    await videoFileStream.flush();
    await videoFileStream.close();

    // Merge audio and video using ffmpeg_kit_flutter
    var mergeCommand =
        '-i $videoFilePath -i $audioFilePath -c:v copy -c:a aac $outputFilePath';
    var mergeResult = await runFFmpeg(mergeCommand);

    if (mergeResult == 'success') {
      print('Download and merge successful: $outputFilePath');
      print('Video saved: ${videoFile.path}');
      print('Video title: ${video.title}');
    } else {
      print('Error during merging: $mergeResult');
    }

    // Clean up temporary files
    await audioFile.delete();
    await videoFile.delete();

    yt.close();

    // hold the video information
    // TODO Get the size of the video file
    localVideo = LocalVideo(
      vid: time,
      path: outputFilePath,
      playlistIDs: [],
      lastPlayedAt: DateTime.now(),
      thumbnailFilePath: video.thumbnails.highResUrl,
      title: video.title,
      volume: 1,
      length: video.duration?.inMinutes ?? 0,
    );
    return localVideo;
  }
}

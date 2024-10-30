import 'dart:io';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tamadrop/main.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:path/path.dart' as path;

class Download extends StatelessWidget {
  const Download({super.key});

  @override
  Widget build(BuildContext context) {
    void _saveVideo(File videoFile, String videoTitle) {
      // Implement your save logic here
      print('Video saved: ${videoFile.path}');
      print('Video title: $videoTitle');
    }

    Future<String> runFFmpeg(String command) async {
      var session = await FFmpegKit.execute(command);
      var returnCode = await session.getReturnCode();
      if (ReturnCode.isSuccess(returnCode)) {
        return 'success';
      } else {
        return (await session.getOutput())!;
      }
    }

    void _downloadVideo(String url) async {
      var yt = YoutubeExplode();

      // Fetch video metadata
      var video = await yt.videos.get(url);
      var videoTitle = video.title;

      // Get the video stream manifest
      StreamManifest manifest = await yt.videos.streams.getManifest(video.id);

      // Check if there are any audio-only and video-only streams available
      if (manifest.audioOnly.isEmpty || manifest.videoOnly.isEmpty) {
        print('No audio or video streams available for this video.');
        return;
      }

      // Get the highest bitrate audio and video streams
      var streamAudioInfo = manifest.audioOnly.withHighestBitrate();
      var streamVideoInfo = manifest.videoOnly.withHighestBitrate();

      // Get the actual byte streams
      var audioStream = yt.videos.streams.get(streamAudioInfo);
      var videoStream = yt.videos.streams.get(streamVideoInfo);

      // Define the file paths
      var appDocDir = await getApplicationDocumentsDirectory();
      var audioFilePath = path.join(appDocDir.path,
          '${video.id}_audio.${streamAudioInfo.container.name}');
      var videoFilePath = path.join(appDocDir.path,
          '${video.id}_video.${streamVideoInfo.container.name}');
      var outputFilePath = path.join(appDocDir.path, '${video.title}.mp4');
      var audioFile = File(audioFilePath);
      var videoFile = File(videoFilePath);

      // Open files for writing
      var audioFileStream = audioFile.openWrite();
      var videoFileStream = videoFile.openWrite();

      // Pipe all the content of the streams into the files
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
        _saveVideo(File(outputFilePath), video.title);
      } else {
        print('Error during merging: $mergeResult');
      }

      // Clean up temporary files
      await audioFile.delete();
      await videoFile.delete();
      // await File(convertedAudioFilePath).delete();

      yt.close();
      youtubeVideoPath = outputFilePath;
      // youtubeAudioPath = audioFile.path;
    }

    return ElevatedButton(
        onPressed: () {
          print("pushed");
          String videoUrl =
              'https://www.youtube.com/watch?v=lnHyrRmmZGs'; // Replace with user input
          _downloadVideo(videoUrl);
        },
        child: Text("download"));
  }
}

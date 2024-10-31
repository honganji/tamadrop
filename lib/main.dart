import 'package:ffmpeg_kit_flutter_audio/ffmpeg_kit_config.dart';
import 'package:flutter/material.dart';
import 'package:tamadrop/app.dart';

// TODO use Bloc pattern
var youtubeVideoPath = "";
var youtubeAudioPath = "";
void main() {
  // TODO delete
  FFmpegKitConfig.enableLogCallback((log) {
    print(log.getMessage());
  });
  runApp(MainApp());
}

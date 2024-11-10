import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VideoPlayerControl extends StatelessWidget {
  const VideoPlayerControl({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlickPortraitControls(
          fontSize: 14,
          iconSize: 30,
          progressBarSettings: FlickProgressBarSettings(
            height: 5,
          ),
        ),
        Positioned.fill(
          right: 20,
          top: 10,
          child: GestureDetector(
            onTap: () {
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                  overlays: SystemUiOverlay.values);
              SystemChrome.setPreferredOrientations(
                  [DeviceOrientation.portraitUp]);
            },
            child: const Icon(
              Icons.cancel,
              size: 30,
            ),
          ),
        ),
      ],
    );
  }
}

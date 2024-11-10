import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';

/// Default portrait controls.
class NormalScreenControl extends StatelessWidget {
  final FlickManager flickManager;
  final List<String> videoPathlist;
  final ValueNotifier<int> currentIndexNotifier;
  final int index;
  final double iconSize;
  final double fontSize;
  final FlickProgressBarSettings? progressBarSettings;
  const NormalScreenControl(this.flickManager, this.videoPathlist, this.index,
      this.currentIndexNotifier,
      {Key? key,
      this.iconSize = 20,
      this.fontSize = 12,
      this.progressBarSettings})
      : super(key: key);

  void _skipToNextVideo() {
    int currentIndex = currentIndexNotifier.value;
    if (currentIndex < videoPathlist.length - 1) {
      currentIndexNotifier.value = currentIndex + 1;
      flickManager.handleChangeVideo(
          VideoPlayerController.file(File(videoPathlist[currentIndex + 1])));
    } else {
      currentIndexNotifier.value = 0;
      flickManager.handleChangeVideo(
          VideoPlayerController.file(File(videoPathlist[0])));
    }
  }

  void _skipToPreviousVideo() {
    int currentIndex = currentIndexNotifier.value;
    if (currentIndex > 0) {
      currentIndexNotifier.value = currentIndex - 1;
      flickManager.handleChangeVideo(
          VideoPlayerController.file(File(videoPathlist[currentIndex - 1])));
    } else {
      currentIndexNotifier.value = videoPathlist.length - 1;
      flickManager.handleChangeVideo(VideoPlayerController.file(
          File(videoPathlist[videoPathlist.length - 1])));
    }
  }

  void _skipSecs(int secs) {
    final currentPosition =
        flickManager.flickVideoManager!.videoPlayerController!.value.position;
    final skipDuration = Duration(seconds: secs);
    flickManager.flickVideoManager!.videoPlayerController!
        .seekTo(currentPosition + skipDuration);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: FlickShowControlsAction(
            child: FlickSeekVideoAction(
              child: Center(
                child: FlickVideoBuffer(
                  child: FlickAutoHideChild(
                    showIfVideoNotInitialized: false,
                    child: FlickPlayToggle(
                      size: 30,
                      color: Colors.black,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const FlickVideoWithControls(
          controls: FlickPortraitControls(),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          right: 0,
          left: 0,
          child: FlickAutoHideChild(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => _skipSecs(-10),
                      child: const Icon(
                        Icons.replay_10,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: _skipToPreviousVideo,
                      child: const Icon(
                        Icons.skip_previous,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Spacer(),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => _skipSecs(10),
                      child: const Icon(
                        Icons.forward_10,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: _skipToNextVideo,
                      child: const Icon(
                        Icons.skip_next,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tamadrop/features/player/presentation/components/normal_screen_control.dart';
import 'package:tamadrop/features/player/presentation/cubits/video_player_cubit.dart';
import 'package:video_player/video_player.dart';
import 'package:flick_video_player/flick_video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  final int index;
  const VideoPlayerPage({
    super.key,
    required this.index,
  });

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayerPage> {
  late FlickManager flickManager;
  List<String> videoPathList = [];
  late ValueNotifier<int> currentIndexNotifier;

  @override
  void initState() {
    super.initState();
    final videoCubit = context.read<VideoPlayerCubit>();
    currentIndexNotifier = ValueNotifier<int>(widget.index);
    videoPathList = videoCubit.videoList.map((video) => video.path).toList();
    flickManager = FlickManager(
        videoPlayerController:
            VideoPlayerController.file(File(videoPathList[widget.index])));
    flickManager.flickVideoManager!.videoPlayerController!
        .addListener(_videoListener);
  }

  @override
  void dispose() {
    flickManager.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  void _videoListener() {
    final controller = flickManager.flickVideoManager!.videoPlayerController;
    if (controller!.value.position == controller.value.duration) {
      _playNextVideo();
    }
  }

  void _playNextVideo() {
    int currentIndex = currentIndexNotifier.value;
    if (currentIndex < videoPathList.length - 1) {
      currentIndexNotifier.value = currentIndex + 1;
      flickManager.handleChangeVideo(
        VideoPlayerController.file(
          File(videoPathList[currentIndexNotifier.value]),
        ),
      );
    } else {
      currentIndexNotifier.value = 0;
      flickManager.handleChangeVideo(
        VideoPlayerController.file(
          File(videoPathList[currentIndexNotifier.value]),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Video Player"),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: Center(
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: SafeArea(
              child: FlickVideoPlayer(
                flickManager: flickManager,
                flickVideoWithControls: FlickVideoWithControls(
                  closedCaptionTextStyle: const TextStyle(fontSize: 8),
                  controls: NormalScreenControl(
                    flickManager,
                    videoPathList,
                    widget.index,
                    currentIndexNotifier,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

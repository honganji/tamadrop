import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tamadrop/features/player/presentation/components/video_player_control.dart';
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

  @override
  void initState() {
    super.initState();
    final videoCubit = context.read<VideoPlayerCubit>();
    List<String> videoPathList =
        videoCubit.videoList.map((video) => video.path).toList();
    flickManager = FlickManager(
        videoPlayerController:
            VideoPlayerController.file(File(videoPathList[widget.index])));
  }

  @override
  void dispose() {
    flickManager.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
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
            child: FlickVideoPlayer(
              flickManager: flickManager,
              flickVideoWithControls: const FlickVideoWithControls(
                closedCaptionTextStyle: TextStyle(fontSize: 8),
                controls: FlickPortraitControls(),
              ),
              flickVideoWithControlsFullscreen: const VideoPlayerControl(),
            ),
          ),
        ),
      ),
    );
  }
}

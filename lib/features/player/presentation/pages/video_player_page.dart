import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tamadrop/features/download/domain/entities/video.dart';
import 'package:tamadrop/features/player/presentation/cubits/video_player_cubit.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  final List<LocalVideo> videos;
  final int index;
  const VideoPlayerPage({
    super.key,
    required this.videos,
    required this.index,
  });

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;

  List<String> videoPathList =
      widget.videos.map((video) => video.path).toList();
  @override
  void initState() {
    super.initState();
    final videoCubit = context.read<VideoPlayerCubit>();
    List<String> videoPathList =
        videoCubit.videoList.map((video) => video.path).toList();
    if (videoPathList[widget.index].startsWith("assets")) {
      _controller = VideoPlayerController.asset(widget.videoPaths[widget.index])
        ..initialize().then((_) {
          setState(() {});
        });
    } else {
      _controller =
          VideoPlayerController.file(File(widget.videoPaths[widget.index]))
            ..initialize().then((_) {
              setState(() {});
            });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video Player"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _controller.value.isPlaying
                    ? _controller.pause()
                    : _controller.play();
              });
            },
            child: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

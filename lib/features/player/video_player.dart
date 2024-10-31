import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerContainer extends StatefulWidget {
  final String videoPath;
  const VideoPlayerContainer({
    super.key,
    required this.videoPath,
  });

  @override
  State<VideoPlayerContainer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayerContainer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {});
      });
    // _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoPath))
    //   ..initialize().then((_) {
    //     setState(() {});
    //   });
    // _controller = VideoPlayerController.file(File(widget.videoPath));
    // await _controller.initialize();
    // setState(() {});
    print(widget.videoPath);
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
        title: Text("Video Player"),
      ),
      body: Column(
        children: [
          Center(
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : Container(),
          ),
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
          // FloatingActionButton(
          //   onPressed: () => {
          //     print(widget.videoPath),
          //     _controller = VideoPlayerController.networkUrl(
          //         Uri.parse(widget.videoPath ?? ""))
          //       ..initialize().then((_) {
          //         // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          //         setState(() {});
          //       })
          //   },
          //   child: Icon(Icons.replay_outlined),
          // ),
          Text("Enjoy this app")
        ],
      ),
    );
  }
}

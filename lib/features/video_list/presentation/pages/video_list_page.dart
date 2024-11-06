import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tamadrop/features/download/presentation/cubits/video_cubit.dart';
import 'package:tamadrop/features/layout/presentation/cubits/layout_cubit.dart';
import 'package:tamadrop/features/layout/presentation/cubits/progress_cubit.dart';
import 'package:tamadrop/features/player/presentation/cubits/video_player_cubit.dart';
import 'package:tamadrop/features/player/presentation/cubits/video_player_states.dart';
import 'package:tamadrop/features/playlist/domain/entities/playlist.dart';
import 'package:tamadrop/features/playlist/presentation/pages/playlist_page.dart';
import 'package:tamadrop/features/video_list/presentation/components/video_box.dart';

class VideoListPage extends StatelessWidget {
  final Playlist playlist;
  const VideoListPage({required this.playlist, super.key});

  @override
  Widget build(BuildContext context) {
    final videoPlayerCubit = context.read<VideoPlayerCubit>();
    final layoutCubit = context.read<LayoutCubit>();
    videoPlayerCubit.getCategorizedVideo(playlist.pid);
    return SafeArea(
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            layoutCubit.switchPage(const PlaylistPage(), null);
          }
        },
        child: Column(
          children: [
            Text(playlist.name),
            BlocListener<VideoCubit, void>(
              listener: (context, state) => videoPlayerCubit.getAllVideos(),
              child: BlocConsumer<VideoPlayerCubit, VideoPlayerState>(
                builder: (context, state) {
                  if (state is VideoPlayerLoaded) {
                    final videos = state.localVideos;
                    return Expanded(
                      child: ListView.builder(
                        itemCount: videos.length,
                        itemBuilder: (context, index) {
                          final video = videos[index];
                          return VideoBox(video);
                        },
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
                listener: (context, state) {
                  if (state is VideoPlayerError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          state.toString(),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            BlocBuilder<ProgressCubit, double>(
              builder: (context, progress) {
                return Container(
                  margin: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      const Text(
                        "Progress: ",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("${(progress).toStringAsFixed(1)} %")
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

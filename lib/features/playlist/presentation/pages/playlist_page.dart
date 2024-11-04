import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tamadrop/features/player/presentation/cubits/video_player_cubit.dart';
import 'package:tamadrop/features/player/presentation/cubits/video_player_states.dart';
import 'package:tamadrop/features/playlist/presentation/components/video_box.dart';

class PlaylistPage extends StatelessWidget {
  const PlaylistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final videoPlayerCubit = context.read<VideoPlayerCubit>();
    videoPlayerCubit.getAllVideos();
    return BlocConsumer<VideoPlayerCubit, VideoPlayerState>(
      builder: (context, state) {
        if (state is VideoPlayerLoaded) {
          return Center(
            child: Column(
              children: state.localVideos.map((localVideo) {
                return VideoBox(localVideo);
              }).toList(),
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
    );
  }
}

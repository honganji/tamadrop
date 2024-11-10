import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tamadrop/features/layout/presentation/cubits/layout_cubit.dart';
import 'package:tamadrop/features/player/presentation/cubits/video_player_cubit.dart';
import 'package:tamadrop/features/playlist/domain/entities/playlist.dart';
import 'package:tamadrop/features/video_list/presentation/pages/video_list_page.dart';

class PlaylistBox extends StatelessWidget {
  final Playlist playlist;
  final ValueNotifier<bool> playNotifier;
  const PlaylistBox(
      {required this.playlist, required this.playNotifier, super.key});

  @override
  Widget build(BuildContext context) {
    final layoutCubit = context.read<LayoutCubit>();
    return GestureDetector(
      onTap: () {
        layoutCubit.switchPage(
            VideoListPage(playlist: playlist), playlist.name);
      },
      child: SizedBox(
        height: 60,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context)
                  .colorScheme
                  .inversePrimary, // Specify the border color
              width: 2, // Specify the border width
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                playlist.name,
                style: const TextStyle(fontSize: 20),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  final videoPlayerCubit = context.read<VideoPlayerCubit>();
                  await videoPlayerCubit.getCategorizedVideo(playlist.pid);
                  if (videoPlayerCubit.videoList.isNotEmpty) {
                    playNotifier.value = true;
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No video in the playlist'),
                      ),
                    );
                  }
                },
                child: Icon(
                  Icons.play_circle,
                  size: 32,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

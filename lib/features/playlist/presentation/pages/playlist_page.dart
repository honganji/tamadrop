import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tamadrop/features/playlist/presentation/components/playlist_box.dart';
import 'package:tamadrop/features/playlist/presentation/cubits/playlist_cubit.dart';

class PlaylistPage extends StatelessWidget {
  const PlaylistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final playlistCubit = context.read<PlaylistCubit>();
    playlistCubit.getAllPlaylists();
    return BlocBuilder<PlaylistCubit, bool>(
      builder: (context, state) {
        if (state) {
          final playlists = playlistCubit.playlists;
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: playlists.length,
                  itemBuilder: (context, index) {
                    final playlist = playlists[index];
                    return PlaylistBox(playlist: playlist);
                  },
                ),
              ),
            ],
          );
        } else {
          return const SafeArea(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

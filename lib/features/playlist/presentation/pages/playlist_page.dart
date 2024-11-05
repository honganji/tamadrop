import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tamadrop/features/layout/presentation/cubits/layout_cubit.dart';
import 'package:tamadrop/features/playlist/presentation/components/playlist_box.dart';
import 'package:tamadrop/features/playlist/presentation/cubits/playlist_cubit.dart';

class PlaylistPage extends StatelessWidget {
  const PlaylistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final playlistCubit = context.read<PlaylistCubit>();
    final layoutCubit = context.read<LayoutCubit>();
    playlistCubit.getAllPlaylists();
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 2000),
      transitionBuilder: (Widget child, Animation<double> animation) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(-1.0, 0.0), // Slide in from right
          end: Offset.zero,
        ).animate(animation);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      child: Container(
        key: ValueKey(layoutCubit.page.runtimeType),
        child: layoutCubit.page is PlaylistPage
            ? BlocBuilder<PlaylistCubit, bool>(
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
              )
            : null,
      ),
    );
  }
}

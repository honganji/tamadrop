import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tamadrop/features/constants/size.dart';
import 'package:tamadrop/features/playlist/presentation/components/playlist_box.dart';
import 'package:tamadrop/features/playlist/presentation/cubits/playlist_cubit.dart';
import 'package:tamadrop/features/playlist/presentation/cubits/playlist_states.dart';

class PlaylistPage extends StatelessWidget {
  const PlaylistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final playlistCubit = context.read<PlaylistCubit>();
    playlistCubit.getAllPlaylists();

    return BlocBuilder<PlaylistCubit, PlaylistState>(
      builder: (context, state) {
        if (state is PlaylistLoaded) {
          final playlists = playlistCubit.playlists;
          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: constraints.maxHeight -
                            BOTTOM_SAFE_AREA -
                            56, // 56 is the height of the button
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: playlists.length,
                        itemBuilder: (context, index) {
                          final playlist = playlists[index];
                          return PlaylistBox(playlist: playlist);
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            final TextEditingController textController =
                                TextEditingController();
                            return AlertDialog(
                              title: const Text('Add Playlist'),
                              content: TextField(
                                controller: textController,
                                decoration: const InputDecoration(
                                  labelText: 'Playlist Name',
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    final String name = textController.text;
                                    if (name.isNotEmpty) {
                                      playlistCubit.addPlaylist(name);
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    }
                                  },
                                  child: const Text('Add'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text('Add Playlist'),
                    ),
                    const SizedBox(
                      height: BOTTOM_SAFE_AREA,
                    ),
                  ],
                ),
              );
            },
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

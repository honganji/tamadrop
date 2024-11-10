import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tamadrop/features/download/presentation/components/my_text_field.dart';
import 'package:tamadrop/features/download/presentation/cubits/video_cubit.dart';
import 'package:tamadrop/features/download/presentation/cubits/video_states.dart';
import 'package:tamadrop/features/layout/presentation/cubits/layout_cubit.dart';
import 'package:tamadrop/features/download/presentation/cubits/progress_cubit.dart';
import 'package:tamadrop/features/playlist/domain/entities/playlist.dart';

class DownloadPage extends StatefulWidget {
  final List<Playlist> playlists;
  const DownloadPage({required this.playlists, super.key});

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  final textController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  int? selectedOption;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    final videoCubit = context.read<VideoCubit>();
    final layoutCubit = context.read<LayoutCubit>();
    void downloadVideo() {
      final String url = textController.text;
      if (url.isEmpty) {
        layoutCubit.emitError("The url is empty...");
      } else {
        videoCubit.downloadVideo(url, selectedOption);
      }
    }

    return BlocConsumer<VideoCubit, VideoState>(
      builder: (context, state) {
        if (state is VideoLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(),
                ),
                BlocBuilder<ProgressCubit, double>(
                  builder: (context, progress) {
                    return Column(
                      children: [
                        const Text(
                          "Progress: ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text((progress).toStringAsFixed(1))
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  child: MyTextField(
                    controller: textController,
                    hintText: "https://www.youtube.com/watch?v=...",
                    labelText: "Youtube URL",
                    focusNode: focusNode,
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButton<int>(
                  value: selectedOption,
                  hint: const Text('playlist'),
                  items: widget.playlists
                      .where((playlist) => playlist.name != "all")
                      .map((Playlist playlist) {
                    return DropdownMenuItem<int>(
                      value: playlist.pid,
                      child: Text(playlist.name),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedOption = newValue;
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    downloadVideo();
                    textController.clear();
                    setState(() {
                      selectedOption = null;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1,
                    ),
                    shadowColor: Theme.of(context).colorScheme.inversePrimary,
                    elevation: 5,
                  ),
                  child: const Text("download"),
                ),
              ],
            ),
          );
        }
      },
      listener: (context, state) {
        if (state is VideoError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:tamadrop/features/download/presentation/components/my_text_field.dart';
import 'package:tamadrop/features/download/presentation/cubits/video_cubit.dart';
import 'package:tamadrop/features/download/presentation/cubits/video_states.dart';
import 'package:tamadrop/features/layout/presentation/cubits/layout_cubit.dart';
import 'package:tamadrop/features/layout/presentation/cubits/progress_cubit.dart';

class DownloadPage extends StatelessWidget {
  const DownloadPage({super.key});

  @override
  Widget build(BuildContext context) {
    final videoCubit = context.read<VideoCubit>();
    final textController = TextEditingController();
    final layoutCubit = context.read<LayoutCubit>();
    void downloadVideo() {
      final String url = textController.text;
      if (url.isEmpty) {
        layoutCubit.emitError("The url is empty...");
      } else {
        // TODO enable to choose which playlist to add to
        videoCubit.downloadVideo(url, 1);
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
                const Text(
                  'Enter YouTube URL:',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  child: MyTextField(
                      controller: textController,
                      hintText: "https://www.youtube.com/watch?v=..."),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      downloadVideo();
                      textController.clear();
                    },
                    child: Text("download")),
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
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
    );
  }
}

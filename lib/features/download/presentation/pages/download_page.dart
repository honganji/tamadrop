import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tamadrop/features/download/presentation/components/my_text_field.dart';
import 'package:tamadrop/features/download/presentation/cubits/video_cubit.dart';
import 'package:tamadrop/features/download/presentation/cubits/video_states.dart';

class DownloadPage extends StatelessWidget {
  DownloadPage({super.key});

  @override
  Widget build(BuildContext context) {
    final videoCubit = context.read<VideoCubit>();
    final textController = TextEditingController();
    void downloadVideo() {
      final String url = textController.text;
      if (url.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("The url is empty...")));
      } else {
        print(url);
        videoCubit.downloadVideo(url);
      }
    }

    return BlocConsumer<VideoCubit, VideoState>(
      builder: (context, state) {
        if (state is VideoLoading) {
          return const Center(
            child: SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(),
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
            ),
          );
        }
      },
    );
  }
}

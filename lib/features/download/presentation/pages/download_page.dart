import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tamadrop/features/download/presentation/cubits/video_cubit.dart';
import 'package:tamadrop/features/download/presentation/cubits/video_states.dart';

class Download extends StatelessWidget {
  Download({super.key});

  @override
  Widget build(BuildContext context) {
    final videoCubit = context.read<VideoCubit>();
    void downloadVideo(String url) {
      videoCubit.downloadVideo(url);
    }

    return BlocConsumer<VideoCubit, VideoState>(
      builder: (context, state) {
        if (state is VideoLoading) {
          return CircularProgressIndicator();
        } else {
          return ElevatedButton(
              onPressed: () {
                print("pushed");
                // TODO make it able to get the url from the frontend
                String videoUrl =
                    'https://www.youtube.com/watch?v=JJLt1KFR6fA&list=RDJJLt1KFR6fA&index=1';
                downloadVideo(videoUrl);
              },
              child: Text("download"));
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

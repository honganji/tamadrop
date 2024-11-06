import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tamadrop/features/download/domain/entities/video.dart';
import 'package:tamadrop/features/download/presentation/cubits/video_cubit.dart';
import 'package:tamadrop/features/download/presentation/cubits/video_states.dart';
import 'package:tamadrop/features/player/presentation/pages/video_player_page.dart';

class VideoBox extends StatelessWidget {
  final LocalVideo localVideo;
  const VideoBox(this.localVideo, {super.key});

  String formatDuration(int seconds) {
    final int hours = seconds ~/ 3600;
    final int minutes = (seconds % 3600) ~/ 60;
    final int remainingSeconds = seconds % 60;

    final String hoursStr = '${hours.toString().padLeft(2, '0')}:';
    final String minutesStr = '${minutes.toString().padLeft(2, '0')}:';
    final String secondsStr = remainingSeconds.toString().padLeft(2, '0');

    return '$hoursStr$minutesStr$secondsStr';
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('d/M/yyyy HH:mm:ss');
    final String formattedDate = formatter.format(localVideo.createdAt);
    final videoCubit = context.read<VideoCubit>();
    return BlocBuilder<VideoCubit, VideoState>(builder: (context, state) {
      if (state is VideoDeleting && state.vid == localVideo.vid) {
        return const Center(child: CircularProgressIndicator());
      }
      return Container(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: const BorderRadius.all(
            Radius.circular(2),
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        width: double.infinity,
        height: 72,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            VideoPlayerPage(videoPath: localVideo.path)));
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      height: 80,
                      width: 80,
                      child: Image.asset(localVideo.thumbnailFilePath),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Text(
                            localVideo.title.trimLeft(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          )),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          Text(
                            formattedDate,
                            style: TextStyle(
                              fontSize: 11,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            "${localVideo.volume.toString()}MB",
                            style: TextStyle(
                              fontSize: 11,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            formatDuration(localVideo.length),
                            style: TextStyle(
                              fontSize: 11,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Do you wanna delete this video?'),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                videoCubit.deleteVideo(localVideo);
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
              child: Icon(
                Icons.edit_note_sharp,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
            )
          ],
        ),
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tamadrop/features/download/domain/entities/video.dart';
import 'package:tamadrop/features/player/presentation/pages/video_player_page.dart';

class VideoBox extends StatelessWidget {
  final LocalVideo localVideo;
  const VideoBox(this.localVideo, {super.key});

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('d/M/yyyy HH:mm:ss');
    final String formattedDate = formatter.format(localVideo.lastPlayedAt);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      width: double.infinity,
      height: 72,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              print(localVideo.path);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          VideoPlayerPage(videoPath: localVideo.path)));
            },
            child: Row(
              children: [
                SizedBox(
                  height: 44,
                  width: 44,
                  child: Image.asset(localVideo.thumbnailFilePath),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: 240,
                        child: Text(
                          localVideo.title.trimLeft(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12),
                        )),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(formattedDate),
                  ],
                )
              ],
            ),
          ),
          Spacer(),
          Icon(
            Icons.edit_note_sharp,
            size: 48,
            color: Theme.of(context).colorScheme.primary,
          )
        ],
      ),
    );
  }
}

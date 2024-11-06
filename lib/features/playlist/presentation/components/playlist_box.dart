import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tamadrop/features/layout/presentation/cubits/layout_cubit.dart';
import 'package:tamadrop/features/video_list/presentation/pages/video_list_page.dart';

class PlaylistBox extends StatelessWidget {
  final playlist;
  const PlaylistBox({required this.playlist, super.key});

  @override
  Widget build(BuildContext context) {
    final layoutCubit = context.read<LayoutCubit>();
    return SizedBox(
      height: 60,
      width: MediaQuery.of(context).size.width * 0.9,
      child: GestureDetector(
        onTap: () {
          layoutCubit.switchPage(VideoListPage(playlist: playlist));
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black, // Specify the border color
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
                style: TextStyle(fontSize: 20),
              )
            ],
          ),
        ),
      ),
    );
  }
}

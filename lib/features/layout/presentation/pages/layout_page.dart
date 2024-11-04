import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tamadrop/features/download/presentation/pages/download_page.dart';
import 'package:tamadrop/features/layout/presentation/cubits/layout_cubit.dart';
import 'package:tamadrop/features/playlist/presentation/pages/playlist_page.dart';
import 'package:tamadrop/features/themes/theme_cubit.dart';
import 'package:toggle_switch/toggle_switch.dart';

class LayoutPage extends StatelessWidget {
  const LayoutPage({super.key});
  // TEST
  final bool isDownload = true;
  @override
  Widget build(BuildContext context) {
    final themeCubit = context.watch<ThemeCubit>();
    final layoutCubit = context.watch<LayoutCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tama Drop'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CupertinoSwitch(
                value: themeCubit.isDarkMode,
                onChanged: (value) {
                  themeCubit.toggleTheme();
                }),
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Stack(children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        final offsetAnimation = Tween<Offset>(
                          begin: const Offset(-1.0, 0.0), // Slide in from right
                          end: Offset.zero,
                        ).animate(animation);

                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                      child: !layoutCubit.isDownloadPage
                          ? Container(
                              key: ValueKey<bool>(layoutCubit.isDownloadPage),
                              // child: VideoPlayerPage(
                              //   videoPath: videoCubit.localVideo != null
                              //       ? videoCubit.localVideo!.path
                              //       : "assets/Frieren_video.mp4",
                              // ),
                              child: const PlaylistPage(),
                            )
                          : null,
                    ),
                    AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          final offsetAnimation = Tween<Offset>(
                            begin:
                                const Offset(1.0, 0.0), // Slide in from right
                            end: Offset.zero,
                          ).animate(animation);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                        child: layoutCubit.isDownloadPage
                            ? Container(
                                width: double.infinity,
                                height: double.infinity,
                                key: ValueKey<bool>(layoutCubit.isDownloadPage),
                                child: DownloadPage(),
                              )
                            : null),
                  ]),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 24.0,
            left: 0,
            right: 0,
            child: Center(
              child: ToggleSwitch(
                cornerRadius: 20.0,
                initialLabelIndex: layoutCubit.isDownloadPage ? 1 : 0,
                totalSwitches: 2,
                labels: const ['', ''],
                icons: const [Icons.play_arrow, Icons.download],
                activeBgColor: [Colors.green[200]!],
                onToggle: (index) {
                  layoutCubit.switchPage(index != 1);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

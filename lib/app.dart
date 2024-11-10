import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tamadrop/features/download/data/download_video_repo.dart';
import 'package:tamadrop/features/download/presentation/cubits/video_cubit.dart';
import 'package:tamadrop/features/layout/presentation/cubits/layout_cubit.dart';
import 'package:tamadrop/features/download/presentation/cubits/progress_cubit.dart';
import 'package:tamadrop/features/layout/presentation/pages/layout_page.dart';
import 'package:tamadrop/features/player/presentation/cubits/video_player_cubit.dart';
import 'package:tamadrop/features/playlist/presentation/cubits/playlist_cubit.dart';
import 'package:tamadrop/features/storage/data/sqflite_storage_repo.dart';
import 'package:tamadrop/features/themes/theme_cubit.dart';

class MainApp extends StatelessWidget {
  final sqfliteStorageRepo = SqfliteStorageRepo();
  MainApp({super.key});
  Future<void> initializeDB() async {
    await sqfliteStorageRepo.initializeDB();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeDB(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Error initializing database'),
              ),
            ),
          );
        } else {
          return MultiBlocProvider(
            providers: [
              BlocProvider<ProgressCubit>(
                create: (context) => ProgressCubit(),
              ),
              BlocProvider<ThemeCubit>(
                create: (context) => ThemeCubit(),
              ),
              BlocProvider<VideoCubit>(
                create: (context) => VideoCubit(
                  downloadVideoRepo:
                      DownloadVideoRepo(context.read<ProgressCubit>()),
                  storageRepo: sqfliteStorageRepo,
                ),
              ),
              BlocProvider<LayoutCubit>(
                create: (context) => LayoutCubit(),
              ),
              BlocProvider<VideoPlayerCubit>(
                create: (context) => VideoPlayerCubit(sqfliteStorageRepo),
              ),
              BlocProvider<PlaylistCubit>(
                create: (context) => PlaylistCubit(sqfliteStorageRepo),
              ),
            ],
            child: BlocBuilder<ThemeCubit, ThemeData>(
              builder: (context, currentTheme) => MaterialApp(
                theme: currentTheme,
                home: const LayoutPage(),
              ),
            ),
          );
        }
      },
    );
  }
}

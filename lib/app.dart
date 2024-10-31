import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tamadrop/features/download/data/download_video_repo.dart';
import 'package:tamadrop/features/download/presentation/cubits/video_cubit.dart';
import 'package:tamadrop/features/download/presentation/pages/download_page.dart';
import 'package:tamadrop/features/player/video_player.dart';
import 'package:tamadrop/features/themes/theme_cubit.dart';

class MainApp extends StatelessWidget {
  final downloadVideoRepo = DownloadVideoRepo();
  MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider<VideoCubit>(
          create: (context) => VideoCubit(downloadVideoRepo: downloadVideoRepo),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, currentTheme) => MaterialApp(
          title: 'YouTube Downloader',
          theme: currentTheme,
          home: MyHomePage(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final videoCubit = context.read<VideoCubit>();
    return Scaffold(
      appBar: AppBar(
        title: Text('YouTube Downloader'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Enter YouTube URL:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Container(
              width: 300,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'https://www.youtube.com/watch?v=...',
                ),
              ),
            ),
            SizedBox(height: 20),
            Download(),
            ElevatedButton(
              onPressed: () {
                if (videoCubit.localVideo != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPlayerContainer(
                        videoPath: videoCubit.localVideo!.path,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("There is no url of video"),
                    ),
                  );
                }
              },
              child: Icon(Icons.play_arrow),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:ffmpeg_kit_flutter/ffmpeg_kit_config.dart';
import 'package:flutter/material.dart';
import 'package:tamadrop/features/download/download.dart';
import 'package:tamadrop/features/player/video_player.dart';

// TODO use Bloc pattern
var youtubeVideoPath = "";
var youtubeAudioPath = "";
void main() {
  // TODO delete
  FFmpegKitConfig.enableLogCallback((log) {
    print(log.getMessage());
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTube Downloader',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoPlayerContainer(
                      videoPath: youtubeVideoPath,
                    ),
                  ),
                );
              },
              child: Icon(Icons.play_arrow),
            )
          ],
        ),
      ),
    );
  }
}

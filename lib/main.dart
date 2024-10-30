import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() {
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
  void _saveVideo(File videoFile, String videoTitle) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final savePath = appDocDir.path + '/$videoTitle.mp4';

    final videoBytes = await videoFile.readAsBytes();
    final File file = File(savePath);

    await file.writeAsBytes(videoBytes);

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Successed!!")));
  }

  void _downloadVideo(String url) async {
    var ytExplode = YoutubeExplode();
    var video = await ytExplode.videos.get(url);

    var manifest = await ytExplode.videos.streamsClient.getManifest(video);

    var streamInfo = manifest.audioOnly.first;
    var videoStream = manifest.video.first;

    var audioStream = ytExplode.videos.streamsClient.get(streamInfo);
    var videoFile = await ytExplode.videos.streamsClient.get(videoStream);

    _saveVideo(videoFile, videoTitle);
  }

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
            Text(
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
            ElevatedButton(
              onPressed: () {
                ElevatedButton(
                  onPressed: () {
                    String videoUrl =
                        'https://www.youtube.com/watch?v=32ZbGBkWoeo'; // Replace with user input
                    _downloadVideo(videoUrl);
                  },
                  child: Text('Download Video'),
                );
              },
              child: Text('Download Video'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:tamadrop/features/download/domain/entities/video.dart';
import 'package:tamadrop/features/storage/domain/repos/storage_repo.dart';

class SqfliteStorageRepo implements StorageRepo {
  Database? db;
  @override
  Future<void> initializeDB() async {
    // Get the database path
    final dbPath = await getDatabasesPath();

    // Set the database path
    final path = join(dbPath, 'tamadrop_database.db');

    // Open the database and define tables
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE videos (
          vid TEXT PRIMARY KEY,
          path TEXT,
          playlist_ids TEXT,
          last_play_at TEXT,
          thumbnail_file_path TEXT,
          title TEXT,
          volume INTEGER,
          length INTEGER
        )
      ''');
      },
    );
  }

  @override
  Future<void> storeVideo(LocalVideo video) async {
    if (db != null) {
      await db!.insert('videos', video.toJson());
      // TODO remove
      print("Stored data properly");
    } else {
      throw Exception("Database is not initialized properly...");
    }
  }

  // TODO modify to get the videos which related to specific playlist
  @override
  Future<List<LocalVideo>> getCategorizedVideo(int categoryId) async {
    if (db != null) {
      List<Map<String, dynamic>> dataList = await db!.query("videos");
      return List<LocalVideo>.from(
          dataList.map((video) => LocalVideo.fromJson(video)));
    } else {
      throw Exception("Failed to get data...");
    }
  }

  @override
  Future<List<LocalVideo>> getAllVideos() async {
    if (db != null) {
      List<Map<String, dynamic>> dataList = await db!.query("videos");
      List<LocalVideo> localVideoList = List<LocalVideo>.from(
          dataList.map((video) => LocalVideo.fromJson(video)));
      return localVideoList;
    } else {
      throw Exception("Failed to get data...");
    }
  }

  @override
  Future<void> updateVideo(LocalVideo newVideo, String videoId) async {
    if (db != null) {
      await db!.update(
        "videos",
        newVideo.toJson(),
        where: "vid = ?",
        whereArgs: [videoId],
      );
    } else {
      throw Exception("Failed to update data");
    }
  }

  @override
  Future<void> deleteVideo(LocalVideo video) async {
    if (db != null) {
      await File(video.path).delete();
      await File(video.thumbnailFilePath).delete();
      await db!.delete(
        "videos",
        where: "vid = ?",
        whereArgs: [video.vid],
      );
    } else {
      throw Exception("Failed to delete data");
    }
  }
}

import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:tamadrop/features/download/domain/entities/video.dart';
import 'package:tamadrop/features/storage/domain/repos/storage_repo.dart';
import 'package:path/path.dart' as path;

class SqfliteStorageRepo implements StorageRepo {
  Database? db;
  int? _allPid;
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
          created_at TEXT,
          thumbnail_file_path TEXT,
          title TEXT,
          volume INTEGER,
          length INTEGER
        )
      ''');

        await db.execute('''
      CREATE TABLE playlists (
        pid INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT
      )
    ''');

        await db.execute('''
      CREATE TABLE playlist_videos (
        pid INTEGER,
        vid TEXT,
        FOREIGN KEY (pid) REFERENCES playlists (pid),
        FOREIGN KEY (vid) REFERENCES videos (vid),
        PRIMARY KEY (pid, vid)
      )
    ''');
        // Insert initial values into the playlists table
        await db.insert('playlists', {'name': 'all'});
      },
    );
    _getAllPlaylistIdByName("all");
  }

  Future<void> _getAllPlaylistIdByName(String name) async {
    if (db != null) {
      List<Map<String, dynamic>> result = await db!.query(
        'playlists',
        columns: ['pid'],
        where: 'name = ?',
        whereArgs: [name],
      );
      if (result.isNotEmpty) {
        _allPid = result.first['pid'] as int?;
      }
    } else {
      throw Exception("Database is not initialized properly...");
    }
  }

  @override
  Future<void> storeVideo(LocalVideo video, int? pid) async {
    if (db != null) {
      await db!.insert('videos', video.toJson());
      // this is to add to all
      await db!.insert('playlist_videos', {'pid': _allPid, 'vid': video.vid});
      if (pid != null) {
        await db!.insert('playlist_videos', {'pid': pid, 'vid': video.vid});
      }
    } else {
      throw Exception("Database is not initialized properly...");
    }
  }

  @override
  Future<List<LocalVideo>> getCategorizedVideo(int categoryId) async {
    if (db != null) {
      var appDocDir = await getApplicationDocumentsDirectory();
      List<Map<String, dynamic>> dataList = await db!.rawQuery('''
        SELECT videos.*
        FROM videos
        INNER JOIN playlist_videos ON videos.vid = playlist_videos.vid
        WHERE playlist_videos.pid = ?
        ORDER BY videos.created_at DESC
      ''', [categoryId]);

      List<LocalVideo> localVideoList = dataList.map<LocalVideo>((video) {
        try {
          LocalVideo tmp;
          tmp = LocalVideo.fromJson(video);
          tmp.path = path.join(appDocDir.path, video["path"]);
          tmp.thumbnailFilePath =
              path.join(appDocDir.path, video["thumbnail_file_path"]);
          return tmp;
        } catch (e) {
          print('Error processing video: $e');
          throw Exception('Error processing video: $e');
        }
      }).toList();
      return localVideoList;
    } else {
      throw Exception("Failed to get data...");
    }
  }

  @override
  Future<List<LocalVideo>> getAllVideos() async {
    if (db != null) {
      var appDocDir = await getApplicationDocumentsDirectory();
      List<Map<String, dynamic>> dataList = await db!.query("videos");
      List<LocalVideo> localVideoList = dataList.map<LocalVideo>((video) {
        try {
          LocalVideo tmp;
          tmp = LocalVideo.fromJson(video);
          tmp.path = path.join(appDocDir.path, video["path"]);
          tmp.thumbnailFilePath =
              path.join(appDocDir.path, video["thumbnail_file_path"]);
          return tmp;
        } catch (e) {
          throw Exception('Error processing video: $e');
        }
      }).toList();
      return localVideoList;
    } else {
      throw Exception("Failed to get data...");
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAllPlaylists() async {
    if (db != null) {
      List<Map<String, dynamic>> dataList = await db!.query('playlists');
      return dataList;
    } else {
      throw Exception("Failed to get data...");
    }
  }

  @override
  Future<void> addPlaylist(String name) async {
    if (db != null) {
      await db!.insert('playlists', {'name': name});
    } else {
      throw Exception("Failed to add playlist");
    }
  }

  @override
  Future<void> updatePlaylist(int pid, String newName) async {
    if (db != null) {
      await db!.update(
        'playlists',
        {'name': newName},
        where: 'pid = ?',
        whereArgs: [pid],
      );
    } else {
      throw Exception("Failed to update playlist");
    }
  }

  @override
  Future<void> deletePlaylist(int pid) async {
    if (db != null) {
      await db!.delete(
        'playlists',
        where: 'pid = ?',
        whereArgs: [pid],
      );
    } else {
      throw Exception("Failed to delete playlist");
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

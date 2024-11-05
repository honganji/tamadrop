import 'package:tamadrop/features/download/domain/entities/video.dart';

abstract class StorageRepo {
  /* Videos */
  // initialization
  Future<void> initializeDB();
  // Create
  Future<void> storeVideo(LocalVideo video, int pid);

  // Read
  Future<List<LocalVideo>> getCategorizedVideo(int categoryId);
  Future<List<LocalVideo>> getAllVideos();

  // Update
  Future<void> updateVideo(LocalVideo newVideo, String videoId);

  // Delete
  Future<void> deleteVideo(LocalVideo video);

  /* Playlists */
  // Get All
  Future<List<Map<String, dynamic>>> getAllPlaylists();
}

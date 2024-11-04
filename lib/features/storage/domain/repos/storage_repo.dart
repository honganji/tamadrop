import 'package:tamadrop/features/download/domain/entities/video.dart';

abstract class StorageRepo {
  // initialization
  Future<void> initializeDB();
  // Create
  Future<void> storeVideo(LocalVideo video);

  // Read
  Future<List<LocalVideo>> getCategorizedVideo(int categoryId);
  Future<List<LocalVideo>> getAllVideos();

  // Update
  Future<void> updateVideo(LocalVideo newVideo, String videoId);

  // Delete
  Future<void> deleteVideo(String videoId);
}

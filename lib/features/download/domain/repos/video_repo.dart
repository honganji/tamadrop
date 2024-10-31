import 'package:tamadrop/features/download/domain/entities/video.dart';

abstract class VideoRepo {
  Future<LocalVideo?> downloadVideo(String url);
}

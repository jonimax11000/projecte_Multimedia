import '../entities/video.dart';

abstract class VideosRepository {
  Future<List<Video>> getVideos();
}

import '../entities/video.dart';
import '../repositories/videos_repository.dart';

class GetVideos {
  final VideosRepository repository;

  GetVideos(this.repository);

  Future<List<Video>> call() async {
    return await repository.getVideos();
  }
}

import '../../domain/repositories/videos_repository.dart';
import '../../domain/entities/video.dart';
import '../datasources/videos_api.dart';

class VideosRepositoryImpl implements VideosRepository {
  final VideosApi api;

  VideosRepositoryImpl(this.api);

  @override
  Future<List<Video>> getVideos() async {
    final models = await api.fetchVideos();
    return models
        .map((m) => Video(
              id: m['id'],
              nom: m['nom'] ?? '',
              descripcio: m['descripcio'] ?? '',
              duration: m['duration'] ?? 0,
              thumbnail: '/img/' + (m['thumbnail'] ?? ''),
            ))
        .toList();
  }
}

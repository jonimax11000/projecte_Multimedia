import '../../domain/repositories/videos_repository.dart';
import '../../domain/entities/video.dart';
import '../datasources/videos_api.dart';
import '../mappers/video_mapper.dart';

class VideosRepositoryImpl implements VideosRepository {
  final VideosApi api;

  VideosRepositoryImpl(this.api);

  @override
  Future<List<Video>> getVideos() async {
    final models = await api.fetchVideos();
    return models.map((m) => VideoMapper.fromJson(m)).toList();
  }
}

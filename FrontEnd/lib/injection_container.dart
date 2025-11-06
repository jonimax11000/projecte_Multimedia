import 'package:get_it/get_it.dart';
import 'features/data/datasources/videos_api.dart';
import 'features/data/repositories/videos_repository_impl.dart';
import 'features/domain/repositories/videos_repository.dart';
import 'features/domain/usecases/get_videos.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Videos
  sl.registerLazySingleton(() => VideosApi());
  sl.registerLazySingleton<VideosRepository>(() => VideosRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetVideos(sl()));
}

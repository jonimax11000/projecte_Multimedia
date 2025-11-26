import '../../domain/entities/video.dart';

class VideoMapper {
  static Video fromJson(Map<String, dynamic> json) => Video(
        id: json['id'],
        nom: json['nom'] ?? '',
        descripcio: json['descripcio'] ?? '',
        duration: json['duration'] ?? 0,
        thumbnail: json['thumbnail'] ?? '',
        url: json['url'],
      );
}

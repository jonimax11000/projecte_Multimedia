class Video {
  final String id;
  final String nom;
  final String descripcio;
  final int duration;
  final String thumbnail;
  final String url; // URL del video para reproducción

  Video({
    required this.id,
    required this.nom,
    required this.descripcio,
    required this.duration,
    required this.thumbnail,
    required this.url,
  });
}
import 'package:flutter/material.dart';
import '../../domain/entities/video.dart';

class MyListWidget extends StatelessWidget {
  const MyListWidget({
    super.key,
    required this.videos,
    required this.onVideoTap,
  });

  final List<Video> videos;
  final Function(Video) onVideoTap;

  @override
  Widget build(BuildContext context) {
    if (videos.isEmpty) {
      return const Center(
        child: Text(
          'No videos found',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return _buildVideoListItem(context, video);
      },
    );
  }

  Widget _buildVideoListItem(BuildContext context, Video video) {
    return GestureDetector(
      onTap: () {
        print('Video tapped: ${video.nom}');
        onVideoTap(video);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Miniatura del vídeo
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 120,
                    height: 80,
                    color: const Color(0xFF2A2A2A),
                    child: video.thumbnail.isNotEmpty
                        ? Image.network(
                            "http://10.0.2.2:3000${video.thumbnail}",
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.broken_image,
                                color: Colors.white38,
                                size: 32,
                              );
                            },
                          )
                        : const Icon(
                            Icons.play_circle_outline,
                            color: Colors.white38,
                            size: 40,
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                // Informació del vídeo
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video.nom,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      
                      const SizedBox(height: 6),
                      Row(
                        children: [
                        
                          const SizedBox(width: 4),
                          
                          
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: Colors.white38,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      );
  }
}
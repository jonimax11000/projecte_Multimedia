import 'package:flutter/material.dart';
import '../../domain/entities/video.dart';
import '../../domain/usecases/get_videos.dart';
import '../../../injection_container.dart' as di;
import '../widgets/my_list_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Video? _selectedVideo;
  late final GetVideos getVideos;
  List<Video>? videos;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    getVideos = di.sl<GetVideos>();
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    try {
      final result = await getVideos();
      setState(() {
        videos = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void _onVideoTap(Video video) {
    setState(() {
      _selectedVideo = video;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        title: const Text(
          'Videos',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.blueAccent,
              ),
            )
          : errorMessage != null
              ? Center(
                  child: Text(
                    'Error: $errorMessage',
                    style: const TextStyle(color: Colors.white70),
                  ),
                )
              : SafeArea(
                  child: OrientationBuilder(
                    builder: (context, orientation) {
                      final isLandscape = orientation == Orientation.landscape;
                      
                      // Si está en landscape y hay un video seleccionado, usar layout horizontal
                      if (isLandscape && _selectedVideo != null) {
                        return _buildLandscapeLayout();
                      } else {
                        return _buildPortraitLayout();
                      }
                    },
                  ),
                ),
    );
  }

  Widget _buildPortraitLayout() {
    return Column(
      children: [
        // Targeta del vídeo seleccionat (arriba en portrait)
        if (_selectedVideo != null) ...[
          _buildSelectedVideoCard(),
          const SizedBox(height: 16),
        ],
        // Llista de vídeos
        Expanded(
          child: MyListWidget(
            videos: videos ?? [],
            onVideoTap: _onVideoTap,
          ),
        ),
      ],
    );
  }

  Widget _buildLandscapeLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Targeta del vídeo seleccionat (izquierda en landscape)
        Flexible(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _buildSelectedVideoCard(),
          ),
        ),
        // Llista de vídeos (derecha en landscape)
        Flexible(
          flex: 3,
          child: MyListWidget(
            videos: videos ?? [],
            onVideoTap: _onVideoTap,
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedVideoCard() {
    return Container(
      constraints: const BoxConstraints(
        maxHeight: 400,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Miniatura del vídeo
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
            child: SizedBox(
              height: 200,
              width: double.infinity,
              child: _selectedVideo!.thumbnail.isNotEmpty
                  ? Image.asset(
                      _selectedVideo!.thumbnail,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFF2A2A2A),
                          child: const Icon(
                            Icons.broken_image,
                            color: Colors.white54,
                            size: 64,
                          ),
                        );
                      },
                    )
                  : Container(
                      color: const Color(0xFF2A2A2A),
                      child: const Icon(
                        Icons.video_library,
                        color: Colors.white54,
                        size: 64,
                      ),
                    ),
            ),
          ),
          // Informació del vídeo
          Flexible(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Títol
                    Text(
                      _selectedVideo!.nom,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    // Duració
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          color: Colors.white70,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${(_selectedVideo!.duration ~/ 60)}:${(_selectedVideo!.duration % 60).toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Descripció
                    Text(
                      _selectedVideo!.descripcio,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
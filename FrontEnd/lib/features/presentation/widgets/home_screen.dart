import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
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
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  bool _isScrubbing = false;
  bool _wasPlayingBeforeScrubbing = false;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    getVideos = di.sl<GetVideos>();
    _loadVideos();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _exitFullScreen();
    super.dispose();
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

  Future<void> _initializeVideo(String videoUrl) async {
    await _videoController?.dispose();
    setState(() {
      _isVideoInitialized = false;
      _isScrubbing = false;
    });

    _videoController = VideoPlayerController.networkUrl(
      Uri.parse('http://10.0.2.2:3000$videoUrl'),
    );

    try {
      await _videoController!.initialize();
      await _videoController!.setVolume(1.0);
      
      setState(() {
        _isVideoInitialized = true;
      });
      
      await _videoController!.play();
      
      _videoController!.addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
    } catch (e) {
      print('Error initializing video: $e');
      setState(() {
        _isVideoInitialized = false;
      });
    }
  }

  void _onVideoTap(Video video) {
    setState(() {
      _selectedVideo = video;
    });
    if (video.url.isNotEmpty) {
      _initializeVideo(video.url);
    } else {
      print('Video URL not available');
    }
  }

  Future<void> _seekTo(Duration position) async {
    if (_videoController == null || !_videoController!.value.isInitialized) {
      return;
    }

    await _videoController!.pause();
    await Future.delayed(const Duration(milliseconds: 100));
    
    await _videoController!.seekTo(position);
    
    await _videoController!.setVolume(1.0);
    
    await Future.delayed(const Duration(milliseconds: 100));
    
    if (_wasPlayingBeforeScrubbing) {
      await _videoController!.play();
    }
    
    setState(() {
      _isScrubbing = false;
    });
  }

  Future<void> _toggleFullScreen() async {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });

    if (_isFullScreen) {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      await _exitFullScreen();
    }
  }

  Future<void> _exitFullScreen() async {
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    if (_isFullScreen) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Center(
              child: _isVideoInitialized && _videoController != null
                  ? AspectRatio(
                      aspectRatio: _videoController!.value.aspectRatio,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          VideoPlayer(_videoController!),
                          Positioned.fill(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (_videoController!.value.isPlaying) {
                                    _videoController!.pause();
                                  } else {
                                    _videoController!.play();
                                  }
                                });
                              },
                              child: Container(
                                color: Colors.transparent,
                                child: Center(
                                  child: AnimatedOpacity(
                                    opacity: _videoController!.value.isPlaying ? 0.0 : 1.0,
                                    duration: const Duration(milliseconds: 200),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(16),
                                      child: const Icon(
                                        Icons.play_arrow,
                                        color: Colors.white,
                                        size: 48,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: _buildVideoControls(isFullScreen: true),
                          ),
                        ],
                      ),
                    )
                  : const CircularProgressIndicator(color: Colors.blueAccent),
            ),
            Positioned(
              top: 40,
              left: 16,
              child: IconButton(
                icon: const Icon(Icons.fullscreen_exit, color: Colors.white, size: 32),
                onPressed: _toggleFullScreen,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: 10.0, right: 24),
          child: SafeArea(
            child: Image.asset(
              "assets/img/justflix.png",
              height: 44,
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
            ),
          ),
        ),
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
              : Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  child: SafeArea(
                    child: OrientationBuilder(
                      builder: (context, orientation) {
                        final isLandscape = orientation == Orientation.landscape;
                        
                        if (isLandscape && _selectedVideo != null) {
                          return _buildLandscapeLayout();
                        } else {
                          return _buildPortraitLayout();
                        }
                      },
                    ),
                  ),
                ),
    );
  }

  Widget _buildPortraitLayout() {
    return Column(
      children: [
        if (_selectedVideo != null) ...[
          _buildVideoPlayerCard(),
          const SizedBox(height: 2),
        ],
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
        Flexible(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: _buildVideoPlayerCard(),
          ),
        ),
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

  Widget _buildVideoPlayerCard() {
    return Container(
      constraints: const BoxConstraints(
        maxHeight: 600,
        minHeight: 200,
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
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
            child: Container(
              color: Colors.black,
              constraints: const BoxConstraints(
                minHeight: 200,
                maxHeight: 400,
              ),
              child: _isVideoInitialized && _videoController != null
                  ? AspectRatio(
                      aspectRatio: _videoController!.value.aspectRatio,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          VideoPlayer(_videoController!),
                          Positioned.fill(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (_videoController!.value.isPlaying) {
                                    _videoController!.pause();
                                  } else {
                                    _videoController!.play();
                                  }
                                });
                              },
                              child: Container(
                                color: Colors.transparent,
                                child: Center(
                                  child: AnimatedOpacity(
                                    opacity: _videoController!.value.isPlaying ? 0.0 : 1.0,
                                    duration: const Duration(milliseconds: 200),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(16),
                                      child: const Icon(
                                        Icons.play_arrow,
                                        color: Colors.white,
                                        size: 48,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: _buildVideoControls(),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(
                      height: 250,
                      child: Center(
                        child: _selectedVideo!.thumbnail.isNotEmpty
                            ? Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    _selectedVideo!.thumbnail,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.blueAccent,
                                        ),
                                      );
                                    },
                                  ),
                                  const CircularProgressIndicator(
                                    color: Colors.blueAccent,
                                  ),
                                ],
                              )
                            : const CircularProgressIndicator(
                                color: Colors.blueAccent,
                              ),
                      ),
                    ),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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

  Widget _buildVideoControls({bool isFullScreen = false}) {
    if (_videoController == null || !_videoController!.value.isInitialized) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.7),
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onHorizontalDragStart: (details) {
              setState(() {
                _isScrubbing = true;
                _wasPlayingBeforeScrubbing = _videoController!.value.isPlaying;
              });
              if (_wasPlayingBeforeScrubbing) {
                _videoController!.pause();
              }
            },
            onHorizontalDragUpdate: (details) {
              if (!_isScrubbing) return;
              
              final box = context.findRenderObject() as RenderBox?;
              if (box == null) return;
              
              final position = details.localPosition.dx / box.size.width;
              final duration = _videoController!.value.duration;
              final newPosition = duration * position.clamp(0.0, 1.0);
              
              _videoController!.seekTo(newPosition);
            },
            onHorizontalDragEnd: (details) {
              final currentPosition = _videoController!.value.position;
              _seekTo(currentPosition);
            },
            child: VideoProgressIndicator(
              _videoController!,
              allowScrubbing: true,
              colors: const VideoProgressColors(
                playedColor: Colors.blueAccent,
                bufferedColor: Colors.white24,
                backgroundColor: Colors.white12,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    _videoController!.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      if (_videoController!.value.isPlaying) {
                        _videoController!.pause();
                      } else {
                        _videoController!.play();
                      }
                    });
                  },
                ),
                const Spacer(),
                Text(
                  _formatDuration(_videoController!.value.position),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Text(
                  ' / ',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                Text(
                  _formatDuration(_videoController!.value.duration),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (!isFullScreen) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.fullscreen, color: Colors.white),
                    onPressed: _toggleFullScreen,
                  ),
                ],
                const SizedBox(width: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }
}
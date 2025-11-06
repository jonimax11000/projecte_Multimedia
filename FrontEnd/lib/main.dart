import 'package:flutter/material.dart';
import 'injection_container.dart' as di;
import 'features/domain/usecases/get_videos.dart';
import 'features/domain/entities/video.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Videos App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const VideosScreen(),
    );
  }
}

class VideosScreen extends StatefulWidget {
  const VideosScreen({super.key});

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  late final GetVideos getVideos;

  @override
  void initState() {
    super.initState();
    getVideos = di.sl<GetVideos>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Videos'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Video>>(
        future: getVideos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final videos = snapshot.data!;
            return ListView.builder(
              itemCount: videos.length,
              itemBuilder: (context, index) {
                final video = videos[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                    title: Text(video.nom),
                    subtitle: Text(video.descripcio),
                    trailing: Text('${(video.duration ~/ 60)}:${(video.duration % 60).toString().padLeft(2, '0')}'),
                    leading: Image.asset('assets/img/totr.jpg', width: 100, fit: BoxFit.cover),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No videos found.'));
          }
        },
      ),
    );
  }
}
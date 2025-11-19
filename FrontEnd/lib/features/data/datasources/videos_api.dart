import 'dart:convert';
import 'package:http/http.dart' as http;

class VideosApi {
  final String baseUrl;
  VideosApi({this.baseUrl = 'http://10.0.2.2:3000'});

  Future<List<Map<String, dynamic>>> fetchVideos() async {
    final uri = Uri.parse('$baseUrl/api/videolist');
    try {
      final res = await http.get(uri);
      if (res.statusCode == 200) {
        final decoded = json.decode(res.body);
        if (decoded is List) {
          return decoded.map<Map<String, dynamic>>((e) {
            return {
              'id': e['id'],
              'nom': e['nom'],
              'descripcio': e['descripcio'],
              'duration': e['duration'],
              'thumbnail': e['thumbnail'],
              'url': e['videoUrl'], 
            };
          }).toList();
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load videos: ${res.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching videos: $e');
    }
  }
}
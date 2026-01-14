import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/media_item.dart';

class TmdbClient {
  static const String _baseUrl = 'https://tmdbproxy.veltrix620.workers.dev/3';
  
  // No API key needed for this proxy
  
  Future<List<MediaItem>> getTrending() async {
    final response = await http.get(Uri.parse('$_baseUrl/trending/all/day'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((e) => MediaItem.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load trending media');
    }
  }

  Future<List<MediaItem>> getPopularMovies() async {
    final response = await http.get(Uri.parse('$_baseUrl/movie/popular'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((e) => MediaItem.fromJson(e..['media_type'] = 'movie')).toList();
    } else {
      throw Exception('Failed to load popular movies');
    }
  }

  Future<List<MediaItem>> getTopRatedMovies() async {
    final response = await http.get(Uri.parse('$_baseUrl/movie/top_rated'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((e) => MediaItem.fromJson(e..['media_type'] = 'movie')).toList();
    } else {
      throw Exception('Failed to load top rated movies');
    }
  }

  Future<List<MediaItem>> search(String query) async {
    final response = await http.get(Uri.parse('$_baseUrl/search/multi?query=$query'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((e) => MediaItem.fromJson(e)).toList();
    } else {
      throw Exception('Failed to search media');
    }
  }

  Future<MediaItem> getDetails(int id, String type) async {
    final response = await http.get(Uri.parse('$_baseUrl/$type/$id'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return MediaItem.fromJson(data..['media_type'] = type);
    } else {
      throw Exception('Failed to load details');
    }
  }

  Future<List<Cast>> getCast(int id, String type) async {
    final response = await http.get(Uri.parse('$_baseUrl/$type/$id/credits'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List cast = data['cast'];
      return cast.map((e) => Cast.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load cast');
    }
  }
}

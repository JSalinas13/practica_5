import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:practica_5/models/popular_moviedao.dart';
import 'package:http/http.dart' as http;

class PopularApi {
  final dio = Dio();
  final apiKey = '40ce54d3539bf4f864da2b772feeb96a';
  final bearerToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIzYzRiMjZiOTViMTkzMDE4ZDcyZmQwODk4OWRiNzAzMyIsIm5iZiI6MTczMDk0NDQzNy4yMTk1NjU0LCJzdWIiOiI2MTljMzM1MWUyZmYzMjAwOGVmNTBlNTUiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.RL4MrbnSUwwbIjfzqL_7Vawo-QOnghzGFNy5_JUVlJw';

  Future<List<PopularMovieDao>> getPopularMovies() async {
    final response = await dio.get(
        'https://api.themoviedb.org/3/movie/popular?api_key=$apiKey&language=es-MX&page=1');
    final res = response.data['results'] as List;


    return res.map((popular) => PopularMovieDao.fromMap(popular)).toList();
  }

  Future<Map<String, dynamic>> fetchCredits(int idMovie) async {
    final url = Uri.parse(
        'https://api.themoviedb.org/3/movie/$idMovie/credits?api_key=$apiKey&language=es-MX');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Error en la solicitud: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>?> fetchTrailer(int idMovie) async {
    final url = Uri.parse(
        'https://api.themoviedb.org/3/movie/$idMovie/videos?api_key=$apiKey&language=es-MX');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['results'] != null && data['results'].isNotEmpty) {
        return data['results'][0]; // Retorna solo el primer resultado
      } else {
        throw Exception('No se encontraron videos');
      }
    } else {
      throw Exception('Error en la solicitud: ${response.statusCode}');
    }
  }

  Future<void> addToFavorites(
      String accountId, int movieId, bool isFavorite) async {
    final String url =
        'https://api.themoviedb.org/3/account/$accountId/favorite';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $bearerToken',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'media_type': 'movie',
        'media_id': movieId,
        'favorite': isFavorite,
      }),
    );

    if (response.statusCode == 200) {
      print('Película agregada a favoritos exitosamente.');
    } else {
      print('Error al agregar a favoritos: ${response.statusCode}');
      print('Mensaje: ${response.body}');
    }
  }

  Future<void> deleteToFavorites(
      String accountId, int movieId, bool isFavorite) async {
    final String url =
        'https://api.themoviedb.org/3/account/$accountId/favorite';

    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $bearerToken',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'media_type': 'movie',
        'media_id': movieId,
        'favorite': isFavorite,
      }),
    );

    if (response.statusCode == 200) {
      print('Película agregada a favoritos exitosamente.');
    } else {
      print('Error al agregar a favoritos: ${response.statusCode}');
      print('Mensaje: ${response.body}');
    }
  }

  Future<Map<String, dynamic>?> getFavoriteMovies(String accountId) async {
    final String url =
        'https://api.themoviedb.org/3/account/$accountId/favorite/movies?language=en-US&page=1&sort_by=created_at.asc';

    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $bearerToken',
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // print('Películas favoritas:');
      // print(data);
      return data;
      // Puedes procesar los datos como desees
    } else {
      print('Error al obtener películas favoritas: ${response.statusCode}');
      print('Mensaje: ${response.body}');
    }
  }
}

import '../../models/movie.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MovieService {
  static const String baseUrl = "http://10.0.2.2:6969/mobile/films";
  static final _storage = FlutterSecureStorage();

  /// Lấy token từ secure storage
  static Future<String?> _getToken() async {
    return await _storage.read(key: "token");
  }

  /// Hàm gọi API GET kèm Token
  static Future<http.Response> _getWithToken(String url) async {
    final token = await _getToken();
    print("lay Token: $token");

    if (token == null) {
      throw Exception("Token null! Người dùng chưa đăng nhập.");
    }

    return await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      }
    );
  }

  /// Lấy tất cả phim
  static Future<List<Movie>> fetchAllMovies() async {
    try {
      final response = await _getWithToken(baseUrl);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        return data.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception("Lỗi tải phim: ${response.statusCode}");
      }
    } catch (e) {
      print("Lỗi khi gọi API: $e");
      return [];
    }
  }

  /// Hàm gọi API chung kèm token
  static Future<List<Movie>> _fetchMovies(String endpoint) async {
    try {
      final response = await _getWithToken("$baseUrl/$endpoint");

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception("Lỗi tải phim: ${response.statusCode}");
      }
    } catch (e) {
      print("Lỗi khi gọi API: $e");
      return [];
    }
  }

  /// Phim đang chiếu
  static Future<List<Movie>> fetchMoviesNowShowing() =>
      _fetchMovies("now-showing");

  /// Phim sắp chiếu
  static Future<List<Movie>> fetchMoviesComingSoon() =>
      _fetchMovies("upcoming");
  /// Phim hot
  static Future<List<Movie>> fetchHotMovies() =>
      _fetchMovies("hot");
}

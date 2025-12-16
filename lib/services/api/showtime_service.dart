import '../../models/showtime.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ShowtimeService {
  static const String baseUrl = "http://10.0.2.2:6969/mobile/showtimes";

  static final FlutterSecureStorage storage = FlutterSecureStorage();

  /// Lấy token từ secure storage
  static Future<String?> _getToken() async {
    return await storage.read(key: 'token');
  }

  /// Tạo header với token
  static Future<Map<String, String>> _headers() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  /// Lấy suất chiếu theo rạp
  static Future<List<Showtime>> fetchByCinema(int cinemaId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/cinema/$cinemaId'),
        headers: await _headers(),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Showtime.fromJson(json)).toList();
      } else {
        throw Exception('Lỗi tải suất chiếu: ${response.statusCode}');
      }
    } catch (e) {
      print("Lỗi khi gọi API: $e");
      return [];
    }
  }

  /// Lấy suất chiếu theo phim
  static Future<List<Showtime>> fetchByMovie(String movieId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/film/$movieId'),
        headers: await _headers(),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Showtime.fromJson(json)).toList();
      } else {
        throw Exception('Lỗi tải suất chiếu: ${response.statusCode}');
      }
    } catch (e) {
      print("Lỗi khi gọi API: $e");
      return [];
    }
  }
}

import '../../models/cinema.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../services/auth/auth_service.dart';

class CinemaService {
  static const String baseUrl = "http://10.0.2.2:6969/mobile/cinemas";

  static Future<List<Cinema>> fetchCinemas() async {
    try {
      //Lấy token
      final token = await AuthService.getToken();

      if (token == null) {
        print("❌ Không tìm thấy token — người dùng chưa đăng nhập.");
        return [];
      }
      // Gọi API với token trong header
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      // lấy dữ liệu cinemas
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Cinema.fromJson(json)).toList();
      }
      else if (response.statusCode == 401) {
        print("❌ Token hết hạn hoặc không hợp lệ.");
        return [];
      }
      else {
        throw Exception("Lỗi tải rạp chiếu: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Lỗi khi gọi API rạp: $e");
      return [];
    }
  }
}

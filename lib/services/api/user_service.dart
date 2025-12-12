import '../../models/user.dart';
import '../auth/auth_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  static const String baseUrl = "http://10.0.2.2:6969/mobile/users";

  // Đăng ký người dùng mới
  static Future<bool> registerUser(Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(userData),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Lỗi khi gọi API: $e");
      return false;
    }
  }

  // Lấy thông tin người dùng băng token
  static Future<User?> getMyinfo() async {
    try {
      final token = await AuthService.getToken();

      final response = await http.get(
        Uri.parse('$baseUrl/myinfo'),
        headers: {
          "content-type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data);
      } else {
        throw Exception('Lỗi tải thông tin người dùng: ${response.statusCode}');
      }
    }
    catch (e) {
      print("Lỗi khi gọi API: $e");
      return null;
    }
  }
}
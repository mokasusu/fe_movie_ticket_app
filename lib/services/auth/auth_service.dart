import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const String baseUrl = "http://10.0.2.2:6969/mobile/auth/token";

  static final storage = FlutterSecureStorage();

  static Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": email,
          "matKhau": password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["authenticated"] == true) {
          // Lưu token lại để gọi API sau này
          await storage.write(key: "token", value: data["token"]);
          print("TOKEN ĐÃ LƯU: ${data["token"]}");
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      print("Lỗi đăng nhập: $e");
      return false;
    }
  }
  
  // Lấy token đã lưu 
  static Future<String?> getToken() async {
    return await storage.read(key: "token");
  }
}

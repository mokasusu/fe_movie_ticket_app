import 'package:dio/dio.dart';
import '../../api/dio_client.dart'; // Import DioClient
import '../../utils/storage.dart';    // Import file Storage chung

class AuthService {
  static const String _loginPath = "/auth/token";

  /// Hàm Đăng nhập
  static Future<bool> login(String email, String password) async {
    try {
      // 1. Gọi API qua Dio (Code gọn hơn http rất nhiều)
      final response = await DioClient.dio.post(
        _loginPath,
        data: {
          "email": email,
          "matKhau": password
        },
      );

      // 2. Xử lý kết quả
      if (response.statusCode == 200) {
        final data = response.data; // Dio tự động parse JSON

        if (data["authenticated"] == true) {
          String token = data["token"];
          
          // QUAN TRỌNG: Dùng class Storage chung để đảm bảo Key luôn đúng ('auth_token')
          await Storage.saveToken(token);
          
          print("✅ Đăng nhập thành công. Token đã lưu.");
          return true;
        }
      }
      
      print("⚠️ Đăng nhập thất bại: ${response.data}");
      return false;

    } on DioException catch (e) {
      // Xử lý lỗi kết nối, sai pass (nếu server trả về 400/401)
      print("❌ Lỗi API Login: ${e.response?.statusCode} - ${e.message}");
      return false;
    } catch (e) {
      print("❌ Lỗi không xác định: $e");
      return false;
    }
  }
  
  /// Hàm Đăng xuất
  static Future<void> logout() async {
    await Storage.deleteToken();
    print("👋 Đã đăng xuất");
  }

  /// Kiểm tra xem user đã đăng nhập chưa (Dùng cho Splash Screen)
  static Future<bool> isLoggedIn() async {
    final token = await Storage.getToken();
    return token != null && token.isNotEmpty;
  }
}
import 'package:dio/dio.dart';
import '../../api/dio_client.dart'; // Import DioClient
import '../../utils/storage.dart'; // Import file Storage chung

class AuthService {
  static Future<bool> login(String email, String password) async {
    try {
      final response = await DioClient.dio.post(
        "/auth/token",
        data: {
          "email": email,
          "matKhau": password,
        },
      );

      // 1. Kiểm tra request thành công
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;

        // 2. Logic kết hợp: Check 'authenticated' LÀ TRUE VÀ có 'token'
        // Đây là cách an toàn nhất với JSON bạn cung cấp
        if (data["authenticated"] == true && data["token"] != null) {

          final token = data["token"];
          await Storage.saveToken(token);

          print("✅ Đăng nhập thành công! Token: ${token.substring(0, 10)}...");
          return true;
        }
      }

      print("⚠️ Đăng nhập thất bại: Tài khoản hoặc mật khẩu sai");
      return false;

    } on DioException catch (e) {
      if (e.response != null) {
        // Lỗi từ Server trả về (VD: 401 Unauthorized)
        print("🔥 Lỗi Server: ${e.response?.data}");
      } else {
        // Lỗi mất mạng/không kết nối được server
        print("🔥 Lỗi kết nối: ${e.message}");
      }
      return false;
    } catch (e) {
      print("🔥 Lỗi hệ thống: $e");
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

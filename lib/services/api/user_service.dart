import 'package:dio/dio.dart';
import '../../api/dio_client.dart';
// ⚠️ Đừng quên import Model User của bạn ở đây
import '../../models/user.dart';

class UserService {
  // Base endpoint cho user
  static const String _endpoint = "/users";

  /// 1. Đăng ký người dùng mới
  static Future<bool> registerUser(Map<String, dynamic> userData) async {
    try {
      final response = await DioClient.dio.post(
        _endpoint,
        data: userData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ Đăng ký thành công: ${response.data}");
        return true;
      }

      return false;

    } on DioException catch (e) {
      if (e.response != null) {
        print("🔥 Lỗi đăng ký (Server): ${e.response?.statusCode} - ${e.response?.data}");
      } else {
        print("🔥 Lỗi kết nối: ${e.message}");
      }
      return false;
    } catch (e) {
      print("🔥 Lỗi không xác định: $e");
      return false;
    }
  }

  /// 2. Lấy thông tin người dùng hiện tại (Dựa trên Token)
  static Future<User?> getMyInfo() async {
    try {
      // Gọi GET /users/myInfo
      final response = await DioClient.dio.get("$_endpoint/myInfo");

      if (response.statusCode == 200) {
        // Convert JSON thành Object User
        return User.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print("❌ Lỗi lấy Info: $e");
      return null;
    }
  }

  /// 3. Cập nhật thông tin người dùng
  /// [userId]: ID của user cần update
  /// [updateData]: Map chứa các trường cần sửa (ví dụ: ten, sdt...)
  static Future<bool> updateUser(String userId, Map<String, dynamic> updateData) async {
    try {
      // Gọi PUT /users/{userId}
      final response = await DioClient.dio.put(
        "$_endpoint/$userId",
        data: updateData,
      );

      // Backend trả về 200 là thành công
      return response.statusCode == 200;

    } on DioException catch (e) {
      print("❌ Lỗi cập nhật (Server): ${e.response?.statusCode} - ${e.message}");
      return false;
    } catch (e) {
      print("❌ Lỗi không xác định: $e");
      return false;
    }
  }
}
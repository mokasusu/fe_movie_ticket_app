import 'package:dio/dio.dart';
import '../../models/user.dart';
import '../../api/dio_client.dart';

class UserService {
  // Đường dẫn gốc: .../mobile/users
  static const String _userEndpoint = "/users";

  /// 1. Đăng ký (Khớp với @PostMapping)
  static Future<bool> registerUser(Map<String, dynamic> userData) async {
    try {
      final response = await DioClient.dio.post(
        _userEndpoint,
        data: userData,
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("❌ Lỗi Đăng ký: $e");
      return false;
    }
  }

  /// 2. Lấy thông tin cá nhân (Khớp với @GetMapping("/myInfo"))
  static Future<User?> getMyInfo() async {
    try {

      final response = await DioClient.dio.get("$_userEndpoint/myInfo");

      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print("❌ Lỗi lấy Info: $e");
      return null;
    }
  }

  /// 3. Cập nhật thông tin người dùng (Khớp với @PutMapping("/{userId}"))
  static Future<bool> updateUser(String userId, Map<String, dynamic> updateData) async {
    try {
      // Gọi PUT /users/{userId}
      final response = await DioClient.dio.put(
        "$_userEndpoint/$userId",
        data: updateData, // Body là UserUpdateRequest
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      print("❌ Lỗi cập nhật: ${e.response?.statusCode} - ${e.message}");
      return false;
    } catch (e) {
      print("❌ Lỗi không xác định: $e");
      return false;
    }
  }
}
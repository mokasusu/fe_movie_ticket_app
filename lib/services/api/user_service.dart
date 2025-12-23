import 'package:dio/dio.dart';
import '../../api/dio_client.dart';

import '../../models/user.dart';
import '../../models/userRequest.dart';

class UserService {

  static const String _endpoint = "/users";
  
  /// 1. Đăng ký người dùng mới
  static Future<bool> registerUser(Map<String, dynamic> userData) async {
    try {
      final response = await DioClient.dio.post(_endpoint, data: userData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ Đăng ký thành công: ${response.data}");
        return true;
      }

      return false;
    } on DioException catch (e) {
      if (e.response != null) {
        print(
          "🔥 Lỗi đăng ký (Server): ${e.response?.statusCode} - ${e.response?.data}",
        );
      } else {
        print("🔥 Lỗi kết nối: ${e.message}");
      }
      return false;
    } catch (e) {
      print("🔥 Lỗi không xác định: $e");
      return false;
    }
  }

  /// 2. Lấy thông tin người dùng hiện tại
  static Future<User?> getMyInfo() async {
    try {
      final response = await DioClient.dio.get("$_endpoint/myInfo");

      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print("❌ Lỗi lấy Info: $e");
      return null;
    }
  }

  /// 3. Cập nhật thông tin người dùng
  static Future<bool> updateUserProfile(
    String userId,
    UserRequest request,
  ) async {
    try {
      Map<String, dynamic> data = request.toJson();

      final response = await DioClient.dio.put(
        "$_endpoint/$userId",
        data: data,
      );

      if (response.statusCode == 200) {
        print("✅ Cập nhật thành công!");
        return true;
      }
      return false;
    } on DioException catch (e) {
      print(
        "❌ Lỗi cập nhật (Server): ${e.response?.statusCode} - ${e.message}",
      );
      if (e.response != null) {
        print("Chi tiết lỗi: ${e.response?.data}");
      }
      return false;
    } catch (e) {
      print("❌ Lỗi không xác định: $e");
      return false;
    }
  }

  /// 4. Đổi mật khẩu
  static Future<bool> changePassword(
    String userId,
    String oldPassword,
    String newPassword,
  ) async {
    try {
      final response = await DioClient.dio.put(
        "$_endpoint/$userId/password",
        data: {"oldPassword": oldPassword, "newPassword": newPassword},
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      print(
        "❌ Lỗi đổi mật khẩu (Server): ${e.response?.statusCode} - ${e.message}",
      );
      return false;
    } catch (e) {
      print("❌ Lỗi không xác định: $e");
      return false;
    }
  }
}

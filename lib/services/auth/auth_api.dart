import 'package:dio/dio.dart';
// Nhớ import file chứa class DioClient của bạn
 import '../../api/dio_client.dart';

class AuthApi {
  // Lưu ý: DioClient đã có base là "http://...:6969"
  // Nên ở đây mình chỉ cần nối thêm phần đuôi.
  // Bạn nhớ kiểm tra kỹ backend là "mobile" hay "moblie" nhé.
  static const String _prefix = "/auth";

  static Future<bool> requestOtp(String email) async {
    try {
      final res = await DioClient.dio.post(
        "$_prefix/request-otp",
        queryParameters: {"email": email}, // Dio tự chuyển thành ?email=...
      );

      // Dio trả dữ liệu trong biến .data (không phải .body)
      return res.statusCode == 200 && res.data == "OTP_SENT";
    } catch (e) {
      // Nếu lỗi mạng hoặc lỗi server (4xx, 5xx), Dio sẽ nhảy vào đây
      print("Lỗi requestOtp: $e");
      return false;
    }
  }

  static Future<bool> verifyOtp(String email, String otp) async {
    try {
      final res = await DioClient.dio.post(
        "$_prefix/verify-otp",
        queryParameters: {
          "email": email,
          "otp": otp,
        },
      );

      return res.statusCode == 200 && res.data == "VALID";
    } catch (e) {
      print("Lỗi verifyOtp: $e");
      return false;
    }
  }

  static Future<bool> resetPassword(String email, String otp, String newPass) async {
    try {
      final res = await DioClient.dio.post(
        "$_prefix/reset-password",
        // Với body JSON, dùng tham số 'data'. Dio tự động header Json và Encode.
        data: {
          "email": email,
          "otp": otp,
          "newPassword": newPass,
        },
      );

      return res.statusCode == 200 && res.data == "SUCCESS";
    } catch (e) {
      print("Lỗi resetPassword: $e");
      return false;
    }
  }
}
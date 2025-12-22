import 'package:dio/dio.dart';
import '../utils/storage.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    print("🚀 [Interceptor] Bắt đầu chuẩn bị request: ${options.uri}");
    String? token = await Storage.getToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      print("❌ Token hết hạn hoặc không hợp lệ.");
      await Storage.clear();
    }

    if (err.response?.statusCode == 403) {
      print("⛔ Bạn không có quyền truy cập.");
    }

    return handler.next(err);
  }
}
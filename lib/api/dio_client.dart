import 'package:dio/dio.dart';
import 'interceptors.dart';

class DioClient {
  static String get _baseUrl {
    // if (kIsWeb) {
    //   return "http://localhost:6969"; // Chạy trên Web
    // } else {
    //   return "http://10.0.2.2:6969"; // Chạy trên Máy ảo Android
    // }
    return "https://cinemode.onrender.com/mobile";
  }

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl, // 3. Gán biến vào đây
      connectTimeout: const Duration(seconds: 90),
      receiveTimeout: const Duration(seconds: 90),
      headers: {
        "Content-Type": "application/json", // định dạng chuẩn
      },
    ),
  )..interceptors.add(AuthInterceptor());
}
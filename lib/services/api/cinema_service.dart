import 'package:dio/dio.dart';
import '../../models/cinema.dart';
import '../../api/dio_client.dart';

class CinemaService {
  // DioClient đã cấu hình base url (.../mobile), chỉ cần đuôi path
  static const String _endpoint = "/cinemas";

  static Future<List<Cinema>> fetchCinemas() async {
    try {
      // 1. Gọi API qua DioClient
      final response = await DioClient.dio.get(_endpoint);

      // 2. Xử lý dữ liệu
      if (response.statusCode == 200) {
        // Dio tự động parse JSON thành List dynamic
        final List<dynamic> data = response.data;
        
        return data.map((json) => Cinema.fromJson(json)).toList();
      } else {
        throw Exception("Lỗi tải rạp: ${response.statusCode}");
      }
    } on DioException catch (e) {
      // 3. Xử lý lỗi (Nếu token sai, Interceptor đã tự catch lỗi 401 rồi)
      print("❌ Lỗi API Cinema: ${e.response?.statusCode} - ${e.message}");
      return [];
    } catch (e) {
      print("❌ Lỗi không xác định: $e");
      return [];
    }
  }
}
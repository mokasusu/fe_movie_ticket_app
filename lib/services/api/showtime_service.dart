import 'package:dio/dio.dart';
import '../../models/showtime.dart';
import '../../api/dio_client.dart';

class ShowtimeService {

  static const String _endpoint = "/showtimes";

  static Future<List<Showtime>> searchShowtimes({
    String? maPhim,
    int? maRap,
  }) async {
    try {
      // 1. Gọi API qua Dio
      final response = await DioClient.dio.get(
        "$_endpoint/search",
        queryParameters: {
          if (maPhim != null) 'maPhim': maPhim,
          if (maRap != null) 'maRap': maRap,
        },
      );

      // 2. Xử lý dữ liệu
      if (response.statusCode == 200) {
        // Dio tự động parse JSON
        final List<dynamic> data = response.data;
        return data.map((e) => Showtime.fromJson(e)).toList();
      } else {
        throw Exception('Lỗi tải suất chiếu: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // 3. Xử lý lỗi
      print('❌ Lỗi ShowtimeService: ${e.response?.statusCode} - ${e.message}');
      return [];
    } catch (e) {
      print('❌ Lỗi không xác định: $e');
      return [];
    }
  }
}
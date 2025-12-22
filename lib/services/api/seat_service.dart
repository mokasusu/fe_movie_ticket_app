import 'package:dio/dio.dart';
import '../../api/dio_client.dart'; // Import DioClient chung

class SeatService {

  static const String _endpoint = "/seats";

  /// Lấy danh sách ghế đã đặt theo showtimeId
  static Future<List<String>> fetchBookedSeats(int showtimeId) async {
    try {
      // 1. Gọi API qua DioClient
      final response = await DioClient.dio.get("$_endpoint/booked/$showtimeId");

      // 2. Xử lý dữ liệu
      if (response.statusCode == 200) {
        // Dio tự động parse JSON thành List dynamic
        final List<dynamic> data = response.data;
        
        // Chuyển đổi sang List<String>
        return data.map((e) => e.toString()).toList();
      } else {
        throw Exception('Lỗi tải ghế: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // 3. Xử lý lỗi Dio (Lỗi mạng, 404, 500...)
      print("❌ Lỗi SeatService: ${e.response?.statusCode} - ${e.message}");
      return [];
    } catch (e) {
      print("❌ Lỗi không xác định: $e");
      return [];
    }
  }
}
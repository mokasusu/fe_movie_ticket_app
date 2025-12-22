import 'package:dio/dio.dart';
import '../../api/dio_client.dart';

class SeatService {
  static const String _endpoint = "/seats";

  /// Hàm chỉ lấy về List<String> của mã ghế đã đặt
  static Future<List<String>> fetchBookedSeats(int showtimeId) async {
    try {
      final response = await DioClient.dio.get("$_endpoint/booked/$showtimeId");

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        // --- ĐOẠN QUAN TRỌNG NHẤT ---
        // Biến đổi List<Object> thành List<String>
        return data.map((json) {
          // Chỉ lấy về mã ghế
          return json['maGhe'].toString();
        }).toList();
        // -----------------------------
      }
      return [];
    } catch (e) {
      print("❌ Lỗi lấy ghế đã đặt: $e");
      return [];
    }
  }
}
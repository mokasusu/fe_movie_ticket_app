import '../../api/dio_client.dart';

class SeatService {
  static const String _endpoint = "/seats";

  /// Hàm chỉ lấy về List<String> của mã ghế đã đặt
  static Future<List<String>> fetchBookedSeats(int showtimeId) async {
    try {
      final response = await DioClient.dio.get("$_endpoint/booked/$showtimeId");

      if (response.statusCode == 200) {
        final data = response.data;

        // Xử lý nếu data là List trực tiếp
        if (data is List) {
          return data.map((item) {
            // Nếu item là String trực tiếp
            if (item is String) {
              return item;
            }
            // Nếu item là Map với key 'maGhe'
            if (item is Map) {
              return item['maGhe'].toString();
            }
            return item.toString();
          }).toList();
        }

        // Xử lý nếu data là Map với key chứa list
        if (data is Map && data.containsKey('data')) {
          final List<dynamic> listData = data['data'];
          return listData.map((item) {
            if (item is String) return item;
            if (item is Map) return item['maGhe'].toString();
            return item.toString();
          }).toList();
        }
      }
      return [];
    } catch (e) {
      print("❌ Lỗi lấy ghế đã đặt: $e");
      return [];
    }
  }
}

// lib/services/showtime_service.dart
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../../api/dio_client.dart';
import '../../models/showtime.dart';

class ShowtimeService {
  final Dio _dio = DioClient.dio;
  final String _endpoint = "/showtimes";

  // 1. Tìm kiếm suất chiếu (Đã sửa: Bỏ 'static' để dùng được _dio và _endpoint)
  Future<List<Showtime>> searchShowtimes({String? maPhim, int? maRap}) async {
    try {
      final response = await _dio.get(
        _endpoint,
        queryParameters: {
          if (maPhim != null) 'maPhim': maPhim,
          if (maRap != null) 'maRap': maRap,
        },
      );

      final List data = response.data;
      return data.map((e) => Showtime.fromJson(e)).toList();
    } catch (e) {
      print("❌ Lỗi lấy suất chiếu: $e");
      return [];
    }
  }

  // 2. Lấy lịch chiếu theo rạp và ngày (Dành cho Admin hoặc Client xem lịch)
  Future<List<Showtime>> getShowtimesByCinemaAndDate(int maRap, DateTime date) async {
    try {
      // Format DateTime sang String "yyyy-MM-dd"
      String dateStr = DateFormat('yyyy-MM-dd').format(date);

      // Endpoint: /showtimes/admin (Giả định backend cấu hình như vậy)
      final response = await _dio.get(
        "$_endpoint/admin",
        queryParameters: {
          'maRap': maRap,
          'date': dateStr,
        },
      );

      final List data = response.data;
      return data.map((e) => Showtime.fromJson(e)).toList();
    } catch (e) {
      print("❌ Lỗi lấy lịch chiếu Admin: $e");
      return [];
    }
  }

  // 3. Tạo suất chiếu THỦ CÔNG (1 suất duy nhất)
  Future<bool> createManualShowtime(Map<String, dynamic> body) async {
    try {
      await _dio.post(_endpoint, data: body);
      return true;
    } on DioException catch (e) {
      print("🔥 Lỗi tạo thủ công: ${e.response?.data}");
      // Ném lỗi ra để UI bắt được và hiện thông báo
      throw Exception(e.response?.data['message'] ?? "Tạo thất bại");
    }
  }

  // 4. Tạo suất chiếu TỰ ĐỘNG (Cho cả rạp)
  Future<bool> generateAutoShowtimes(Map<String, dynamic> body) async {
    try {
      await _dio.post('$_endpoint/auto-generate/cinema', data: body);
      return true;
    } on DioException catch (e) {
      print("🔥 Lỗi tạo tự động: ${e.response?.data}");
      throw Exception(e.response?.data['message'] ?? "Tạo tự động thất bại");
    }
  }

  // 5. Xóa suất chiếu
  Future<void> deleteShowtime(int id) async {
    try {
      await _dio.delete('$_endpoint/$id');
    } catch (e) {
      print("🔥 Lỗi xóa suất chiếu: $e");
      throw Exception("Xóa thất bại");
    }
  }
}
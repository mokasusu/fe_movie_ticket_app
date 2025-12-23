import 'package:dio/dio.dart';
import '../../models/cinema.dart';
import '../../models/room_model.dart';
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

  static Future<List<Room>> getRoomsByCinema(int maRap) async {
    try {
      // Gọi API: GET /cinemas/{maRap}/rooms
      // Lưu ý: Đảm bảo _endpoint là "/cinemas" hoặc thay bằng đường dẫn đầy đủ
      final response = await DioClient.dio.get("/cinemas/$maRap/rooms");

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        // Map dữ liệu JSON sang List<Room> object
        return data.map((json) => Room.fromJson(json)).toList();
      } else {
        throw Exception("Lỗi tải danh sách phòng: ${response.statusCode}");
      }
    } on DioException catch (e) {
      print("❌ Lỗi API Room: ${e.response?.statusCode} - ${e.message}");
      return [];
    } catch (e) {
      print("❌ Lỗi không xác định: $e");
      return [];
    }
  }
}

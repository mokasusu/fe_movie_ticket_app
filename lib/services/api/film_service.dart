// lib/services/film_service.dart
import 'package:dio/dio.dart';
import '../../api/dio_client.dart'; // Import DioClient
import '../../models/film_model.dart';

class FilmService {
  // Sử dụng instance Dio chung
  final Dio _dio = DioClient.dio;
  // Endpoint gốc (dựa trên cấu hình trước đó của bạn: .../mobile/films)
  final String _endpoint = "/films";

  Future<List<FilmResponse>> getNowShowingFilms() async {
    try {
      // Gọi API: GET /films/now-showing
      final response = await _dio.get('$_endpoint/now-showing');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => FilmResponse.fromJson(e)).toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      print("🔥 Lỗi lấy phim đang chiếu: ${e.message}");
      // Có thể return empty list thay vì throw lỗi để UI không bị crash
      return [];
    }
  }

  // 1. Lấy danh sách (Có tìm kiếm và phân trang)
  Future<List<FilmResponse>> getAllFilms({String? keyword}) async {
    try {
      final response = await _dio.get(
        '$_endpoint/search',
        queryParameters: {
          'keyword': keyword ?? '',
          'size': 100, // Lấy nhiều cho trang admin
          'sort': 'ngayCongChieu,desc' // Sắp xếp phim mới nhất lên đầu
        },
      );

      // Backend trả về Page<Film>, dữ liệu thực nằm trong key 'content'
      final List data = response.data['content'];
      return data.map((e) => FilmResponse.fromJson(e)).toList();
    } on DioException catch (e) {
      print("🔥 Lỗi lấy danh sách phim: ${e.message}");
      // Ném lỗi ra để UI hứng và hiện thông báo
      throw Exception(e.response?.data['message'] ?? "Không thể tải dữ liệu");
    }
  }

  // 2. Tạo mới
  Future<void> createFilm(FilmRequest request) async {
    try {
      await _dio.post(_endpoint, data: request.toJson());
    } on DioException catch (e) {
      print("🔥 Lỗi tạo phim: ${e.response?.data}");
      throw Exception(e.response?.data['message'] ?? "Tạo phim thất bại");
    }
  }

  // 3. Cập nhật
  Future<void> updateFilm(String id, FilmRequest request) async {
    try {
      await _dio.put('$_endpoint/$id', data: request.toJson());
    } on DioException catch (e) {
      print("🔥 Lỗi cập nhật phim: ${e.response?.data}");
      throw Exception(e.response?.data['message'] ?? "Cập nhật thất bại");
    }
  }

  // 4. Xóa (Thường backend sẽ là soft-delete chuyển trạng thái sang STOPPED)
  Future<void> deleteFilm(String id) async {
    try {
      await _dio.delete('$_endpoint/$id');
    } on DioException catch (e) {
      print("🔥 Lỗi xóa phim: ${e.response?.data}");
      throw Exception(e.response?.data['message'] ?? "Xóa thất bại");
    }
  }
}
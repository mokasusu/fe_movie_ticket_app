import 'package:dio/dio.dart';
import '../../models/film_model.dart';
import '../../api/dio_client.dart';

class MovieService {

  static const String _movieEndpoint = "/films";

  /// Hàm chung để gọi API và parse dữ liệu
  static Future<List<FilmResponse>> _fetchData(String path) async {
    try {

      final response = await DioClient.dio.get(path);

      print("🔍 API ($path) trả về: ${response.data}");
      print("🔍 Kiểu dữ liệu: ${response.data.runtimeType}");
      // 2. Xử lý dữ liệu
      if (response.statusCode == 200) {
        // Dio tự động convert JSON sang Map/List
        final List<dynamic> data = response.data;
        return data.map((json) => FilmResponse.fromJson(json)).toList();
      } else {
        throw Exception("Lỗi tải dữ liệu: ${response.statusCode}");
      }
    } on DioException catch (e) {
      // 3. Xử lý lỗi từ Dio
      print("❌ Lỗi API ($path): ${e.response?.statusCode} - ${e.message}");
      return [];
    } catch (e) {
      print("❌ Lỗi không xác định: $e");
      return [];
    }
  }

  // --- Các hàm Public ---

  /// Lấy tất cả phim
  static Future<List<FilmResponse>> fetchAllMovies() async {
    return await _fetchData(_movieEndpoint);
  }

  /// Phim đang chiếu
  static Future<List<FilmResponse>> fetchMoviesNowShowing() async {
    return await _fetchData("$_movieEndpoint/now-showing");
  }

  /// Phim sắp chiếu
  static Future<List<FilmResponse>> fetchMoviesComingSoon() async {
    return await _fetchData("$_movieEndpoint/upcoming");
  }

  /// Phim hot
  static Future<List<FilmResponse>> fetchHotMovies() async {
    return await _fetchData("$_movieEndpoint/hot");
  }
}
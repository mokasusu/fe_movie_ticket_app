import 'package:dio/dio.dart';
import '../../models/movie.dart'; // Đảm bảo đường dẫn import đúng model của bạn
import '../../api/dio_client.dart'; // Import DioClient bạn đã tạo

class MovieService {
  // Đường dẫn gốc cho phim (DioClient đã có base là .../mobile)
  static const String _movieEndpoint = "/films";

  /// Hàm chung để gọi API và parse dữ liệu
  static Future<List<Movie>> _fetchData(String path) async {
    try {
      // 1. Gọi API qua DioClient
      // Không cần truyền header Authorization thủ công nữa vì AuthInterceptor đã tự làm việc đó.
      final response = await DioClient.dio.get(path);

      print("🔍 API ($path) trả về: ${response.data}");
      print("🔍 Kiểu dữ liệu: ${response.data.runtimeType}");
      // 2. Xử lý dữ liệu
      if (response.statusCode == 200) {
        // Dio tự động convert JSON sang Map/List, không cần jsonDecode(response.body)
        final List<dynamic> data = response.data;
        return data.map((json) => Movie.fromJson(json)).toList();
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
  static Future<List<Movie>> fetchAllMovies() async {
    return await _fetchData(_movieEndpoint);
  }

  /// Phim đang chiếu
  static Future<List<Movie>> fetchMoviesNowShowing() async {
    return await _fetchData("$_movieEndpoint/now-showing");
  }

  /// Phim sắp chiếu
  static Future<List<Movie>> fetchMoviesComingSoon() async {
    return await _fetchData("$_movieEndpoint/upcoming");
  }

  /// Phim hot
  static Future<List<Movie>> fetchHotMovies() async {
    return await _fetchData("$_movieEndpoint/hot");
  }
}
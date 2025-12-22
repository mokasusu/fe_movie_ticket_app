import 'package:dio/dio.dart';
import '../../api/dio_client.dart';
import '../../../models/genre_model.dart';

class GenreService {
  final Dio _dio = DioClient.dio;
  final String _endpoint = "/genre";

  Future<List<Genre>> getAllGenres() async {
    try {
      final response = await _dio.get(_endpoint);

      // Backend trả về List<Object> (Mảng JSON)
      final List data = response.data;

      return data.map((e) => Genre.fromJson(e)).toList();
    } on DioException catch (e) {
      print("🔥 Lỗi lấy danh sách thể loại: ${e.message}");
      // Nếu lỗi thì trả về danh sách rỗng để app không bị crash
      return [];
    }
  }
}
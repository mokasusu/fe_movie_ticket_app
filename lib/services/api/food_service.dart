import '../../models/food.dart';
import '../../api/dio_client.dart';

class FoodService {
  static const String _endpoint = "/food_items";

  /// Hàm lấy danh sách đồ ăn từ API
  static Future<List<Food>> fetchFoods() async {
    try {
      final response = await DioClient.dio.get(_endpoint);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        return data.map((json) => Food.fromJson(json)).toList();
      } else {
        throw Exception('Lỗi tải đồ ăn: ${response.statusCode}');
      }
    } catch (e) {
      print("❌ Lỗi lấy đồ ăn: $e");
      return [];
    }
  }
}

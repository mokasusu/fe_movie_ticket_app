import 'package:dio/dio.dart';
import '../../models/voucher.dart'; // Đảm bảo đúng đường dẫn model
import '../../api/dio_client.dart';         // Import DioClient chung

class VoucherService {
  // BaseUrl của DioClient đã là ".../mobile", chỉ cần thêm endpoint này
  static const String _endpoint = "/vouchers";

  static Future<List<Voucher>> fetchVouchers() async {
    try {
      // 1. Gọi API qua DioClient
      // Tự động parse JSON, tự động timeout, tự động thêm token (nếu có)
      final response = await DioClient.dio.get(_endpoint);

      // 2. Xử lý dữ liệu
      if (response.statusCode == 200) {
        // Dio tự động chuyển response.body thành List object
        final List<dynamic> data = response.data;
        
        return data.map((json) => Voucher.fromJson(json)).toList();
      } else {
        throw Exception('Lỗi tải voucher: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // 3. Xử lý lỗi Dio
      print("❌ Lỗi VoucherService: ${e.response?.statusCode} - ${e.message}");
      return [];
    } catch (e) {
      print("❌ Lỗi không xác định: $e");
      return [];
    }
  }
}
import 'package:dio/dio.dart';
import '../../api/dio_client.dart';
import '../../models/invoice_response.dart';
import '../../models/invoice_request.dart';

class InvoiceService {

  static const String _endpoint = "/invoices";

  // SỬA 1: Đổi kiểu trả về thành Future<InvoiceResponse?>
  static Future<InvoiceResponse?> createInvoice(InvoiceRequest request) async {
    try {
      // 1. Log dữ liệu gửi đi để kiểm tra
      print("🚀 Đang gửi Request tạo hóa đơn: ${request.toJson()}");

      // 2. Gọi API POST
      final response = await DioClient.dio.post(
        _endpoint,
        data: request.toJson(), // Chuyển object thành JSON
      );

      // 3. Xử lý phản hồi
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ Tạo hóa đơn thành công!");
        
        return InvoiceResponse.fromJson(response.data);
      } else {
        print("⚠️ Lỗi Server: ${response.statusCode}");
        return null;
      }
    } on DioException catch (e) {
      // Xử lý lỗi từ thư viện Dio
      print("❌ Lỗi API Invoice: ${e.response?.statusCode}");
      print("   Chi tiết lỗi: ${e.response?.data}");
      return null;
    } catch (e) {
      // Xử lý lỗi không xác định
      print("❌ Lỗi không xác định: $e");
      return null;
    }
  }
}
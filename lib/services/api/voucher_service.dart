import 'package:dio/dio.dart';
import '../../models/voucher.dart';
import '../../api/dio_client.dart';

class VoucherService {
  
  static const String _endpoint = "/vouchers";

  static Future<List<Voucher>> fetchVouchers() async {
    try {
      // 1. Gọi API qua DioClient
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

  static Future<Voucher?> createVoucher({
    required String maGiamGia,
    required String moTa,
    required double giaTriGiam,
    required DiscountType loaiGiamGia,
    required DateTime ngayHetHan,
    required int soLuong,
  }) async {
    try {
      final response = await DioClient.dio.post(
        _endpoint,
        data: {
          "maGiamGia": maGiamGia,
          "moTa": moTa,
          "giaTriGiam": giaTriGiam,
          "loaiGiamGia": loaiGiamGia.name, // PERCENTAGE | AMOUNT
          "ngayHetHan": ngayHetHan.toIso8601String(),
          "soLuong": soLuong,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Voucher.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      print("❌ createVoucher error: ${e.response?.data}");
      return null;
    }
  }


  static Future<Voucher?> updateVoucher(
      String maGiamGia, {
        required String moTa,
        required double giaTriGiam,
        required DiscountType loaiGiamGia,
        required DateTime ngayHetHan,
        required int soLuong,
        required bool trangThai,
      }) async {
    try {
      final response = await DioClient.dio.put(
        "$_endpoint/$maGiamGia",
        data: {
          "moTa": moTa,
          "giaTriGiam": giaTriGiam,
          "loaiGiamGia": loaiGiamGia.name,
          "ngayHetHan": ngayHetHan.toIso8601String(),
          "soLuong": soLuong,
          "trangThai": trangThai,
        },
      );

      if (response.statusCode == 200) {
        return Voucher.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      print("❌ updateVoucher error: ${e.response?.data}");
      return null;
    }
  }

  static Future<bool> deleteVoucher(String maGiamGia) async {
    try {
      final response =
      await DioClient.dio.delete("$_endpoint/$maGiamGia");

      return response.statusCode == 204;
    } on DioException catch (e) {
      print("❌ deleteVoucher error: ${e.response?.data}");
      return false;
    }
  }
}
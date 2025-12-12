import '../../models/voucher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class VoucherService {
  static const String baseUrl = "http://10.0.2.2:6969/mobile/vouchers";

  static Future<List<Voucher>> fetchVouchers() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Voucher.fromJson(json)).toList();
      } else {
        throw Exception('Lỗi tải voucher: ${response.statusCode}');
      }
    } catch (e) {
      print("Lỗi khi gọi API: $e");
      return [];
    }
  }
}
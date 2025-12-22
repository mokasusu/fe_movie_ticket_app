import 'food.dart';
import 'seat.dart';

class Invoice {
  final int? maHoaDon; // Java Long -> Dart int
  final String? userName;
  final String? tenSuatChieu;
  final double? tongTienTruocGiam;
  final double? soTienGiam;
  final double? tongTienSauGiam;
  final String? voucher;
  final DateTime? ngayTao; // Java LocalDateTime -> Dart DateTime
  final String? url; // URL ảnh QR hoặc link thanh toán
  final List<Seat> gheList;
  final List<Food> doAnList;

  Invoice({
    this.maHoaDon,
    this.userName,
    this.tenSuatChieu,
    this.tongTienTruocGiam,
    this.soTienGiam,
    this.tongTienSauGiam,
    this.voucher,
    this.ngayTao,
    this.url,
    this.gheList = const [], // Mặc định là list rỗng để UI không bị lỗi
    this.doAnList = const [],
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      maHoaDon: json['maHoaDon'] as int?,
      userName: json['userName'] as String?,
      tenSuatChieu: json['tenSuatChieu'] as String?,

      // QUAN TRỌNG: Xử lý số thực an toàn
      // JSON có thể trả về 50000 (int) thay vì 50000.0 (double)
      // Dùng (value as num?)?.toDouble() để tránh lỗi crash app
      tongTienTruocGiam: (json['tongTienTruocGiam'] as num?)?.toDouble(),
      soTienGiam: (json['soTienGiam'] as num?)?.toDouble(),
      tongTienSauGiam: (json['tongTienSauGiam'] as num?)?.toDouble(),

      voucher: json['voucher'] as String?,

      // Parse thời gian từ chuỗi ISO-8601
      ngayTao: json['ngayTao'] != null
          ? DateTime.tryParse(json['ngayTao'])
          : null,

      url: json['url'] as String?,

      // Map danh sách ghế (GheResponse)
      gheList: (json['gheList'] as List<dynamic>?)
              ?.map((e) => Seat.fromJson(e))
              .toList() ??
          [],

      // Map danh sách đồ ăn (DoAnResponse)
      doAnList: (json['doAnList'] as List<dynamic>?)
              ?.map((e) => Food.fromJson(e))
              .toList() ??
          [],
    );
  }
}
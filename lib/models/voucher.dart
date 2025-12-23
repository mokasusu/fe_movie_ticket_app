enum DiscountType {
  PERCENTAGE, // Giảm theo %
  AMOUNT, // Giảm theo số tiền cố định
}

// 2. Class Model
class Voucher {
  final String maGiamGia;
  final String moTa;
  final double giaTriGiam;
  final DiscountType loaiGiamGia;
  final DateTime? ngayTao;
  final DateTime? ngayHetHan;
  final int soLuong;
  final bool trangThai;

  Voucher({
    required this.maGiamGia,
    required this.moTa,
    required this.giaTriGiam,
    required this.loaiGiamGia,
    this.ngayTao,
    this.ngayHetHan,
    required this.soLuong,
    required this.trangThai,
  });

  factory Voucher.fromJson(Map<String, dynamic> json) {
    final String? loaiGiamGiaStr = json['loaiGiamGia']
        ?.toString()
        .toUpperCase();

    // Debug log để kiểm tra giá trị backend trả về
    print(
      '🔍 Voucher ${json['maGiamGia']}: loaiGiamGia = "$loaiGiamGiaStr", giaTriGiam = ${json['giaTriGiam']}',
    );

    return Voucher(
      maGiamGia: json['maGiamGia'],
      moTa: json['moTa'],
      giaTriGiam: (json['giaTriGiam'] as num).toDouble(),
      loaiGiamGia:
          (loaiGiamGiaStr == 'PERCENTAGE' || loaiGiamGiaStr == 'PERCENT')
          ? DiscountType.PERCENTAGE
          : DiscountType.AMOUNT,
      ngayTao: json['ngayTao'] != null
          ? DateTime.tryParse(json['ngayTao'])
          : null,
      ngayHetHan: json['ngayHetHan'] != null
          ? DateTime.tryParse(json['ngayHetHan'])
          : null,
      soLuong: json['soLuong'],
      trangThai: json['trangThai'],
    );
  }
  String get displayValue {
    if (loaiGiamGia == DiscountType.PERCENTAGE) {
      return "${giaTriGiam.toStringAsFixed(0)}%";
    } else {
      return "${giaTriGiam.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}đ";
    }
  }

  bool get isExpired {
    if (ngayHetHan == null) return false;
    return DateTime.now().isAfter(ngayHetHan!);
  }
}

class Ghe {
  final String ma;       // Ví dụ: "A1"
  final String ten;      // Ví dụ: "1"
  final double gia;      // Ví dụ: 90000
  final String phanLoai; // "STANDARD", "VIP", "COUPLE"
  final bool daDat;      // true nếu đã bán

  Ghe({
    required this.ma,
    required this.ten,
    required this.gia,
    required this.phanLoai,
    required this.daDat,
  });

  factory Ghe.fromJson(Map<String, dynamic> json) {
    return Ghe(
      ma: json['ma'],
      ten: json['ten'],
      gia: (json['gia'] as num).toDouble(),
      phanLoai: json['phan_loai'],
      daDat: json['da_dat'] ?? false,
    );
  }
}
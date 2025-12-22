class Food {
  final String? foodId;
  final String? tenDoAn;
  final int? soLuong;
  final double? gia;
  final double? thanhTien;

  Food({
    this.foodId,
    this.tenDoAn,
    this.soLuong,
    this.gia,
    this.thanhTien,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      foodId: json['foodId'] as String?,
      tenDoAn: json['tenDoAn'] as String?,
      soLuong: json['soLuong'] as int?,
      gia: (json['gia'] as num?)?.toDouble(),
      thanhTien: (json['thanhTien'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson(int quantitySelected) {
    return {
      "foodId": foodId,
      "soLuong": quantitySelected,
    };
  }
}
class FoodItem {
  final String? maFoodItem;
  final String? tenFoodItem;
  final double? gia;
  final String? urlPoster;
  final String? phanLoai;
  final int? soLuong;

  FoodItem({
    this.maFoodItem,
    this.tenFoodItem,
    this.gia,
    this.urlPoster,
    this.phanLoai,
    this.soLuong,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      maFoodItem: json['maFoodItem'] as String?,
      tenFoodItem: json['tenFoodItem'] as String?,
      gia: (json['gia'] as num?)?.toDouble(),
      urlPoster: json['urlPoster'] as String?,
      phanLoai: json['phanLoai'] as String?,
    );
  }
}
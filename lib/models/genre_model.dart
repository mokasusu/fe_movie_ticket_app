class Genre {
  final String maGenre;  // ID
  final String tenGenre; // Tên hiển thị
  final String phanLoai;

  Genre({
    required this.maGenre,
    required this.tenGenre,
    required this.phanLoai,
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      maGenre: json['maGenre'] ?? '',
      tenGenre: json['tenGenre'] ?? '',
      phanLoai: json['phanLoai'] ?? '',
    );
  }
}
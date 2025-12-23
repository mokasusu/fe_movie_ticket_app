class Room {
  final int maPhong;    // Tương ứng Long maPhong
  final String tenPhong; // Tương ứng String tenPhong
  final int soGhe;      // Tương ứng int soGhe

  Room({
    required this.maPhong,
    required this.tenPhong,
    required this.soGhe,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      maPhong: json['maPhong'] ?? 0,
      tenPhong: json['tenPhong'] ?? "Phòng ?",
      soGhe: json['soGhe'] ?? 0,
    );
  }
}
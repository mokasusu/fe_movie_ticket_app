class Showtime {
  final int id;
  final String maPhim;
  final int maRap;
  final String tenPhong;
  final DateTime tgBatDau;
  final DateTime? tgKetThuc;

  Showtime({
    required this.id,
    required this.maPhim,
    required this.maRap,
    required this.tenPhong,
    required this.tgBatDau,
    required this.tgKetThuc,
  });

  factory Showtime.fromJson(Map<String, dynamic> json) {
    return Showtime(
      id: json['id'],
      maPhim: json['maPhim'],
      maRap: json['maRap'],
      tenPhong: json['tenPhong'],
      tgBatDau: DateTime.parse(json['tgBatDau']),
      tgKetThuc: json['tgKetThuc'] != null
          ? DateTime.parse(json['tgKetThuc'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'maPhim': maPhim,
      'maRap': maRap,
      'tenPhong': tenPhong,
      'tgBatDau': tgBatDau.toIso8601String(),
      'tgKetThuc': tgKetThuc?.toIso8601String(),
    };
  }
}

import 'package:intl/intl.dart';

class Showtime {
  final int id;
  final String maPhim;
  final String tenPhim;
  final int maRap;
  final String tenPhong;
  final DateTime tgBatDau;
  final DateTime? tgKetThuc;

  Showtime({
    required this.id,
    required this.maPhim,
    required this.tenPhim,
    required this.maRap,
    required this.tenPhong,
    required this.tgBatDau,
    required this.tgKetThuc,
  });

  factory Showtime.fromJson(Map<String, dynamic> json) {
    return Showtime(
      id: json['id'],
      maPhim: json['maPhim'],
      tenPhim: json['tenPhim'],
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
      'tenPhim': tenPhim,
      'maRap': maRap,
      'tenPhong': tenPhong,
      'tgBatDau': tgBatDau.toIso8601String(),
      'tgKetThuc': tgKetThuc?.toIso8601String(),
    };
  }
  String get startTimeDisplay => DateFormat('HH:mm').format(tgBatDau);

  String get endTimeDisplay => tgKetThuc != null
      ? DateFormat('HH:mm').format(tgKetThuc!)
      : '...';
  String get dateDisplay => DateFormat('dd/MM/yyyy').format(tgBatDau);
}
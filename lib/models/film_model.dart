import 'package:flutter/material.dart';

// ✅ Chuẩn 3 trạng thái của Backend
enum MovieStatus {
  UPCOMING,
  NOW_SHOWING,
  ENDED,
}

class FilmResponse {
  final String maPhim;
  final String tenPhim;
  final DateTime? ngayCongChieu;
  final DateTime? ngayKTChieu;
  final String moTa;
  final String daoDien;
  final String dienVien;
  final int thoiLuong;
  final String trailerUrl;
  final String anhPosterDoc;
  final String anhPosterNgang;
  final int doTuoi;
  final MovieStatus trangThai;
  final List<String> genres;

  FilmResponse({
    required this.maPhim,
    required this.tenPhim,
    this.ngayCongChieu,
    this.ngayKTChieu,
    required this.moTa,
    required this.daoDien,
    required this.dienVien,
    required this.thoiLuong,
    required this.trailerUrl,
    required this.anhPosterDoc,
    required this.anhPosterNgang,
    required this.doTuoi,
    required this.trangThai,
    required this.genres,
  });

  factory FilmResponse.fromJson(Map<String, dynamic> json) {
    return FilmResponse(
      maPhim: json['maPhim'] ?? '',
      tenPhim: json['tenPhim'] ?? '',
      ngayCongChieu: json['ngayCongChieu'] != null ? DateTime.parse(json['ngayCongChieu']) : null,
      ngayKTChieu: json['ngayKTChieu'] != null ? DateTime.parse(json['ngayKTChieu']) : null,
      moTa: json['moTa'] ?? '',
      daoDien: json['daoDien'] ?? '',
      dienVien: json['dienVien'] ?? '',
      thoiLuong: json['thoiLuong'] ?? 0,
      trailerUrl: json['trailerUrl'] ?? '',
      anhPosterDoc: json['anhPosterDoc'] ?? '',
      anhPosterNgang: json['anhPosterNgang'] ?? '',
      doTuoi: json['doTuoi'] ?? 0,
      trangThai: _parseStatus(json['trangThai']),
      genres: json['genres'] != null ? List<String>.from(json['genres']) : [],
    );
  }

  static MovieStatus _parseStatus(String? status) {
    // ✅ Logic parse chuẩn
    switch (status) {
      case 'UPCOMING': return MovieStatus.UPCOMING;
      case 'NOW_SHOWING': return MovieStatus.NOW_SHOWING;
      case 'ENDED': return MovieStatus.ENDED;
      default: return MovieStatus.UPCOMING; // Default an toàn
    }
  }

  Color get statusColor {
    switch (trangThai) {
      case MovieStatus.NOW_SHOWING: return Colors.green;
      case MovieStatus.UPCOMING: return Colors.orange;
      case MovieStatus.ENDED: return Colors.red;
    }
  }
}

class FilmRequest {
  String tenPhim;
  String? ngayCongChieu;
  String? ngayKTChieu;
  String moTa;
  String daoDien;
  String dienVien;
  int thoiLuong;
  String trailerUrl;
  String anhPosterDoc;
  String anhPosterNgang;
  int doTuoi;
  String? trangThai;
  List<String> genresId;

  FilmRequest({
    required this.tenPhim,
    this.ngayCongChieu,
    this.ngayKTChieu,
    required this.moTa,
    required this.daoDien,
    required this.dienVien,
    required this.thoiLuong,
    required this.trailerUrl,
    required this.anhPosterDoc,
    required this.anhPosterNgang,
    required this.doTuoi,
    this.trangThai,
    required this.genresId,
  });

  Map<String, dynamic> toJson() {
    return {
      'tenPhim': tenPhim,
      'ngayCongChieu': ngayCongChieu,
      'ngayKTChieu': ngayKTChieu,
      'moTa': moTa,
      'daoDien': daoDien,
      'dienVien': dienVien,
      'thoiLuong': thoiLuong,
      'trailerUrl': trailerUrl,
      'anhPosterDoc': anhPosterDoc,
      'anhPosterNgang': anhPosterNgang,
      'doTuoi': doTuoi,
      // ✅ Gửi tên Enum lên Server (UPCOMING, NOW_SHOWING, ENDED)
      if (trangThai != null) 'trangThai': trangThai,
      'genresId': genresId,
    };
  }
}
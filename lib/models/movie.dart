enum MovieStatus { NOW_SHOWING, UPCOMING, ENDED }

class Movie {
  final String maPhim;
  final String tenPhim;
  final String ngayCongChieu;
  final String ngayKTChieu;
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

  Movie({
    required this.maPhim,
    required this.tenPhim,
    required this.ngayCongChieu,
    required this.ngayKTChieu,
    required this.moTa,
    required this.daoDien,
    required this.dienVien,
    required this.thoiLuong,
    required this.trailerUrl,
    required this.anhPosterDoc,
    required this.anhPosterNgang,
    required this.doTuoi,
    required this.trangThai,
    this.genres = const [],
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      maPhim: json['maPhim'] ?? '',
      tenPhim: json['tenPhim'] ?? '',
      ngayCongChieu: json['ngayCongChieu'] ?? '',
      ngayKTChieu: json['ngayKTChieu'] ?? '',
      moTa: json['moTa'] ?? '',
      daoDien: json['daoDien'] ?? '',
      dienVien: json['dienVien'] ?? '',
      thoiLuong: json['thoiLuong'] ?? 0,
      trailerUrl: json['trailerUrl'] ?? '',
      anhPosterDoc: json['anhPosterDoc'] ?? '',
      anhPosterNgang: json['anhPosterNgang'] ?? '',
      doTuoi: json['doTuoi'] ?? 0,
      trangThai: MovieStatus.values.firstWhere(
        (e) => e.name == json['trangThai'],
        orElse: () => MovieStatus.ENDED,
      ),
      genres: json['genres'] != null
          ? List<String>.from(json['genres'])
          : <String>[],
    );
  }

  Map<String, dynamic> toJson() => {
        "maPhim": maPhim,
        "tenPhim": tenPhim,
        "ngayCongChieu": ngayCongChieu,
        "ngayKTChieu": ngayKTChieu,
        "moTa": moTa,
        "daoDien": daoDien,
        "dienVien": dienVien,
        "thoiLuong": thoiLuong,
        "trailerUrl": trailerUrl,
        "anhPosterDoc": anhPosterDoc,
        "anhPosterNgang": anhPosterNgang,
        "doTuoi": doTuoi,
        "trangThai": trangThai.name,
        "genres": genres,
      };
}

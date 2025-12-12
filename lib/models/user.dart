class User {
  final String id;
  final String hoTen;
  final String gioiTinh;
  final String ngaySinh;
  final String sdt;
  final String email;
  final String matKhau;
  final String? anhURL;

  User({
    required this.id,
    required this.hoTen,
    required this.gioiTinh,
    required this.ngaySinh,
    required this.sdt,
    required this.email,
    required this.matKhau,
    this.anhURL,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      hoTen: json['hoTen'],
      gioiTinh: json['gioiTinh'],
      ngaySinh: json['ngaySinh'],
      sdt: json['sdt'],
      email: json['email'],
      matKhau: json['matKhau'],
      anhURL: json['anhURL'],
    );
  }
  Map<String, dynamic> toJson() => {
    "hoTen": hoTen,
    "gioiTinh": gioiTinh,
    "ngaySinh": ngaySinh,
    "sdt": sdt,
    "email": email,
    "matKhau": matKhau,
    "anhURL": anhURL,
  };
}

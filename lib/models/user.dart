class User {
  final String id;
  final String hoTen;
  final String gioiTinh;
  final String ngaySinh;
  final String email;
  final String matKhau;
  final String? anhURL;

  User({
    required this.id,
    required this.hoTen,
    required this.gioiTinh,
    required this.ngaySinh,
    required this.email,
    required this.matKhau,
    required this.anhURL
  });

 factory User.fromJson(Map<String, dynamic> json) {
  return User(
    id: json['maUser'] ?? '',
    hoTen: json['hoTen'] ?? '',
    gioiTinh: json['gioiTinh'] ?? '',
    ngaySinh: json['ngaySinh']?.toString() ?? '',
    email: json['email'] ?? '',
    matKhau: json['matKhau'] ?? '',
    anhURL: json['anhURL'] ?? '',
  );
}
Map<String, dynamic> toJson() => {
  "maUser": id,
  "hoTen": hoTen,
  "gioiTinh": gioiTinh,
  "ngaySinh": ngaySinh,
  "email": email,
  "matKhau": matKhau,
  "anhURL": anhURL,
};
}
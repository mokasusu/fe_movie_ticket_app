import 'package:flutter/widgets.dart';

class Voucher {
  final String MaVoucher; // MaVoucher
  final String TenVoucher; // TenVoucher
  final String GiaGiam; // GiaGiam
  final String MoTa; // MoTa
  final String NgayTao; // NgayTao
  final String NgayHet; // NgayHet
  final int SoLuong; // SoLuong
  final String TrangThai; // TrangThai
  final Color backgroundColor;

  const Voucher({
    required this.MaVoucher,
    required this.TenVoucher,
    required this.GiaGiam,
    required this.MoTa,
    required this.NgayTao,
    required this.NgayHet,
    required this.SoLuong,
    required this.TrangThai,
    required this.backgroundColor,
  });

  factory Voucher.fromJson(Map<String, dynamic> json) {
    return Voucher(
      MaVoucher: json['MaVoucher'],
      TenVoucher: json['TenVoucher'],
      GiaGiam: json['GiaGiam'],
      MoTa: json['MoTa'],
      NgayTao: json['NgayTao'],
      NgayHet: json['NgayHet'],
      SoLuong: json['SoLuong'],
      TrangThai: json['TrangThai'],
      backgroundColor: Color(int.parse(json['BackgroundColor'], radix: 16)),
    );
  }
}
import 'user.dart';
import 'package:intl/intl.dart';

class UserRequest {
  final String? hoTen;
  final String? gioiTinh;
  final DateTime? ngaySinh;
  final String? anhURL;

  UserRequest({
    required this.hoTen,
    required this.gioiTinh,
    required this.ngaySinh,
    this.anhURL,
  });

  /// Factory tạo UserRequest từ User và các controller, ưu tiên giá trị mới, nếu rỗng thì lấy từ user hiện tại
  factory UserRequest.fromUserWithFallback({
    required User user,
    required String hoTen,
    required String gioiTinh,
    required String ngaySinh,
    String? anhURL,
  }) {
    // Nếu truyền rỗng thì lấy từ user
    final String finalHoTen = hoTen.isNotEmpty ? hoTen : user.hoTen;
    final String finalGioiTinh = gioiTinh.isNotEmpty ? gioiTinh : user.gioiTinh;
    final DateTime finalNgaySinh = ngaySinh.isNotEmpty
        ? DateFormat('dd/MM/yyyy').parse(ngaySinh)
        : DateFormat('dd/MM/yyyy').parse(user.ngaySinh);
    final String? finalAnhURL = (anhURL != null && anhURL.isNotEmpty)
        ? anhURL
        : user.anhURL;

    return UserRequest(
      hoTen: finalHoTen,
      gioiTinh: finalGioiTinh,
      ngaySinh: finalNgaySinh,
      anhURL: finalAnhURL,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hoTen': hoTen,
      'gioiTinh': gioiTinh,
      'ngaySinh': ngaySinh != null
          ? DateFormat('yyyy-MM-dd').format(ngaySinh!)
          : null,
      'anhURL': anhURL,
    };
  }
}

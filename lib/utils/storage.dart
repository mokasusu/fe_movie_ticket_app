import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  // Khởi tạo đối tượng bảo mật
  // AndroidOptions: encryptedSharedPreferences = true là bắt buộc để bảo mật cao nhất trên Android
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const _tokenKey = 'auth_token'; // Đặt tên key ra hằng số cho đỡ sai chính tả

  /// Lưu Token an toàn
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Lấy Token
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Xóa Token (Khi đăng xuất)
  static Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  /// Xóa tất cả dữ liệu (Dùng khi muốn reset app sạch sẽ)
  static Future<void> clear() async {
    await _storage.deleteAll();
  }

}
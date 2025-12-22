class VietQRConfig {

  static const String bankId = "MB";
  static const String accountNo = "0376209131";
  static const String accountName = "NGUYEN VIET SU";
  
  // Template: 'compact', 'compact2', 'qr_only', 'print'
  static const String template = "compact";

  /// Hàm tạo URL QR Code
  static String generateURL({
    required double amount,
    required String content,
  }) {
    // Format số tiền thành số nguyên
    int amountInt = amount.toInt();
    
    // Encode nội dung để tránh lỗi ký tự đặc biệt/khoảng trắng
    String addInfo = Uri.encodeComponent(content);
    String accName = Uri.encodeComponent(accountName);

    // Cấu trúc API VietQR
    return "https://img.vietqr.io/image/$bankId-$accountNo-$template.png?amount=$amountInt&addInfo=$addInfo&accountName=$accName";
  }
}
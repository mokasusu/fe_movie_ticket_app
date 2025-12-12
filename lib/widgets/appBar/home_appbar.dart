import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  // Hàm xử lý khi nhấn nút Hồ sơ
  void _handleProfileClick() {
    print('Nút Hồ sơ đã được nhấn!');
    // Thêm logic điều hướng/hiển thị dialog tại đây
  }

  // Hàm xử lý khi nhấn nút Lịch sử Đặt vé
  void _handleHistoryClick() {
    print('Nút Lịch sử Đặt vé đã được nhấn!');
    // Thêm logic điều hướng đến trang lịch sử tại đây
  }

  // Chiều cao mong muốn của App Bar, được yêu cầu bởi PreferredSizeWidget
  @override
  Size get preferredSize => const Size.fromHeight(64.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: preferredSize.height,
      backgroundColor: Colors.white,
      elevation: 4.0, // Độ nổi nhẹ
      shadowColor: Colors.black.withOpacity(0.1),
      
      // 1. Khu vực bên trái: Nút Hồ sơ Người dùng (Leading)
      leading: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: IconButton(
          icon: const Icon(Icons.account_circle, size: 28.0, color: Colors.indigo),
          onPressed: _handleProfileClick,
          tooltip: 'Hồ sơ người dùng',
        ),
      ),

      // 2. Khu vực ở giữa: Logo Ứng dụng/Tiêu đề (Title)
      title: const Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.movie, color: Colors.indigo, size: 28.0), // Icon Máy bay
          SizedBox(width: 8.0),
        ],
      ),
      centerTitle: true, // Đảm bảo tiêu đề được căn giữa

      // 3. Khu vực bên phải: Nút Lịch sử Đặt vé (Actions)
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.confirmation_num, color: Colors.indigo),
          onPressed: _handleHistoryClick,
          tooltip: 'Lịch sử Đặt vé',
        ),
        const SizedBox(width: 8.0), // Khoảng cách nhỏ ở cuối
      ],
    );
  }
}
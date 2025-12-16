import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class ShowtimeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ShowtimeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // 🎬 Nút quay lại
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: AppColors.gold, // Accent vàng điện ảnh
        ),
        onPressed: () => Navigator.pop(context),
      ),

      // 🎟 Tiêu đề màn hình
      title: const Text(
        'Suất chiếu',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: AppColors.textPrimary, // Chữ trắng
        ),
      ),

      centerTitle: true,

      // 🎬 Nền AppBar điện ảnh
      backgroundColor: AppColors.bgPrimary,

      // Bóng đổ nhẹ, tạo chiều sâu
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.4),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

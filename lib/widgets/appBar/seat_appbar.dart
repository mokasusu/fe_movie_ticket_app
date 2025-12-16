import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class SeatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SeatAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // 🎬 Nút quay lại
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: AppColors.gold, // Màu accent vàng điện ảnh
        ),
        onPressed: () => Navigator.pop(context),
      ),

      // 🎟 Tiêu đề màn hình
      title: const Text(
        'Chọn ghế',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: AppColors.textPrimary, // Chữ trắng nổi trên nền tối
        ),
      ),

      centerTitle: true,

      // 🎬 Nền AppBar điện ảnh
      backgroundColor: AppColors.bgPrimary,

      // Bóng đổ nhẹ, không gắt
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.4),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

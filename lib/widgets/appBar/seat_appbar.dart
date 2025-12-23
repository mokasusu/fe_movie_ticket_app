import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class SeatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SeatAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: AppColors.textPrimary,
        ),
        onPressed: () => Navigator.pop(context),
      ),

      title: const Text(
        'Chọn ghế',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: AppColors.textPrimary,
          shadows: [
            Shadow(
              offset: Offset(0,0.2),
              blurRadius: 2.0,
              color: AppColors.textPrimary,
            ),
          ],
        ),
      ),

      centerTitle: true,

      backgroundColor: AppColors.bgPrimary,

      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.4),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

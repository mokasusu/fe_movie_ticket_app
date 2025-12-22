import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class PayAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PayAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: AppColors.gold,
        ),
        onPressed: () => Navigator.pop(context),
      ),

      title: const Text(
        'Thanh toán',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: AppColors.gold,
          shadows: [
            Shadow(
              offset: Offset(0,0.2),
              blurRadius: 2.0,
              color: AppColors.gold,
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
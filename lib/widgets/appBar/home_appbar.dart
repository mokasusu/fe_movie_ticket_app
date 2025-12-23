import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../screens/userInfomation/profile.dart';
import '../../screens/invoice/invoice_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  // Hàm xử lý khi nhấn nút Hồ sơ
  void _handleProfileClick(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserProfileScreen()),
    );
  }

  // Hàm xử lý khi nhấn nút Lịch sử Đặt vé
  void _handleHistoryClick(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const InvoiceHistoryScreen()),
    );
    print('Nút Lịch sử Đặt vé đã được nhấn!');
    
  }

  // Chiều cao AppBar
  @override
  Size get preferredSize => const Size.fromHeight(64.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: preferredSize.height,
      backgroundColor: AppColors.bgPrimary,
      elevation: 6.0,
      shadowColor: Colors.black.withOpacity(0.4),
      //người dùng
      leading: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: IconButton(
          icon: const Icon(
            Icons.account_circle,
            size: 28.0,
            color: AppColors.gold, // 🎟 accent vàng
          ),
          onPressed: () => _handleProfileClick(context),
          tooltip: 'Hồ sơ người dùng',
        ),
      ),
      //logo
      title: Center(
        child: Image.asset(
          'assets/images/cinemode.png',
          height: 26.0,
          fit: BoxFit.contain,
        ),
      ),
      centerTitle: true,

      // lịch sử
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.confirmation_num, color: AppColors.gold),
          onPressed: () => _handleHistoryClick(context),
          tooltip: 'Lịch sử Đặt vé',
        ),
        const SizedBox(width: 8.0),
      ],
    );
  }
}

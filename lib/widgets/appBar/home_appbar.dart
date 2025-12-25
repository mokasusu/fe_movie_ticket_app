import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../screens/userInfomation/profile.dart';
import '../../screens/userInfomation/invoice_screen.dart';
import '../../services/api/user_service.dart';
import '../../models/user.dart';
import '../../services/auth/auth_service.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(64.0);
}

class _CustomAppBarState extends State<CustomAppBar> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final isLoggedIn = await AuthService.isLoggedIn();
    if (!isLoggedIn) {
      if (mounted) {
        setState(() {
          _user = null;
        });
      }
      return;
    }
    final user = await UserService.getMyInfo();
    if (mounted) {
      setState(() {
        _user = user;
      });
    }
  }

  // Hàm xử lý khi nhấn nút Hồ sơ
  void _handleProfileClick(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserProfileScreen()),
    ).then((_) {
      _loadUserInfo();
    });
  }

  // Hàm xử lý khi nhấn nút Lịch sử Đặt vé
  void _handleHistoryClick(BuildContext context) async {
    // Kiểm tra đăng nhập trước
    final isLoggedIn = await AuthService.isLoggedIn();
    if (!isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng đăng nhập để xem lịch sử!')),
      );
      return;
    }

    // Lấy userId từ UserService
    final user = await UserService.getMyInfo();
    if (user == null || user.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không lấy được thông tin người dùng!')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InvoiceHistoryScreen(userId: user.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Xác định đường dẫn avatar
    String? avatarUrl = _user?.anhURL;
    if (avatarUrl == null || avatarUrl.isEmpty) {
      avatarUrl = 'assets/avatar/default_avt.jpg';
    }
    return AppBar(
      toolbarHeight: widget.preferredSize.height,
      backgroundColor: AppColors.bgPrimary,
      elevation: 6.0,
      shadowColor: Colors.black.withOpacity(0.4),
      //người dùng - hiển thị avatar
      leading: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: IconButton(
          icon: avatarUrl.isNotEmpty
              ? Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.gold, width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundImage: avatarUrl.startsWith('assets/')
                        ? AssetImage(avatarUrl) as ImageProvider
                        : NetworkImage(avatarUrl),
                    backgroundColor: Colors.transparent,
                  ),
                )
              : const Icon(
                  Icons.account_circle,
                  size: 28.0,
                  color: AppColors.gold,
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

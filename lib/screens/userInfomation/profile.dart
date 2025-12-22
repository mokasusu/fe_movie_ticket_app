import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../models/user.dart';
import '../../services/api/user_service.dart';
import '../../services/auth/auth_service.dart';

// Import các widget con đã thiết kế
import '../../widgets/user/user_membership.dart';
import '../../widgets/user/options.dart';

// Import các màn hình con (để điều hướng)
import 'update_info.dart';
import 'change_password.dart';
import '../login_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late Future<User?> _userFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// Hàm tải dữ liệu User từ API
  Future<void> _loadData() async {
    setState(() {
      _userFuture = UserService.getMyInfo();
    });
  }

  /// Xử lý Đăng xuất
  void _handleLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgSecondary,
        title: const Text("Đăng xuất?", style: TextStyle(color: AppColors.textPrimary)),
        content: const Text(
          "Bạn có chắc chắn muốn đăng xuất khỏi tài khoản này?",
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Hủy", style: TextStyle(color: AppColors.textMuted)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await AuthService.logout();
              
              if (!mounted) return;
              // Chuyển về màn hình Login và xóa hết lịch sử
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text("Đăng xuất", style: TextStyle(color: AppColors.red)),
          ),
        ],
      ),
    );
  }

  /// Điều hướng sang trang Sửa thông tin
  void _navigateToEditProfile(User user) async {
    final bool? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfileScreen(user: user)),
    );

    // Nếu sửa thành công (trả về true), load lại data để cập nhật giao diện
    if (result == true) {
      _loadData();
    }
  }

  /// Điều hướng sang trang Đổi mật khẩu
  void _navigateToChangePassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: const Text("Tài khoản"),
        centerTitle: true,
        backgroundColor: AppColors.bgPrimary,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          // Nút refresh nhỏ trên appbar
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData, // Kéo xuống để refresh
        color: AppColors.gold,
        backgroundColor: AppColors.bgElevated,
        child: FutureBuilder<User?>(
          future: _userFuture,
          builder: (context, snapshot) {
            // 1. Đang tải
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.gold),
              );
            }

            // 2. Lỗi
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.red, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      "Có lỗi xảy ra tải thông tin",
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    TextButton(
                      onPressed: _loadData,
                      child: const Text("Thử lại", style: TextStyle(color: AppColors.gold)),
                    )
                  ],
                ),
              );
            }

            // 3. Chưa đăng nhập hoặc data null
            if (!snapshot.hasData || snapshot.data == null) {
               return const Center(child: Text("Không tìm thấy thông tin người dùng"));
            }

            // 4. Có dữ liệu -> Hiển thị UI chính
            final user = snapshot.data!;

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(), // Để RefreshIndicator hoạt động dù nội dung ngắn
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // --- WIDGET 1: THẺ THÀNH VIÊN ---
                  UserMembershipCard(
                    user: user,
                    onEditAvatarPress: () => _navigateToEditProfile(user),
                  ),

                  const SizedBox(height: 30),

                  // --- WIDGET 2: MENU LỰA CHỌN ---
                  ProfileMenuOptions(
                    onPersonalInfoTap: () => _navigateToEditProfile(user),
                    
                    onInvoicesTap: () {
                      print("Xem lịch sử hóa đơn");
                    },
                    
                    onChangePasswordTap: _navigateToChangePassword,
                    
                    onLogoutTap: _handleLogout,
                  ),

                  const SizedBox(height: 40),

                  // --- FOOTER (Phiên bản app) ---
                  const Text(
                    "Version 1.0.0",
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "© 2024 Cinema App",
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
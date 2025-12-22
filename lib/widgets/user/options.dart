import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class ProfileMenuOptions extends StatelessWidget {
  final VoidCallback? onPersonalInfoTap;
  final VoidCallback? onInvoicesTap;
  final VoidCallback? onChangePasswordTap;
  final VoidCallback? onLogoutTap;

  const ProfileMenuOptions({
    super.key,
    this.onPersonalInfoTap,
    this.onInvoicesTap,
    this.onChangePasswordTap,
    this.onLogoutTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // --- NHÓM 1: CÀI ĐẶT TÀI KHOẢN ---
        Container(
          decoration: BoxDecoration(
            color: AppColors.bgSecondary, // Nền tối thứ cấp
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.bgElevated, width: 1),
          ),
          child: Column(
            children: [
              _buildMenuItem(
                icon: Icons.person_outline,
                title: "Thông tin cá nhân",
                onTap: onPersonalInfoTap,
              ),
              _buildDivider(),
              _buildMenuItem(
                icon: Icons.receipt_long_outlined,
                title: "Lịch sử hóa đơn",
                onTap: onInvoicesTap,
              ),
              _buildDivider(),
              _buildMenuItem(
                icon: Icons.lock_outline,
                title: "Đổi mật khẩu",
                onTap: onChangePasswordTap,
              ),
            ],
          ),
        ),

        const SizedBox(height: 24), // Khoảng cách lớn trước nút đăng xuất

        // --- NHÓM 2: ĐĂNG XUẤT (NỔI BẬT) ---
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onLogoutTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.bgElevated, // Nền tiệp màu app
              foregroundColor: AppColors.red, // Chữ màu đỏ (Điểm nhấn)
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.red, width: 1), // Viền đỏ
              ),
              // Hiệu ứng khi nhấn
              overlayColor: AppColors.red.withOpacity(0.1),
            ),
            icon: const Icon(Icons.logout),
            label: const Text(
              "Đăng xuất",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Helper: Tạo từng dòng menu
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.bgElevated,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.gold, size: 20), // Icon màu Gold sang trọng
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary, // Chữ trắng
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        color: AppColors.textMuted, // Mũi tên màu xám tối
        size: 16,
      ),
    );
  }

  // Helper: Đường kẻ ngăn cách
  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: AppColors.bgElevated,
      indent: 60, // Thụt vào khớp với text
      endIndent: 20,
    );
  }
}
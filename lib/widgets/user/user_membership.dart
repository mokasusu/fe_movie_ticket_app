import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:intl/intl.dart';
import '../../models/user.dart';
import '../../theme/colors.dart';

class UserMembershipCard extends StatelessWidget {
  final User user;
  final VoidCallback? onEditAvatarPress;

  const UserMembershipCard({
    super.key,
    required this.user,
    this.onEditAvatarPress,
  });

  @override
  Widget build(BuildContext context) {
    // Format tiền tệ
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.bgSecondary, AppColors.bgElevated],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gold.withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // --- Phần trên: Avatar & Info ---
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildAvatarSection(),
                const SizedBox(height: 15),

                // Tên người dùng
                Text(
                  user.hoTen ?? "Khách hàng thân thiết",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    letterSpacing: 0.5,
                  ),
                ),

                // Email
                Text(
                  user.email ?? "user@example.com",
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Đường kẻ ngang mờ
          const Divider(height: 1, color: AppColors.bgElevated),

          // // --- Phần giữa: Thống kê ---
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          //   child: Row(
          //     children: [
          //       // Tổng chi tiêu (Màu Gold - Nhấn mạnh tiền bạc/VIP)
          //       _buildStatItem(
          //         "Tổng chi tiêu",
          //         currencyFormat.format(user.tongChiTieu ?? 0),
          //         Icons.monetization_on_outlined,
          //         AppColors.gold,
          //       ),

          //       // Đường kẻ dọc ngăn cách
          //       Container(width: 1, height: 40, color: AppColors.textMuted.withOpacity(0.3)),

          //       // Phim đã xem (Màu Neon Blue - Công nghệ/Màn hình)
          //       _buildStatItem(
          //         "Phim đã xem",
          //         "${user.soPhimDaXem ?? 0}",
          //         Icons.movie_filter_outlined,
          //         AppColors.neonBlue,
          //       ),
          //     ],
          //   ),
          // ),

          // --- Phần dưới: Mã vạch ---
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
            ),
            child: Column(
              children: [
                BarcodeWidget(
                  barcode: Barcode.code128(),
                  data: user.id ?? "UNKNOWN",
                  height: 50,
                  drawText: false, // Không vẽ text của lib barcode
                  color: Colors.black,
                ),
                const SizedBox(height: 5),
                Text(
                  (user.id ?? "Unknown ID").toUpperCase(),
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Avatar + Nút Edit
  Widget _buildAvatarSection() {
    return Center(
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.gold, width: 2),
            ),
            child: CircleAvatar(
              radius: 45,
              backgroundColor: AppColors.bgElevated,
              backgroundImage: (user.anhURL != null && user.anhURL!.isNotEmpty)
                  ? (user.anhURL!.startsWith('assets/')
                        ? AssetImage(user.anhURL!) as ImageProvider
                        : NetworkImage(user.anhURL!))
                  : null,
              child: (user.anhURL == null || user.anhURL!.isEmpty)
                  ? const Icon(
                      Icons.person,
                      size: 40,
                      color: AppColors.textMuted,
                    )
                  : null,
            ),
          ),

          // Nút Edit
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onEditAvatarPress,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.bgSecondary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.gold,
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.edit,
                  color: AppColors.textPrimary,
                  size: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Item thống kê
  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

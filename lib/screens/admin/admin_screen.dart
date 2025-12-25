import '../admin/film_screens/movie_management_screen.dart';
import 'package:flutter/material.dart';
import '../../utils/storage.dart';
import '../login_screen.dart';
import '../admin/ShowtimeManagementScreen.dart';
import '../admin/voucher_screens/voucher_admin_screen.dart';
import '../admin/revenue_screen.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  // Hàm xử lý đăng xuất
  void _logout(BuildContext context) async {
    await Storage.deleteToken(); // Xóa token
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Màu nền tối
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Admin Screen", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => _logout(context),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Xin chào, Admin! 👋",
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, // 2 cột
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildMenuCard(Icons.movie, "Quản lý Phim", Colors.orange, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MovieManagementScreen()),
                    );
                  }),
                  _buildMenuCard(Icons.calendar_today, "Suất chiếu", Colors.blue, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ShowtimeManagementScreen()),
                    );
                  }),
                  _buildMenuCard(Icons.confirmation_number, "Quản lý Voucher", Colors.green, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const VoucherAdminScreen()),
                    );
                  }),
                  // _buildMenuCard(Icons.people, "Người dùng", Colors.purple, () {}),
                  _buildMenuCard(Icons.bar_chart, "Doanh thu", Colors.redAccent, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RevenueScreen()),
                    );
                  }),
                  // _buildMenuCard(Icons.settings, "Cài đặt", Colors.grey, () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget con để vẽ từng ô menu
  Widget _buildMenuCard(IconData icon, String title, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E), // Màu card nhẹ hơn nền
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
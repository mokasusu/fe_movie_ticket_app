import 'package:flutter/material.dart';
import 'helper.dart';
import 'cinemode_info.dart';
import '../../theme/colors.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: const Text(
          "Mở rộng",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.bgSecondary,
        centerTitle: true,
        elevation: 0,
      ),

      body: Column(
        children: [
          const SizedBox(height: 20),
          // Header với logo
          Container(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Column(
              children: [
                const Image(
                  image: AssetImage('assets/images/cinemode.png'),
                  height: 80,
                  width: 200,
                ),
                const SizedBox(height: 5),
                const Text(
                  "Trải nghiệm điện ảnh đỉnh cao",
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Mục 1: Về chúng tôi
          _buildMenuItem(
            context,
            icon: Icons.info_outline,
            title: "Về chúng tôi",
            subtitle: "Thông tin về CINEMODE",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CinemaModeInfoScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 2),

          // Mục 2: Hỗ trợ
          _buildMenuItem(
            context,
            icon: Icons.headset_mic,
            title: "Hỗ trợ",
            subtitle: "Liên hệ CSKH 24/7",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelperScreen()),
              );
            },
          ),
          const Spacer(),
          // Footer
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Phiên bản 1.0.0",
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.bgSecondary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.gold, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.textMuted,
        ),
        onTap: onTap,
      ),
    );
  }
}

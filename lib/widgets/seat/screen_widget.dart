import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class ScreenWidget extends StatelessWidget {
  const ScreenWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 8, width: 300,
          decoration: BoxDecoration(
            color: AppColors.textPrimary, borderRadius: BorderRadius.circular(50),
            boxShadow: [BoxShadow(color: AppColors.textPrimary.withOpacity(0.3), blurRadius: 20, spreadRadius: 2)],
            gradient: LinearGradient(colors: [AppColors.textPrimary.withOpacity(0.1), AppColors.textPrimary, AppColors.textPrimary.withOpacity(0.1)])
          ),
        ),
        const SizedBox(height: 10),
        Text("MÀN HÌNH", style: TextStyle(color: AppColors.textSecondary.withOpacity(0.24), letterSpacing: 4, fontSize: 10)),
        CustomPaint(size: const Size(300, 40), painter: ScreenLightPainter())
      ],
    );
  }
}

class ScreenLightPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [AppColors.textPrimary.withOpacity(0.15), Colors.transparent],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path()..moveTo(0, 0)..lineTo(size.width, 0)..lineTo(size.width - 20, size.height)..lineTo(20, size.height)..close();
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// --- WIDGET THÔNG TIN (INFO BAR) ---
class CinemaInfoItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const CinemaInfoItem({Key? key, required this.icon, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFFFF6B6B)),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
      ],
    );
  }
}
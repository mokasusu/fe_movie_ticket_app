import 'package:flutter/material.dart';

class ScreenWidget extends StatelessWidget {
  const ScreenWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 8, width: 300,
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(50),
            boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.3), blurRadius: 20, spreadRadius: 2)],
            gradient: LinearGradient(colors: [Colors.white.withOpacity(0.1), Colors.white, Colors.white.withOpacity(0.1)])
          ),
        ),
        const SizedBox(height: 10),
        const Text("MÀN HÌNH", style: TextStyle(color: Colors.white24, letterSpacing: 4, fontSize: 10)),
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
        colors: [Colors.white.withOpacity(0.15), Colors.transparent],
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
        Text(text, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}
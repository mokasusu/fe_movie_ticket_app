import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class BookingInfoBar extends StatelessWidget {
  final String posterUrl;
  final String movieTitle;
  final String cinemaName;
  final String roomName;
  final String time;
  final String date;

  const BookingInfoBar({
    Key? key,
    required this.posterUrl,
    required this.movieTitle,
    required this.cinemaName,
    required this.roomName,
    required this.time,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(posterUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(1.0),
                      Colors.black.withOpacity(0.2),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),
            Text(
              movieTitle,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 28, // tăng font size
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black45,
                    blurRadius: 6,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Tên rạp căn giữa
        Center(
          child: Text(
            cinemaName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18, // tăng size
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Row: ngày chiếu | suất chiếu | phòng chiếu, căn giữa, nổi bật
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _infoColumn("Ngày", date, highlight: true),
              _infoColumn("Suất chiếu", time, highlight: true),
              _infoColumn("Phòng", roomName, highlight: true),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Màn hình giả định
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: ScreenWidget(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // Column thông tin nhỏ, highlight để làm nổi bật
  Widget _infoColumn(String title, String value, {bool highlight = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12, // tăng size
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: highlight ? AppColors.gold : AppColors.textPrimary,
            fontSize: 16, // tăng size
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// Màn hình giả định
class ScreenWidget extends StatelessWidget {
  const ScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 10, // tăng chiều cao
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.textPrimary,
            borderRadius: BorderRadius.circular(50),
            gradient: LinearGradient(
              colors: [
                AppColors.textPrimary.withOpacity(0.1),
                AppColors.textPrimary,
                AppColors.textPrimary.withOpacity(0.1),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "MÀN HÌNH",
          style: TextStyle(
            color: AppColors.textSecondary.withOpacity(0.6), // tăng độ rõ
            letterSpacing: 4,
            fontSize: 14, // tăng size
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        CustomPaint(
          size: const Size(double.infinity, 50),
          painter: ScreenLightPainter(),
        ), // tăng chiều cao
      ],
    );
  }
}

class ScreenLightPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColors.textPrimary.withOpacity(0.2), Colors.transparent],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width - 20, size.height)
      ..lineTo(20, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

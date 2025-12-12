import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Dùng cho file .json
import '../../screens/login/login_screen.dart'; // Để chuyển hướng khi nhấn "Bắt đầu"

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Có thể bỏ dòng này nếu dùng Expanded
          children: [
            // 🔹 Phần hình ảnh hoặc animation
            Expanded( // <-- Bỏ comment Expanded này
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                // Chọn một trong hai: Lottie hoặc Image.asset
                // Ví dụ: Bỏ comment Lottie nếu bạn có file assets/animations/movie_intro.json
                child: Lottie.asset(
                  'assets/animations/movie_intro.json',
                  fit: BoxFit.contain,
                ),
                // Hoặc dùng ảnh tĩnh:
                //child: Image.asset('assets/images/movie_intro.png'), // <-- Bỏ comment dòng này hoặc dòng Lottie
              ),
            ),

            // 🔹 Phần nội dung giới thiệu
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  const Text(
                    // "🎬 Ứng dụng đặt vé xem phim",
                    " Ứng dụng đặt vé xem phim",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Đặt vé nhanh chóng, xem trailer, chọn ghế yêu thích và tận hưởng những bộ phim hot nhất!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey, // Đổi màu để dễ nhìn hơn
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 🔹 Nút "Bắt đầu"
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 48, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      // Loại bỏ các thuộc tính bị deprecate
                      // foregroundColor: Colors.white, // màu chữ
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Text(
                      "Bắt đầu",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
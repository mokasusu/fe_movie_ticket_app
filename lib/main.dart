import 'package:flutter/material.dart';
import 'package:home/screens/login_screen.dart';
import 'widgets/bottomBar/bottom_nav_bar.dart';
import 'utils/global_keys.dart';

void main() {
  runApp(const MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Ticket App',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      // 3. Gán navigatorKey để DioClient có thể gọi chuyển màn hình từ bất cứ đâu
      navigatorKey: AppGlobalKeys.navigatorKey,
      
      // 4. Định nghĩa route '/login' để DioClient gọi pushNamed('/login')
      routes: {
        '/login': (context) => const BottomNavBar(),
      },

      home: const LoginScreen(),
    );
  }
}
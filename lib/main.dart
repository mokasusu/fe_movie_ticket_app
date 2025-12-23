import 'package:flutter/material.dart';
import 'package:home/screens/login_screen.dart';
import 'widgets/bottomBar/bottom_nav_bar.dart';
import 'utils/global_keys.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('vi', 'VN'), // Hỗ trợ Tiếng Việt
        Locale('en', 'US'), // Hỗ trợ Tiếng Anh
      ],
      locale: const Locale('vi', 'VN'),
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        fontFamily: 'Roboto',
      ),
      navigatorKey: AppGlobalKeys.navigatorKey,
      routes: {'/login': (context) => const BottomNavBar()},
      home: const LoginScreen(),
    );
  }
}

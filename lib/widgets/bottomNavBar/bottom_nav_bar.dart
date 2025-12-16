import 'package:flutter/material.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/cinema/cinema_list_screen.dart';
import '../../theme/colors.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _pageIndex = 0;

  final List<Widget> pages = [
    HomeScreen(),
    CinemaListScreen(),
    const Center(child: Text("Notifications")),
    const Center(child: Text("More")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_pageIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
        type: BottomNavigationBarType.fixed,

        // 🎬 Nền tối điện ảnh
        backgroundColor: AppColors.bgSecondary,

        // 🎟 Tab đang chọn – vàng điện ảnh
        selectedItemColor: AppColors.gold,

        // Tab chưa chọn – chữ/màu mờ
        unselectedItemColor: AppColors.textMuted,

        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w400,
        ),

        onTap: (index) => setState(() => _pageIndex = index),

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_city_rounded),
            label: "Cinemas",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Notify",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "More",
          ),
        ],
      ),
    );
  }
}

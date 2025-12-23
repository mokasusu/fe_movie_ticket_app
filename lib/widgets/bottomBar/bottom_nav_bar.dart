import 'package:flutter/material.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/cinema/cinema_list_screen.dart';
import '../../screens/voucher/voucher_list_screen.dart';
import '../../screens/news/news_list_screen.dart';
import '../../screens/more/more_screen.dart';
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
    const VoucherListScreen(showBackButton: false),
    const NewsListScreen(),
    const MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_pageIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
        type: BottomNavigationBarType.fixed,

        backgroundColor: AppColors.bgSecondary,

        selectedItemColor: AppColors.gold,

        unselectedItemColor: AppColors.textMuted,

        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),

        onTap: (index) => setState(() => _pageIndex = index),

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Trang chủ"),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_city_rounded),
            label: "Rạp",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: "Voucher",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: "Tin tức"),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Khác"
          ),
        ],
      ),
    );
  }
}

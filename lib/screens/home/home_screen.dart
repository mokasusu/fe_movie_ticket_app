import 'package:flutter/material.dart';
import '../../widgets/appBar/home_appbar.dart';
import '../../widgets/card/promo_slider.dart';
import '../../widgets/card/movie_card_slider.dart';
import '../../widgets/card/coming_soon_slider.dart';
import '../../theme/colors.dart';
import '../../widgets/bottomBar/bottom_nav_bar.dart';
import '../../models/promotion.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<Promotion> _promotions = [
    Promotion(
      title: 'Khuyến mãi 1',
      color: AppColors.gold,
      imagePath: 'assets/promotions/promotion1.png',
    ),
    Promotion(
      title: 'Khuyến mãi 2',
      color: AppColors.neonBlue,
      imagePath: 'assets/promotions/promotion2.png',
    ),
    Promotion(
      title: 'Khuyến mãi 3',
      color: AppColors.red,
      imagePath: 'assets/promotions/promotion3.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: AppColors.bgPrimary,
      // Body home
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            PromotionsSlider(promotions: _promotions),
            const SizedBox(height: 10),
            MovieCard(),
            ComingSoonSlider(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

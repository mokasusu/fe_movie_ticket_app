import 'package:flutter/material.dart';
import '../../widgets/appBar/home_appbar.dart';
import '../../widgets/card/promo_slider.dart';
import '../../widgets/card/movie_card_slider.dart';
import '../../widgets/card/voucher_slider.dart';
import '../../widgets/card/coming_soon_slider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: Colors.blue,
      // Body home
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // PromotionsSlider(promotions: mockPromotions),
            MovieCard(),
            // VoucherSlider(vouchers: mockVouchers),
            ComingSoonSlider(),
            //Tạo khoảng trống ở dưới cùng
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

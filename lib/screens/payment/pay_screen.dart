import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../models/movie.dart';
import '../../models/food.dart';
import '../../models/cinema.dart';
import '../../models/showtime.dart';

import '../../widgets/appBar/pay_appbar.dart';
import '../../widgets/pay/info_ticket.dart';

class PayScreen extends StatelessWidget {
  final Movie movie;
  final Cinema cinema;
  final Showtime showtime;
  final List<String> seatNumbers;
  final int totalSeat;
  // final List<Food> selectedFoods;

  const PayScreen({
    super.key,
    required this.movie,
    required this.cinema,
    required this.showtime,
    required this.seatNumbers,
    required this.totalSeat,
    // required this.selectedFoods,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: PayAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InfoTicket(
              movie: movie,
              cinema: cinema,
              showtime: showtime,
              seatNumbers: seatNumbers,
              totalSeat: totalSeat,
            ),
            // Additional payment details can be added here
          ],
        ),
      ),
    );
  }
}
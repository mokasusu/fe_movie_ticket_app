import 'package:flutter/material.dart';
import 'package:home/models/showtime.dart';
import 'package:intl/intl.dart';
import '../../models/film_model.dart';
import '../../models/cinema.dart';
import '../../models/showtime.dart';
import '../../models/seat.dart';
import '../../services/api/seat_service.dart';
import '../../theme/colors.dart';
import '../../widgets/appBar/seat_appbar.dart';
import '../../widgets/seat/seat_map.dart';
import '../../widgets/seat/screen_widget.dart';
import '../../widgets/bottomBar/seat_bottom_bar.dart';
import '../payment/pay_screen.dart';

class SeatScreen extends StatefulWidget {
  final FilmResponse movie;
  final Cinema cinema;
  final Showtime showtime;
  const SeatScreen({
    super.key,
    required this.showtime,
    required this.movie,
    required this.cinema,
  });

  @override
  State<SeatScreen> createState() => _SeatScreenState();
}

class _SeatScreenState extends State<SeatScreen> {
  List<String> bookedSeats = [];
  List<String> selectedSeats = [];
  List<Seat> seatObjects = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookedSeats();
  }

  Future<void> _loadBookedSeats() async {
    setState(() => isLoading = true);
    bookedSeats = await SeatService.fetchBookedSeats(widget.showtime.id);

    // Tạo danh sách Seat objects với trạng thái đã đặt
    seatObjects = Seat.generateSeats(bookedIds: bookedSeats)
        .expand((row) => row)
        .toList();

    setState(() => isLoading = false);
  }

  void _onSelectionChanged(List<String> seatIds) {
    setState(() {
      selectedSeats = seatIds;

      for (var seat in seatObjects) {
        seat.isSelected = selectedSeats.contains(seat.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('dd/MM/yyyy HH:mm').format(widget.showtime.tgBatDau);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: SeatAppBar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [

                        // Màn hình
                        BookingInfoBar(posterUrl: widget.movie.anhPosterNgang, movieTitle: widget.movie.tenPhim, cinemaName: widget.cinema.tenRap, roomName: widget.showtime.tenPhong, time: DateFormat('HH:mm').format(widget.showtime.tgBatDau), date: DateFormat('dd/MM/yyyy').format(widget.showtime.tgBatDau)),

                        const SizedBox(height: 16),

                        // Sơ đồ ghế
                        SeatMapWidget(
                          bookedIds: bookedSeats,
                          onSelectionChanged: _onSelectionChanged,
                        ),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),

                SeatBottomBar(
                  selectedSeats: seatObjects.where((s) => s.isSelected).toList(),
                  onBookPressed: () {
                    final selectedSeatIds = seatObjects
                        .where((s) => s.isSelected)
                        .map((s) => s.id)
                        .toList();

                    // Chuyển sang PayScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PayScreen(
                          movie: widget.movie,
                          cinema: widget.cinema,
                          showtime: widget.showtime,
                          seatNumbers: selectedSeatIds,
                          totalSeat: selectedSeatIds.length,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }
}

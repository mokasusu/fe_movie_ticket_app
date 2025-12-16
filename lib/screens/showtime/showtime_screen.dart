import 'package:flutter/material.dart';
import '../../widgets/appBar/showtime_appbar.dart';
import '../../widgets/showtime/choice_date.dart';
import '../../widgets/card/showtime_card.dart';
import '../../models/movie.dart';
import '../../models/showtime.dart';
import '../../screens/seat/seat_selection_screen.dart';
import '../../theme/colors.dart';

import '../../services/api/showtime_service.dart';
import '../../services/api/movie_service.dart';
import '../../services/api/cinema_service.dart';

class ShowtimeScreen extends StatefulWidget {
  final int? cinemaId;       // Luồng chọn rạp → xem phim
  final Movie? selectedMovie;   // Luồng chọn phim → xem rạp

  const ShowtimeScreen({super.key, this.cinemaId, this.selectedMovie});

  @override
  State<ShowtimeScreen> createState() => _ShowtimeScreenState();
}

class _ShowtimeScreenState extends State<ShowtimeScreen> {
  DateTime selectedDate = DateTime.now();
  bool isLoading = false;

  List<Movie> allMovies = [];
  List<Showtime> allShowtimes = [];
  Map<String, List<Showtime>> movieShowtimes = {};

  String cinemaName = "";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => isLoading = true);

    allMovies = await MovieService.fetchAllMovies();

    if (widget.cinemaId != null) {
      allShowtimes = await ShowtimeService.fetchByCinema(widget.cinemaId!);
    } else if (widget.selectedMovie != null) {
      allShowtimes =
          await ShowtimeService.fetchByMovie(widget.selectedMovie!.maPhim);
    }

    _filterByDate(selectedDate);

    setState(() => isLoading = false);
  }

  void _filterByDate(DateTime date) {
    final Map<String, List<Showtime>> newMap = {};

    for (var s in allShowtimes) {
      if (s.tgBatDau.year == date.year &&
          s.tgBatDau.month == date.month &&
          s.tgBatDau.day == date.day) {
        newMap.putIfAbsent(s.maPhim, () => []).add(s);
      }
    }

    movieShowtimes = newMap;
  }

  Future<void> _onDateSelected(DateTime date) async {
    setState(() {
      selectedDate = date;
      isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 150));

    _filterByDate(date);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final activeMovies = allMovies.where((movie) {
      final showtimes = movieShowtimes[movie.maPhim];
      return showtimes != null && showtimes.isNotEmpty;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: const ShowtimeAppBar(),
      body: Stack(
        children: [
          Column(
            children: [
              /// Tên rạp
              if (cinemaName.isNotEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  color: AppColors.bgSecondary,
                  width: double.infinity,
                  child: Text(
                    cinemaName,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

              MovieDatePicker(
                currentDate: selectedDate,
                onDateSelected: _onDateSelected,
              ),

              /// Thanh ngày chiếu
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: AppColors.bgSecondary,
                child: Text(
                  "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),

              Expanded(
                child: activeMovies.isEmpty
                    ? const Center(
                        child: Text(
                          "Không có suất chiếu",
                          style: TextStyle(
                            color: AppColors.textMuted,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: activeMovies.length,
                        itemBuilder: (context, index) {
                          final movie = activeMovies[index];
                          final showtimes =
                              movieShowtimes[movie.maPhim]!;

                          return ShowtimeCard(
                            movie: movie,
                            showtimes: showtimes,
                            onShowtimeSelected: (s) {},
                          );
                        },
                      ),
              ),
            ],
          ),

          /// Loading overlay
          if (isLoading)
            Positioned.fill(
              child: Container(
                color: AppColors.bgPrimary.withOpacity(0.6),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.gold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

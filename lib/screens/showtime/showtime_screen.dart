import 'package:flutter/material.dart';
import 'package:home/models/cinema.dart';
import '../../widgets/appBar/showtime_appbar.dart';
import '../../widgets/showtime/choice_date.dart';
import '../../widgets/card/showtime_card.dart';
import '../../models/film_model.dart';
import '../../models/showtime.dart';
import '../../theme/colors.dart';
import '../../screens/seat/seat_selection_screen.dart';
import '../../utils/utils.dart';
import '../../services/api/showtime_service.dart';
import '../../services/api/movie_service.dart';

class ShowtimeScreen extends StatefulWidget {
  final Cinema selectedCinema;
  final FilmResponse? selectedMovie;

  const ShowtimeScreen({
    super.key,
    required this.selectedCinema,
    this.selectedMovie,
  });

  @override
  State<ShowtimeScreen> createState() => _ShowtimeScreenState();
}

class _ShowtimeScreenState extends State<ShowtimeScreen> {
  DateTime selectedDate = DateTime.now();
  bool isLoading = false;

  List<Showtime> _allShowtimes = [];

  Map<String, List<Showtime>> movieShowtimes = {};

  Map<String, FilmResponse> movieMap = {};

  @override
  void initState() {
    super.initState();
    _loadShowtimes();
  }

  Future<void> _loadShowtimes() async {
    setState(() => isLoading = true);

    _allShowtimes = await ShowtimeService.searchShowtimes(
      maPhim: widget.selectedMovie?.maPhim,
      maRap: widget.selectedCinema.maRap,
    );

    final maPhimSet = _allShowtimes
        .map((s) => s.maPhim)
        .toSet();

    if (maPhimSet.isNotEmpty) {
      final movies = await MovieService.fetchAllMovies();
      movieMap = {
        for (var m in movies)
          if (maPhimSet.contains(m.maPhim)) m.maPhim: m
      };
    }

    _buildMovieShowtimes();

    setState(() => isLoading = false);
  }

  void _navigateToSeatScreen({
    required BuildContext context,
    required Showtime showtime,
    required FilmResponse movie,
    required Cinema cinema,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SeatScreen(
          showtime: showtime,
          movie: movie,
          cinema: cinema,
        ),
      ),
    );
  }
  void _buildMovieShowtimes() {
    movieShowtimes.clear();

    for (final s in _allShowtimes) {
      if (!isSameDate(s.tgBatDau, selectedDate)) continue;

      movieShowtimes.putIfAbsent(s.maPhim, () => []).add(s);
    }
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
      _buildMovieShowtimes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final movieKeys = movieShowtimes.keys.toList();

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: const ShowtimeAppBar(),
      body: Stack(
        children: [
          Column(
            children: [
              MovieDatePicker(
                currentDate: selectedDate,
                onDateSelected: _onDateSelected,
              ),

              Expanded(
                child: movieKeys.isEmpty
                    ? const Center(
                        child: Text(
                          "Không có suất chiếu",
                          style: TextStyle(
                            color: AppColors.textMuted,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: movieKeys.length,
                        itemBuilder: (context, index) {
                          final maPhim = movieKeys[index];
                          final movie = movieMap[maPhim];
                          final showtimes = movieShowtimes[maPhim]!;

                          if (movie == null) return const SizedBox();

                          return ShowtimeCard(
                            movie: movie,
                            showtimes: showtimes,
                            onShowtimeSelected: (s) {
                              _navigateToSeatScreen(
                                context: context,
                                showtime: s,
                                movie: movie,
                                cinema: widget.selectedCinema,
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),

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

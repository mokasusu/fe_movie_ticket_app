import 'package:flutter/material.dart';
import '../../models/film_model.dart';
import '../../screens/detailMovie/movie_detail_screen.dart';
import '../../services/api/movie_service.dart';
import '../../screens/cinema/cinema_list_screen.dart';
import '../../theme/colors.dart';

class MovieCard extends StatefulWidget {
  const MovieCard({super.key});

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  List<FilmResponse> _movies = [];
  bool _isLoading = true;

  double _tapScale = 1.0;
  late PageController _pageController;

  static const Duration duration = Duration(milliseconds: 150);
  static const double activeTapScale = 0.95;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    final data = await MovieService.fetchMoviesNowShowing();
    setState(() {
      _movies = data;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _tapScale = activeTapScale);
  }

  void _onTapUp(TapUpDetails details) {
    Future.delayed(duration, () {
      if (mounted) setState(() => _tapScale = 1.0);
    });
  }

  void _onTapCancel() {
    setState(() => _tapScale = 1.0);
  }

  void _openMovieDetail(FilmResponse movie) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MovieDetailPage(movie: movie)),
    );
  }

  void _openCinemaScreen(FilmResponse movie) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CinemaListScreen(selectedMovie: movie)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bodyHeight =
        MediaQuery.of(context).size.height -
        kToolbarHeight -
        MediaQuery.of(context).padding.top;

    final cardHeight = bodyHeight / 2;
    const double cardWidth = 300;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_movies.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          "Không có phim đang chiếu",
          style: TextStyle(color: AppColors.textSecondary, fontSize: 18),
        ),
      );
    }

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Đoạn thẳng vàng dọc
                SizedBox(
                  width: 5,
                  height: 32,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  'Phim đang chiếu',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: cardHeight + 48,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _movies.length,
            itemBuilder: (context, index) {
              final movie = _movies[index];

              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double scale = 1.0;
                  if (_pageController.position.haveDimensions) {
                    final page = _pageController.page ?? index.toDouble();
                    scale = (1 - (index - page).abs() * 0.1).clamp(0.9, 1.0);
                  }

                  return Center(
                    child: Transform.scale(
                      scale: scale * _tapScale,
                      child: GestureDetector(
                        onTapDown: _onTapDown,
                        onTapUp: _onTapUp,
                        onTapCancel: _onTapCancel,
                        onTap: () => _openMovieDetail(movie),
                        child: Container(
                          width: cardWidth,
                          height: cardHeight,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.bgPrimary.withOpacity(0.6),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(
                                  movie.anhPosterDoc,
                                  fit: BoxFit.cover,
                                ),

                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.red,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      "${movie.doTuoi}",
                                      style: const TextStyle(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),

                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          AppColors.bgPrimary.withOpacity(0.95),
                                        ],
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          movie.tenPhim,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: AppColors.textPrimary,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Thể loại: ${movie.genres.join(', ')}",
                                          style: const TextStyle(
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Center(
                                          child: ElevatedButton.icon(
                                            onPressed: () =>
                                                _openCinemaScreen(movie),
                                            icon: const Icon(
                                              Icons.confirmation_number,
                                            ),
                                            label: const Text("ĐẶT VÉ NGAY"),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.gold,
                                              foregroundColor:
                                                  AppColors.bgPrimary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

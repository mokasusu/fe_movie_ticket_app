import 'package:flutter/material.dart';
import '../../models/movie.dart';
import '../../screens/detailMovie/movie_detail_screen.dart';
import '../../services/api/movie_service.dart';
import '../../screens/cinema/cinema_list_screen.dart';


class MovieCard extends StatefulWidget {
  const MovieCard({super.key});

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  List<Movie> _movies = [];
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

  void _openMovieDetail(Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailPage(movie: movie),
      ),
    );
  }

  void _openCinemaScreen(Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CinemaListScreen(selectedMovie: movie),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bodyHeight = MediaQuery.of(context).size.height -
        kToolbarHeight -
        MediaQuery.of(context).padding.top;
    final cardHeight = bodyHeight / 2;
    const double cardWidth = 300;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_movies.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text("Không có phim đang chiếu", style: TextStyle(fontSize: 18)),
      );
    }

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Phim đang chiếu',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
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

              // Poster
              final poster = movie.anhPosterDoc;

              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double positionScale = 1.0;
                  if (_pageController.position.haveDimensions) {
                    double page = _pageController.page ?? index.toDouble();
                    double diff = (index - page).clamp(-1.0, 1.0);
                    positionScale = (1 - diff.abs() * 0.1).clamp(0.9, 1.0);
                  }

                  final scale = positionScale * _tapScale;

                  return Center(
                    child: GestureDetector(
                      onTapDown: _onTapDown,
                      onTapUp: _onTapUp,
                      onTapCancel: _onTapCancel,
                      onTap: () => _openMovieDetail(movie),
                      child: Transform.scale(
                        scale: scale,
                        child: Container(
                          width: cardWidth,
                          height: cardHeight,
                          margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
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
                                // Poster
                                Image.network(
                                  poster,
                                  fit: BoxFit.cover,
                                ),

                                // Tag độ tuổi
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.red[700],
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      "${movie.doTuoi}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),

                                // Gradient + tên phim + thể loại + nút đặt vé
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.85)
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          movie.tenPhim,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Thể loại: ${movie.genres.join(', ')}",
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Center(
                                          child: ElevatedButton.icon(
                                            onPressed: () => _openCinemaScreen(movie),//mở màn hình chọn rạp
                                            icon: const Icon(Icons.confirmation_number),
                                            label: const Text("ĐẶT VÉ NGAY"),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.pinkAccent,
                                              foregroundColor: Colors.white,
                                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
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

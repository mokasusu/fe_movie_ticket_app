import 'package:flutter/material.dart';
import '/models/movie.dart';
import '../../screens/detailMovie/movie_detail_screen.dart';
import '../../services/api/movie_service.dart';
import '../../theme/colors.dart';

class ComingSoonSlider extends StatelessWidget {
  const ComingSoonSlider({super.key});

  @override
  Widget build(BuildContext context) {
    const cardWidth = 180.0;
    const cardHeight = 240.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 🎬 Tiêu đề section
        const Padding(
          padding: EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
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
                'Phim Sắp Chiếu',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary, // chữ trắng điện ảnh
                ),
              ),
            ],
          ),
        ),

        FutureBuilder<List<Movie>>(
          future: MovieService.fetchMoviesComingSoon(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: cardHeight,
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.gold, // loading vàng
                  ),
                ),
              );
            }

            if (snapshot.hasError) {
              return SizedBox(
                height: cardHeight,
                child: const Center(
                  child: Text(
                    "Lỗi tải dữ liệu",
                    style: TextStyle(color: AppColors.red),
                  ),
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return SizedBox(
                height: cardHeight,
                child: const Center(
                  child: Text(
                    "Không có phim sắp chiếu",
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                ),
              );
            }

            final movies = snapshot.data!;

            return SizedBox(
              height: cardHeight,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];

                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 16.0 : 8.0,
                      right: index == movies.length - 1 ? 16.0 : 8.0,
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MovieDetailPage(movie: movie),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(12.0),
                      child: Container(
                        width: cardWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(
                                0.6,
                              ), // bóng đổ đậm hơn cho dark UI
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // Poster
                              Image.network(
                                movie.anhPosterDoc,
                                fit: BoxFit.cover,
                              ),

                              // 🎞 Overlay gradient điện ảnh
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        AppColors.bgPrimary.withOpacity(0.9),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        movie.tenPhim,
                                        style: const TextStyle(
                                          color: AppColors.textPrimary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        "Thể loại: ${movie.genres.join(', ')}",
                                        style: const TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                    ],
                                  ),
                                ),
                              ),

                              // 🎟 Tag độ tuổi
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.red, // đỏ thảm đỏ
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    "${movie.doTuoi}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

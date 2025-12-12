import 'package:flutter/material.dart';
import '/models/movie.dart';
import '../../screens/detailMovie/movie_detail_screen.dart';
import '../../services/api/movie_service.dart';

class ComingSoonSlider extends StatelessWidget {
  const ComingSoonSlider({super.key});

  @override
  Widget build(BuildContext context) {
    const cardWidth = 180.0;
    const cardHeight = 240.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Tiêu đề
        const Padding(
          padding: EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
          child: Text(
            'Phim Sắp Chiếu',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),

        FutureBuilder<List<Movie>>(
          future: MovieService.fetchMoviesComingSoon(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: cardHeight,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (snapshot.hasError) {
              return SizedBox(
                height: cardHeight,
                child: const Center(
                  child: Text(
                    "Lỗi tải dữ liệu",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return SizedBox(
                height: cardHeight,
                child: const Center(child: Text("Không có phim sắp chiếu")),
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
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // Poster luôn có
                              Image.network(
                                movie.anhPosterDoc,
                                fit: BoxFit.cover,
                              ),

                              // Gradient + tên phim + thể loại + nút đặt vé
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
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        "Thể loại: ${movie.genres.join(', ')}",
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                    ],
                                  ),
                                ),
                              ),

                              // Tag độ tuổi
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.red[700],
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

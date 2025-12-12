import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../models/movie.dart';
import '../../widgets/detail/trailer_curve_clipper.dart';

class MovieDetailPage extends StatelessWidget {
  final Movie movie;

  const MovieDetailPage({super.key, required this.movie});

  bool _isValidUrl(String? url) {
    return url != null && url.trim().isNotEmpty && url.startsWith("http");
  }

  @override
  Widget build(BuildContext context) {
    final posterHeight = 180.0;
    final posterWidth = 130.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 260 + posterHeight / 2,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Banner background
                  ClipPath(
                    clipper: TrailerCurveClipper(),
                    child: Container(
                      height: 260,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        image: _isValidUrl(movie.anhPosterNgang)
                            ? DecorationImage(
                                image: NetworkImage(movie.anhPosterNgang),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.45),
                                  BlendMode.darken,
                                ),
                              )
                            : null,
                      ),
                      child: !_isValidUrl(movie.anhPosterNgang)
                          ? const Center(
                              child: Icon(Icons.movie,
                                  color: Colors.white, size: 80),
                            )
                          : null,
                    ),
                  ),

                  // Back button
                  Positioned(
                    top: 40,
                    left: 16,
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withOpacity(0.45),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),

                  // Play button
                  Positioned(
                    top: 100,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          if (movie.trailerUrl == null ||
                              movie.trailerUrl!.isEmpty) return;

                          _showTrailerDialog(context, movie.trailerUrl!);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.play_arrow,
                              size: 40, color: Colors.black),
                        ),
                      ),
                    ),
                  ),

                  // Poster
                  Positioned(
                    top: 260 - posterHeight / 2,
                    left: 16,
                    child: Container(
                      height: posterHeight,
                      width: posterWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: _isValidUrl(movie.anhPosterDoc)
                            ? Image.network(movie.anhPosterDoc!, fit: BoxFit.cover)
                            : const Center(
                                child: Icon(Icons.movie,
                                    size: 70, color: Colors.grey),
                              ),
                      ),
                    ),
                  ),

                  // Movie title + status
                  Positioned(
                    top: 260 - posterHeight / 2,
                    left: 16 + posterWidth + 16,
                    right: 16,
                    height: posterHeight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.tenPhim,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red[700],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            movie.trangThai.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Movie details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow("Thời lượng",
                      movie.thoiLuong == null ? "" : "${movie.thoiLuong} phút"),
                  _infoRow("Đạo diễn", movie.daoDien),
                  _infoRow(
                      "Diễn viên",
                      movie.dienVien == null || movie.dienVien!.isEmpty
                          ? ""
                          : movie.dienVien!),
                  _infoRow("Ngày công chiếu", movie.ngayCongChieu),
                  _infoRow("Độ tuổi",
                      movie.doTuoi == null ? "" : "${movie.doTuoi}+"),
                  const SizedBox(height: 20),
                  Text(
                    movie.moTa,
                    style: const TextStyle(fontSize: 18, height: 1.5),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTrailerDialog(BuildContext context, String trailerUrl) {
    final videoId = YoutubePlayer.convertUrlToId(trailerUrl) ?? "";

    YoutubePlayerController controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
    );

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      barrierDismissible: true,
      builder: (context) {
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 220,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
            ),
            child: YoutubePlayer(
              controller: controller,
              showVideoProgressIndicator: true,
            ),
          ),
        );
      },
    ).then((_) => controller.pause());
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/movie.dart';
import '../../models/showtime.dart';
import '../../screens/detailMovie/movie_detail_screen.dart';
import '../../theme/colors.dart';

class ShowtimeCard extends StatelessWidget {
  final Movie movie;
  final List<Showtime> showtimes;
  final void Function(Showtime) onShowtimeSelected;

  const ShowtimeCard({
    super.key,
    required this.movie,
    required this.showtimes,
    required this.onShowtimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (showtimes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      color: AppColors.bgSecondary,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: movie.anhPosterDoc,
                      width: 95,
                      height: 145,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.tenPhim,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 6),

                        Text(
                          movie.genres.join(', '),
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            const Icon(
                              Icons.access_time_filled,
                              size: 15,
                              color: AppColors.textMuted,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${movie.thoiLuong} phút",
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),

                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "T${movie.doTuoi}",
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const Spacer(),

                        Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MovieDetailPage(movie: movie),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  "Xem chi tiết",
                                  style: TextStyle(
                                    color: AppColors.neonBlue,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  size: 16,
                                  color: AppColors.neonBlue,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Divider(height: 1, thickness: 1, color: AppColors.bgElevated),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Suất chiếu:",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),

                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: showtimes.map((s) {
                    final timeStr =
                        "${s.tgBatDau.hour.toString().padLeft(2, '0')}:${s.tgBatDau.minute.toString().padLeft(2, '0')}";

                    return StatefulBuilder(
                      builder: (context, setState) {
                        bool isPressed = false;

                        return GestureDetector(
                          onTapDown: (_) => setState(() => isPressed = true),
                          onTapUp: (_) {
                            setState(() => isPressed = false);
                            onShowtimeSelected(s);
                          },
                          onTapCancel: () => setState(() => isPressed = false),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 100),
                            curve: Curves.easeOut,
                            transform: isPressed
                                ? (Matrix4.identity()..scale(0.95))
                                : Matrix4.identity(),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: isPressed
                                  ? AppColors.gold.withOpacity(0.2)
                                  : AppColors.bgSecondary,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.gold, width: 1.2),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.gold.withOpacity(isPressed ? 0.1 : 0.25),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Text(
                              timeStr,
                              style: const TextStyle(
                                color: AppColors.gold,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

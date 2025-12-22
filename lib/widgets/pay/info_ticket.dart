import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/colors.dart';
import '../../models/movie.dart';
import '../../models/cinema.dart';
import '../../models/showtime.dart';

class InfoTicket extends StatelessWidget {
  final Movie movie;
  final Cinema cinema;
  final Showtime showtime;
  final List<String> seatNumbers;
  final int totalSeat;

  const InfoTicket({
    super.key,
    required this.movie,
    required this.cinema,
    required this.showtime,
    required this.seatNumbers,
    required this.totalSeat,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final timeFormat = DateFormat('HH:mm');
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Poster with overlay
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.network(
                  movie.anhPosterDoc,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.bgElevated.withOpacity(0.85),
                      Colors.transparent,
                      AppColors.bgElevated.withOpacity(0.85),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  movie.tenPhim,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black87,
                        blurRadius: 8,
                        offset: Offset(1, 2),
                      ),
                      Shadow(color: AppColors.textPrimary, blurRadius: 2),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                buildInfoRow('Rạp', cinema.tenRap),
                buildInfoRow(
                  'Ngày chiếu',
                  dateFormat.format(showtime.tgBatDau),
                ),
                buildInfoRow('Giờ chiếu', timeFormat.format(showtime.tgBatDau)),
                buildInfoRow('Phòng chiếu', showtime.tenPhong),
                buildInfoRow('Ghế', seatNumbers.join(', ')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

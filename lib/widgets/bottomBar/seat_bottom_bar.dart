import 'package:flutter/material.dart';
import '../../models/seat.dart';
import '../../theme/colors.dart';

class SeatBottomBar extends StatelessWidget {
  final List<Seat> selectedSeats;
  final VoidCallback onBookPressed;

  const SeatBottomBar({
    Key? key,
    this.selectedSeats = const [],
    required this.onBookPressed,
  }) : super(key: key);

  int _calculateTotal() {
    int total = 0;
    for (var seat in selectedSeats) {
      switch (seat.type) {
        case SeatType.normal:
          total += 45000;
          break;
        case SeatType.vip:
          total += 70000;
          break;
        case SeatType.couple:
          total += 120000;
          break;
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final total = _calculateTotal();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, -2),
          )
        ],
      ),
      child: Row(
        children: [
          // Tổng tiền
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ghế đã chọn: ${selectedSeats.map((s) => s.id).join(', ')}",
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Tổng tiền: ${total.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]}.")} đ",
                  style: const TextStyle(
                    color: AppColors.gold,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          ElevatedButton(
            onPressed: selectedSeats.isEmpty ? null : onBookPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.gold,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Đặt vé",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}

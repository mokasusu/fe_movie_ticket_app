import 'package:flutter/material.dart';
import '../../models/ghe.dart';

class SeatWidget extends StatelessWidget {
  final Ghe seatData;
  final ValueNotifier<Set<String>> selectedSeatsNotifier;
  final VoidCallback onTap;

  const SeatWidget({
    Key? key,
    required this.seatData,
    required this.selectedSeatsNotifier,
    required this.onTap,
  }) : super(key: key);

  Color _getColor(bool isSelected) {
    if (seatData.daDat) return const Color(0xFF3F3F4E); // Đã bán
    if (isSelected) return const Color(0xFFFF6B6B); // Đang chọn

    switch (seatData.phanLoai) {
      case 'VIP':
        return const Color(0xFF6C5CE7);
      case 'COUPLE':
        return const Color(0xFFE84393);
      default:
        return const Color(0xFF485460); // STANDARD
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = seatData.phanLoai == 'COUPLE' ? 70 : 34;
    final double height = 34;

    return GestureDetector(
      onTap: onTap,
      child: ValueListenableBuilder<Set<String>>(
        valueListenable: selectedSeatsNotifier,
        builder: (context, selectedSeats, child) {
          final isSelected = selectedSeats.contains(seatData.ma);

          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: _getColor(isSelected),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? const Color(0xFFFF9F43) : Colors.transparent,
                width: isSelected ? 2 : 0,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                          color: const Color(0xFFFF6B6B).withOpacity(0.5),
                          blurRadius: 8,
                          spreadRadius: 1)
                    ]
                  : [],
            ),
            alignment: Alignment.center,
            child: seatData.phanLoai == 'COUPLE'
                ? const Icon(Icons.favorite, size: 14, color: Colors.white30)
                : Text(
                    seatData.ten,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: seatData.daDat ? Colors.white24 : Colors.white70,
                    ),
                  ),
          );
        },
      ),
    );
  }
}

class BookingController {
  List<Ghe> allSeats = [];

  final ValueNotifier<Set<String>> selectedSeatIdsNotifier = ValueNotifier({});

  void setSeats(List<Ghe> seats) {
    allSeats = seats;
  }

  void toggleSeat(String seatId) {
    try {
      final seat = allSeats.firstWhere((s) => s.ma == seatId);

      if (seat.daDat) return; // Ghế đã bán

      final currentSeats = Set<String>.from(selectedSeatIdsNotifier.value);

      if (currentSeats.contains(seatId)) {
        currentSeats.remove(seatId);
      } else {
        if (currentSeats.length >= 8) {
          return;
        }
        currentSeats.add(seatId);
      }

      // Force rebuild
      selectedSeatIdsNotifier.value = {...currentSeats};
    } catch (e) {
      debugPrint("Lỗi tìm ghế: $e");
    }
  }

  double calculateTotal() {
    double total = 0;
    for (var seatId in selectedSeatIdsNotifier.value) {
      try {
        var seat = allSeats.firstWhere((s) => s.ma == seatId);
        total += seat.gia;
      } catch (e) {}
    }
    return total;
  }

  void dispose() {
    selectedSeatIdsNotifier.dispose();
  }
}

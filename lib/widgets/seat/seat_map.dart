import 'package:flutter/material.dart';
import '../../models/seat.dart';
import '../../theme/colors.dart';

class SeatMapWidget extends StatefulWidget {
  final List<String> bookedIds;
  final ValueChanged<List<String>>? onSelectionChanged;

  const SeatMapWidget({
    super.key,
    this.bookedIds = const [],
    this.onSelectionChanged,
  });

  @override
  State<SeatMapWidget> createState() => _SeatMapWidgetState();
}

class _SeatMapWidgetState extends State<SeatMapWidget> {
  late List<List<Seat>> seatRows;

  final double seatSize = 40.0;
  final double seatGap = 10.0;
  final double rowGap = 10.0;

  @override
  void initState() {
    super.initState();
    _generateSeats();
  }

  void _generateSeats() {
    seatRows = [];
    for (int r = 0; r < 6; r++) {
      List<Seat> row = [];
      int cols = r == 5 ? 4 : 8; // hàng cuối chỉ 4 ghế đôi
      for (int c = 1; c <= cols; c++) {
        String id = "${String.fromCharCode(65 + r)}$c";
        SeatType type = SeatType.normal;
        if (r == 3 || r == 4) type = SeatType.vip;
        if (r == 5) type = SeatType.couple;

        row.add(Seat(
          id: id,
          type: type,
          isBooked: widget.bookedIds.contains(id),
        ));
      }
      seatRows.add(row);
    }
  }

  void _onSeatTap(Seat seat) {
    if (seat.isBooked) return;

    setState(() {
      seat.isSelected = !seat.isSelected;
    });

    final selectedIds = seatRows
        .expand((row) => row)
        .where((s) => s.isSelected)
        .map((s) => s.id)
        .toList();

    widget.onSelectionChanged?.call(selectedIds);
  }

  Color _getSeatColor(Seat seat) {
    if (seat.isBooked) return AppColors.disabled;
    if (seat.isSelected) return AppColors.red;

    switch (seat.type) {
      case SeatType.vip:
        return AppColors.seatVip;
      case SeatType.couple:
        return AppColors.seatCouple;
      default:
        return AppColors.seatNormal;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Chú thích
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              _legendBox(AppColors.bgElevated, "Thường"),
              _legendBox(AppColors.seatVip, "VIP"),
              _legendBox(AppColors.seatCouple, "Ghế đôi"),
              _legendBox(AppColors.seatSelected, "Đang chọn"),
              _legendBox(AppColors.seatBooked, "Đã đặt"),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Sơ đồ ghế
        ...seatRows.map((row) {
          return Padding(
            padding: EdgeInsets.only(bottom: rowGap),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: row.map((seat) {
                final width = seat.type == SeatType.couple
                    ? seatSize * 2 + seatGap
                    : seatSize;
                return Padding(
                  padding: EdgeInsets.only(right: seatGap),
                  child: GestureDetector(
                    onTap: () => _onSeatTap(seat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      alignment: Alignment.center,
                      width: width,
                      height: seatSize,
                      decoration: BoxDecoration(
                        color: _getSeatColor(seat),
                        borderRadius: BorderRadius.circular(6),
                        border: seat.isSelected
                            ? Border.all(color: AppColors.seatSelected, width: 2)
                            : null,
                        boxShadow: seat.isBooked
                            ? null
                            : [
                                BoxShadow(
                                  color: _getSeatColor(seat).withOpacity(0.3),
                                  blurRadius: seat.isSelected ? 6 : 2,
                                  offset: const Offset(0, 2),
                                )
                              ],
                      ),
                      child: seat.isBooked
                          ? const Icon(Icons.close,
                              color: AppColors.textMuted, size: 18)
                          : Text(
                              seat.id,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }),
      ],
    );
  }

  Widget _legendBox(Color color, String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Row(
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 6),
          Text(text,
              style:
                  const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }
}

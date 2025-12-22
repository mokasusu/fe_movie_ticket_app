import 'package:flutter/material.dart';
import '../../theme/colors.dart';

const List<String> _WEEKDAYS_SHORT = ["CN", "T2", "T3", "T4", "T5", "T6", "T7"];

class MovieDatePicker extends StatefulWidget {
  final DateTime currentDate;
  final Function(DateTime) onDateSelected;

  const MovieDatePicker({
    super.key,
    required this.currentDate,
    required this.onDateSelected,
  });

  @override
  State<MovieDatePicker> createState() => _MovieDatePickerState();
}

class _MovieDatePickerState extends State<MovieDatePicker> {
  late final List<DateTime> next14Days;

  @override
  void initState() {
    super.initState();
    // Tạo danh sách 14 ngày tới một lần duy nhất khi init
    next14Days = List.generate(
      14,
      (i) => DateTime.now().add(Duration(days: i)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: AppColors.bgSecondary,
      height: 90, // Chiều cao cố định cho khu vực chọn ngày
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: next14Days.length,
        separatorBuilder: (ctx, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final date = next14Days[index];
          
          // So sánh ngày được chọn (chỉ so sánh ngày/tháng/năm)
          final isSelected = widget.currentDate.year == date.year &&
              widget.currentDate.month == date.month &&
              widget.currentDate.day == date.day;

          return GestureDetector(
            onTap: () {
              // Nếu chưa chọn thì mới gọi hàm callback
              if (!isSelected) {
                widget.onDateSelected(date);
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 54,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.red
                    : Colors.grey.shade800,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.red : Colors.grey.shade800,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _WEEKDAYS_SHORT[date.weekday == 7 ? 0 : date.weekday],
                    style: TextStyle(
                      color: isSelected ? AppColors.gold: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${date.day}/${date.month}",
                    style: TextStyle(
                      color: isSelected ? AppColors.gold : AppColors.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
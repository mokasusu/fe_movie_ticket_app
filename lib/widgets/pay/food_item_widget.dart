// widgets/pay/food_item_widget.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/colors.dart';
import '../../models/food.dart';

class FoodItemWidget extends StatelessWidget {
  final FoodItem food;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const FoodItemWidget({
    super.key,
    required this.food,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(12),
        border: quantity > 0
            ? Border.all(color: AppColors.gold, width: 1)
            : Border.all(color: Colors.transparent),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(color: AppColors.bgSecondary, shape: BoxShape.circle),
            child: const Icon(Icons.fastfood_rounded, color: AppColors.gold, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(food.tenFoodItem ?? "Món ăn",
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                Text(currencyFormat.format(food.gia ?? 0),
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
              ],
            ),
          ),
          _buildBtn(Icons.remove, onRemove, isActive: quantity > 0),
          SizedBox(width: 30, child: Text("$quantity", textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold))),
          _buildBtn(Icons.add, onAdd, isActive: true),
        ],
      ),
    );
  }

  Widget _buildBtn(IconData icon, VoidCallback onTap, {required bool isActive}) {
    return InkWell(
      onTap: isActive ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: isActive ? AppColors.gold : AppColors.bgSecondary, shape: BoxShape.circle),
        child: Icon(icon, size: 16, color: isActive ? Colors.black : AppColors.textMuted),
      ),
    );
  }
}
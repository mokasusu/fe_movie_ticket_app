import 'package:flutter/material.dart';
import '../../theme/colors.dart';

typedef OnSearchChanged = void Function(String query);

class CinemaSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final OnSearchChanged? onChanged;
  final String hint;

  const CinemaSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
    this.hint = 'Tìm tên rạp...',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: AppColors.textPrimary),
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.textMuted),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.textMuted,
          ),
          filled: true,
          fillColor: AppColors.bgSecondary,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        ),
      ),
    );
  }
}

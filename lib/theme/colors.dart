import 'package:flutter/material.dart';

class AppColors {
  // ===== BACKGROUND =====
  static const Color bgPrimary = Color(0xFF0D0D0F);
  static const Color bgSecondary = Color(0xFF16161A);
  static const Color bgElevated = Color(0xFF1F1F25);

  // ===== ACCENT / ĐIỂM NHẤN =====
  static const Color gold = Color(0xFFE4B15E);
  static const Color red = Color(0xFFC62828);
  static const Color neonBlue = Color(0xFF4FC3F7);

  // ===== TEXT =====
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B5);
  static const Color textMuted = Color(0xFF7A7A80);
  static const Color disabled = Color(0xFF4A4A4F);

  // ===== SEAT MAP COLORS =====
  static const Color seatNormal = bgElevated;
  static const Color seatVip = gold;
  static const Color seatCouple = Color(0xFFFF80AB);
  static const Color seatSelected = red;
  static const Color seatBooked = disabled;
}

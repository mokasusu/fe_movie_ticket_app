import 'package:flutter/material.dart';

class LegendWidget extends StatelessWidget {
  const LegendWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16, runSpacing: 8, alignment: WrapAlignment.center,
      children: const [
        _LegendItem(color: Color(0xFF485460), label: 'Thường'),
        _LegendItem(color: Color(0xFF6C5CE7), label: 'VIP'),
        _LegendItem(color: Color(0xFFE84393), label: 'Đôi'),
        _LegendItem(color: Color(0xFF3F3F4E), label: 'Đã bán'),
        _LegendItem(color: Color(0xFFFF6B6B), label: 'Đang chọn'),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color; final String label;
  const _LegendItem({required this.color, required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 16, height: 16, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
      const SizedBox(width: 6), Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
    ]);
  }
}
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/voucher.dart';
import '../../theme/colors.dart';
import '../../screens/voucher/voucher_list_screen.dart';

class VoucherSelector extends StatelessWidget {
  final Voucher? selectedVoucher;
  final Function(Voucher) onSelected;
  final VoidCallback onRemoved;

  const VoucherSelector({
    super.key,
    this.selectedVoucher,
    required this.onSelected,
    required this.onRemoved,
  });

  // Hàm xử lý mở màn hình danh sách
  void _openVoucherList(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VoucherListScreen(
          showBackButton: true,
          currentVoucher: selectedVoucher,
        ),
      ),
    );

    if (result != null && result is Voucher) {
      onSelected(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    // LOGIC TỰ ĐỘNG CHUYỂN ĐỔI GIAO DIỆN
    if (selectedVoucher == null) {
      return _buildInputState(context);
    } else {
      return _buildSelectedState(context, selectedVoucher!);
    }
  }

  // === TRẠNG THÁI 1: CHƯA CHỌN (Giao diện nhập) ===
  Widget _buildInputState(BuildContext context) {
    return InkWell(
      onTap: () => _openVoucherList(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.bgPrimary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.confirmation_number_outlined,
              color: AppColors.gold,
            ),
            const SizedBox(width: 12),
            const Text(
              "Chọn voucher của bạn",
              style: TextStyle(color: Colors.grey),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // === TRẠNG THÁI 2: ĐÃ CHỌN (Giao diện hiển thị vé) ===
  Widget _buildSelectedState(BuildContext context, Voucher voucher) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    String discountDisplay;
    if (voucher.loaiGiamGia == DiscountType.PERCENTAGE) {
      discountDisplay = 'Giảm ${voucher.giaTriGiam.toStringAsFixed(0)}%';
    } else {
      discountDisplay = 'Giảm ${currencyFormat.format(voucher.giaTriGiam)}';
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.gold.withOpacity(0.18), // Nền vàng nhạt khi đã chọn
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gold), // Viền vàng
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon Check
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: AppColors.gold, size: 20),
          ),
          const SizedBox(width: 12),

          // Thông tin
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  voucher.maGiamGia,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  discountDisplay,
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Nút Xóa
          IconButton(
            onPressed: onRemoved,
            icon: const Icon(Icons.close, color: Colors.red),
            tooltip: "Gỡ voucher",
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../models/voucher.dart';
import '../../theme/colors.dart';

class VoucherListScreen extends StatelessWidget {
  final List<Voucher> vouchers;
  final String title;
  final bool showHistoryButton;

  const VoucherListScreen({
    super.key,
    required this.vouchers,
    required this.title,
    this.showHistoryButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.bgSecondary,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (showHistoryButton)
            IconButton(
              icon: const Icon(Icons.history),
              tooltip: 'Lịch sử voucher',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VoucherListScreen(
                      vouchers: vouchers,
                      title: "Voucher đã dùng",
                      showHistoryButton: false,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: vouchers.length,
        itemBuilder: (context, index) {
          final v = vouchers[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.bgSecondary,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: v.backgroundColor.withOpacity(0.6),
                width: 1.2,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ICON
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: v.backgroundColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.card_giftcard,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),

                /// INFO
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        v.TenVoucher,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        v.MoTa,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Row(
                        children: const [
                          Icon(Icons.discount,
                              size: 18, color: AppColors.gold),
                          SizedBox(width: 6),
                        ],
                      ),
                      Text(
                        "Giảm: ${v.GiaGiam}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),

                      const SizedBox(height: 6),
                      Row(
                        children: const [
                          Icon(Icons.calendar_today,
                              size: 18, color: AppColors.neonBlue),
                          SizedBox(width: 6),
                        ],
                      ),
                      Text(
                        "HSD: ${v.NgayHet}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),

                      const SizedBox(height: 6),
                      Text(
                        "Số lượng: ${v.SoLuong}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.gold,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 12),
                        decoration: BoxDecoration(
                          color: v.TrangThai == "Hoạt động"
                              ? AppColors.gold.withOpacity(0.15)
                              : AppColors.disabled.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          v.TrangThai == "Hoạt động"
                              ? "Voucher khả dụng"
                              : "Voucher đã dùng",
                          style: TextStyle(
                            color: v.TrangThai == "Hoạt động"
                                ? AppColors.gold
                                : AppColors.textMuted,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

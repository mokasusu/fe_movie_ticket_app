import 'package:flutter/material.dart';
import '/models/voucher.dart';
import '../../screens/voucher/voucher_list_screen.dart';
import '../../theme/colors.dart';

class VoucherSlider extends StatelessWidget {
  final List<Voucher> vouchers;

  const VoucherSlider({super.key, required this.vouchers});

  void _handleSeeAllClick(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VoucherListScreen(
          vouchers: vouchers,
          title: "Tất cả Voucher",
          showHistoryButton: true,
        ),
      ),
    );
  }

  void _handleSaveVoucher(String maVoucher) {
    print('Lưu voucher: $maVoucher');
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final desiredHeight = (screenHeight / 6) / 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Voucher',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () => _handleSeeAllClick(context),
                child: const Text(
                  'Xem tất cả >',
                  style: TextStyle(
                    color: AppColors.neonBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(
          height: desiredHeight + 10,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: vouchers.length,
            itemBuilder: (context, index) {
              final voucher = vouchers[index];

              return Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? 16.0 : 8.0,
                  right: index == vouchers.length - 1 ? 16.0 : 8.0,
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Container(
                    width: 180.0,
                    decoration: BoxDecoration(
                      color: voucher.backgroundColor.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: AppColors.textPrimary,
                        width: 2,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    child: Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              voucher.GiaGiam,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Mã: ${voucher.MaVoucher}',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        Positioned(
                          top: 0,
                          bottom: 0,
                          right: 0,
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () => _handleSaveVoucher(voucher.MaVoucher),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.red,
                                foregroundColor: AppColors.textPrimary,
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                elevation: 4.0,
                              ),
                              child: const Text(
                                'Lưu',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/voucher.dart';
import '../../theme/colors.dart';
import '../../services/api/voucher_service.dart';

class VoucherListScreen extends StatefulWidget {
  final bool showBackButton;
  final List<Voucher>? initialVouchers;

  const VoucherListScreen({
    super.key,
    this.initialVouchers,
    this.showBackButton = true,
  });

  @override
  State<VoucherListScreen> createState() => _VoucherListScreenState();
}

class _VoucherListScreenState extends State<VoucherListScreen> {
  // Đã xóa _codeController vì không còn dùng nhập mã
  List<Voucher> _vouchers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.initialVouchers != null) {
      _vouchers = widget.initialVouchers!;
      _isLoading = false;
    } else {
      _fetchVouchers();
    }
  }

  Future<void> _fetchVouchers() async {
    setState(() => _isLoading = true);
    try {
      _vouchers = await VoucherService.fetchVouchers();
    } catch (e) {
      _vouchers = []; // Xử lý lỗi an toàn
    }
    if (mounted) setState(() => _isLoading = false);
  }

  void _handleSelectVoucher(Voucher voucher) {
    if (voucher.trangThai != "Hoạt động") return;
    // Chỉ pop nếu có màn hình trước đó (tránh lỗi khi ở BottomNavBar)
    if (Navigator.canPop(context)) {
      Navigator.pop(context, voucher);
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableVouchers = _vouchers
        .where((v) => v.trangThai == true && !v.isExpired)
        .toList();
    final historyVouchers = _vouchers
        .where((v) => v.trangThai == false || v.isExpired)
        .toList();

    // Logic kiểm tra nút Back
    final bool canBack = widget.showBackButton && Navigator.canPop(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.bgPrimary,
        appBar: AppBar(
          title: const Text(
            "Kho Voucher",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          backgroundColor: AppColors.bgPrimary,
          elevation: 0,
          centerTitle: true,
          // Logic ẩn/hiện nút back
          leading: canBack ? const BackButton(color: Colors.black) : null,
          bottom: const TabBar(
            labelColor: AppColors.gold,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.gold,
            indicatorWeight: 3,
            tabs: [
              Tab(text: "Hiện hành"),
              Tab(text: "Lịch sử"),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.gold),
              )
            : TabBarView(
                children: [
                  // Tab 1: Hiện hành (Đã bỏ Input, chỉ còn List)
                  _buildVoucherList(
                    data: availableVouchers,
                    isHistory: false,
                    onTapItem: _handleSelectVoucher,
                  ),

                  // Tab 2: Lịch sử
                  _buildVoucherList(
                    data: historyVouchers,
                    isHistory: true,
                    onTapItem: (v) {}, // Lịch sử không cho chọn
                  ),
                ],
              ),
      ),
    );
  }

  // Widget hiển thị danh sách Voucher
  Widget _buildVoucherList({
    required List<Voucher> data,
    required bool isHistory,
    required Function(Voucher) onTapItem,
  }) {
    if (data.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isHistory ? Icons.history : Icons.local_activity_outlined,
              size: 60,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 12),
            Text(
              isHistory
                  ? "Chưa có lịch sử dùng mã"
                  : "Không có mã giảm giá nào",
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: data.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return VoucherItemCard(
          voucher: data[index],
          isHistoryMode: isHistory,
          onTap: () => onTapItem(data[index]),
        );
      },
    );
  }
}

// Widget thẻ Voucher riêng lẻ
class VoucherItemCard extends StatelessWidget {
  final Voucher voucher;
  final VoidCallback onTap;
  final bool isHistoryMode;

  const VoucherItemCard({
    super.key,
    required this.voucher,
    required this.onTap,
    this.isHistoryMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive =
        !isHistoryMode && voucher.trangThai == true && !voucher.isExpired;
    final numberFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    final dateFormat = DateFormat('dd/MM/yyyy');
    String formattedDate = voucher.ngayHetHan != null
        ? dateFormat.format(voucher.ngayHetHan!)
        : "Vô thời hạn";

    return InkWell(
      onTap: isActive ? onTap : null,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: isHistoryMode ? AppColors.bgElevated : AppColors.red,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive ? AppColors.red : AppColors.disabled,
            width: 1.5,
          ),
          boxShadow: [
            if (isActive)
              BoxShadow(
                color: AppColors.gold.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          children: [
            // Phần trái (Cuống vé)
            Container(
              width: 90,
              height: 100,
              decoration: BoxDecoration(
                color: isActive ? AppColors.gold : AppColors.disabled,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.card_giftcard, color: Colors.white, size: 28),
                  const SizedBox(height: 4),
                  Text(
                    isHistoryMode ? "HẾT HẠN" : "VOUCHER",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            // Phần phải (Thông tin)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      voucher.maGiamGia,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        decoration: isHistoryMode
                            ? TextDecoration.lineThrough
                            : null,
                        color: isHistoryMode
                            ? AppColors.textMuted
                            : AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Giảm: ${numberFormat.format(voucher.giaTriGiam)}",
                      style: TextStyle(
                        color: AppColors.gold,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "HSD: $formattedDate",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (isHistoryMode)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          voucher.isExpired ? "Đã hết hạn" : "Đã sử dụng",
                          style: const TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: AppColors.textMuted,
                          ),
                        ),
                      )
                    else
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            "Chọn dùng",
                            style: TextStyle(
                              color: AppColors.gold,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

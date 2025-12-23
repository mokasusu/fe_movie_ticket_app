import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/voucher.dart';
import '../../theme/colors.dart';
import '../../services/api/voucher_service.dart';

class VoucherListScreen extends StatefulWidget {
  final bool showBackButton;
  final List<Voucher>? initialVouchers;
  final Voucher? currentVoucher;

  const VoucherListScreen({
    super.key,
    this.initialVouchers,
    this.showBackButton = true,
    this.currentVoucher,
  });

  @override
  State<VoucherListScreen> createState() => _VoucherListScreenState();
}

class _VoucherListScreenState extends State<VoucherListScreen> {
  List<Voucher> _vouchers = [];
  bool _isLoading = true;

  // Biến lưu voucher đang được tick chọn tạm thời
  Voucher? _tempSelectedVoucher;

  @override
  void initState() {
    super.initState();
    // 1. Khởi tạo voucher đang chọn (nếu có)
    _tempSelectedVoucher = widget.currentVoucher;

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
      _vouchers = [];
    }
    if (mounted) setState(() => _isLoading = false);
  }

  // Logic khi bấm vào 1 dòng voucher
  void _handleItemTap(Voucher voucher) {
    if (voucher.trangThai != true || voucher.isExpired) return;

    setState(() {
      // Nếu bấm vào cái đang chọn -> Bỏ chọn
      // Bấm vào là chọn cái đó
      if (_tempSelectedVoucher?.maGiamGia == voucher.maGiamGia) {
        _tempSelectedVoucher = null;
      } else {
        _tempSelectedVoucher = voucher;
      }
    });
  }

  // Logic nút Xác nhận
  void _onConfirm() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context, _tempSelectedVoucher);
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
          leading: canBack
              ? IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.gold),
                  onPressed: () {
                    Navigator.maybePop(context);
                  },
                )
              : null,
          bottom: const TabBar(
            labelColor: AppColors.gold,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.gold,
            indicatorWeight: 3,
            tabs: [
              Tab(text: "Hiện hành"),
              Tab(text: "Hết hạn"),
            ],
          ),
        ),
        body: Column(
          children: [
            // PHẦN DANH SÁCH
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: AppColors.gold),
                    )
                  : TabBarView(
                      children: [
                        // Tab 1: Hiện hành
                        _buildVoucherList(
                          data: availableVouchers,
                          isHistory: false,
                        ),
                        // Tab 2: Lịch sử
                        _buildVoucherList(
                          data: historyVouchers,
                          isHistory: true,
                        ),
                      ],
                    ),
            ),

            // PHẦN NÚT ÁP DỤNG
            // Chỉ hiện nút này nếu có nút Back (luồng chọn voucher)
            if (widget.showBackButton)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.bgSecondary,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onConfirm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.gold,
                        foregroundColor: Colors.black, // Màu chữ
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Áp dụng",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoucherList({
    required List<Voucher> data,
    required bool isHistory,
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
              isHistory ? "Chưa có lịch sử" : "Không có mã giảm giá nào",
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
        final voucher = data[index];
        // Kiểm tra xem voucher này có đang được chọn không
        final isSelected = _tempSelectedVoucher?.maGiamGia == voucher.maGiamGia;

        return VoucherItemCard(
          voucher: voucher,
          isHistoryMode: isHistory,
          isSelected: isSelected, // Truyền trạng thái selected xuống
          onTap: () => _handleItemTap(voucher),
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
  final bool isSelected;

  const VoucherItemCard({
    super.key,
    required this.voucher,
    required this.onTap,
    this.isHistoryMode = false,
    this.isSelected = false,
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

    String discountText;
    if (voucher.loaiGiamGia == DiscountType.PERCENTAGE) {
      discountText = "Giảm: ${voucher.giaTriGiam.toStringAsFixed(0)}%";
    } else {
      discountText = "Giảm: ${numberFormat.format(voucher.giaTriGiam)}";
    }

    return InkWell(
      onTap: isActive ? onTap : null,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: isHistoryMode ? AppColors.bgElevated : Colors.blueGrey,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            // Logic viền: Nếu đang chọn -> Vàng đậm, Nếu không -> Xám/Đỏ nhạt
            color: isSelected
                ? AppColors.gold
                : (isActive ? AppColors.gold : AppColors.disabled),
            width: isSelected ? 2 : 1, // Viền dày hơn nếu chọn
          ),
          boxShadow: [
            if (isActive)
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
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
                // Logic màu nền cuống vé: Nếu chọn -> Vàng, Nếu không -> Đỏ/Xám
                color: isActive
                    ? (isSelected ? AppColors.gold : AppColors.red)
                    : AppColors.disabled,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isSelected ? Icons.check_circle : Icons.card_giftcard,
                    color: Colors.white,
                    size: 28,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isHistoryMode
                        ? "HẾT HẠN"
                        : (isSelected ? "ĐÃ CHỌN" : "VOUCHER"),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
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
                        ),
                        // Radio Button hiển thị trạng thái chọn
                        if (!isHistoryMode)
                          Icon(
                            isSelected
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            color: isSelected
                                ? AppColors.gold
                                : Colors.grey.shade400,
                            size: 20,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      discountText,
                      style: TextStyle(
                        color: isActive ? AppColors.gold : AppColors.textMuted,
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

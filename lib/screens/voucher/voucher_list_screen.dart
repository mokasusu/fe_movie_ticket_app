import 'package:flutter/material.dart';
import '../../models/voucher.dart';

class VoucherListScreen extends StatelessWidget {
  final List<Voucher> vouchers;
  final String title; // Tiêu đề AppBar
  final bool showHistoryButton; // Có hiện nút lịch sử không

  const VoucherListScreen({
    super.key,
    required this.vouchers,
    required this.title,
    this.showHistoryButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.indigo,
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
                // Chỉ mở màn hình voucher đã dùng
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VoucherListScreen(
                      vouchers: vouchers, // Thay bằng list voucher đã sử dụng
                      title: "Voucher đã dùng",
                      showHistoryButton: false, // Không hiện nút lịch sử nữa
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
              color: v.backgroundColor.withOpacity(0.25),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: v.backgroundColor, width: 1.5),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ICON VOUCHER
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

                // TEXT INFO
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        v.TenVoucher,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        v.MoTa,
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.discount, size: 18, color: Colors.red),
                          const SizedBox(width: 6),
                          Text("Giảm: ${v.GiaGiam}", style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 18, color: Colors.blue),
                          const SizedBox(width: 6),
                          Text("HSD: ${v.NgayHet}", style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Số lượng: ${v.SoLuong}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                        decoration: BoxDecoration(
                          color: v.TrangThai == "Hoạt động"
                              ? Colors.green.withOpacity(0.15)
                              : Colors.grey.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          v.TrangThai == "Hoạt động" ? "Voucher khả dụng" : "Voucher đã dùng",
                          style: TextStyle(
                            color: v.TrangThai == "Hoạt động" ? Colors.green : Colors.grey,
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

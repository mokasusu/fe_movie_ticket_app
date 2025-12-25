import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';
import '../../models/invoice_response.dart';
import '../../theme/colors.dart';

// Hàm hiển thị popup chi tiết hóa đơn
void showInvoiceDetailPopup(BuildContext context, InvoiceResponse invoice) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          alignment: Alignment.center,

          child: Material(
            color: Colors.transparent,
            child: InvoiceReceiptWidget(invoice: invoice),
          ),
        ),
      );
    },
  );
}

//
class InvoiceReceiptWidget extends StatelessWidget {
  final InvoiceResponse invoice;

  const InvoiceReceiptWidget({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Stack(
      children: [
        ClipPath(
          clipper: TicketClipper(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: 0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Center(
                      child: Column(
                        children: [
                          const Text(
                            "CINEMODE",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
                          ),
                          const Text(
                            "Đưa mã QR cho nhân viên để nhận vé",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 20),
                          QrImageView(
                            data: invoice.maHoaDon.toString(),
                            version: QrVersions.auto,
                            size: 140.0,
                            backgroundColor: Colors.white,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "#${invoice.maHoaDon}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const DashedLine(),
                    const SizedBox(height: 20),

                    // --- THÔNG TIN VÉ ---
                    _buildRow("Khách hàng", invoice.userName ?? ""),
                    _buildRow(
                      "Ngày đặt",
                      invoice.ngayTao != null
                          ? dateFormat.format(invoice.ngayTao!)
                          : "N/A",
                    ),
                    // _buildRow("Gmail", invoice.userEmail ?? ""),
                    const SizedBox(height: 10),

                    // --- THÔNG TIN SUẤT CHIẾU ---
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Thông tin suất chiếu:",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: Text(
                              invoice.tenPhim ?? "Vé xem phim",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Rạp: ${invoice.tenRap.isNotEmpty ? invoice.tenRap : 'Không rõ rạp'}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Phòng: ${invoice.tenPhong.isNotEmpty ? invoice.tenPhong : 'Không rõ phòng'}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Giờ chiếu: ${invoice.tgBatDau != null ? dateFormat.format(invoice.tgBatDau!) : 'N/A'}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),

                    // --- DANH SÁCH GHẾ ---
                    if (invoice.gheList.isNotEmpty) ...[
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Ghế:",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      ...invoice.gheList.map(
                        (ghe) => _buildRow(
                          "${ghe.maSeatType} (${ghe.tenLoaiGhe})",
                          currencyFormat.format(ghe.gia ?? 0),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],

                    // --- DANH SÁCH ĐỒ ĂN ---
                    if (invoice.doAnList.isNotEmpty) ...[
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Đồ ăn:",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      ...invoice.doAnList.map(
                        (food) => _buildRow(
                          "${food.tenDoAn} (x${food.soLuong})",
                          currencyFormat.format(food.thanhTien ?? 0),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],

                    const SizedBox(height: 10),
                    const DashedLine(),
                    const SizedBox(height: 10),

                    // --- TỔNG TIỀN ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Tạm tính",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          currencyFormat.format(invoice.tongTienTruocGiam ?? 0),
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),

                    if ((invoice.soTienGiam ?? 0) > 0)
                      _buildRow(
                        "Giảm giá",
                        "-${currencyFormat.format(invoice.soTienGiam)}",
                        isDiscount: true,
                      ),

                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "TỔNG CỘNG",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          currencyFormat.format(invoice.tongTienSauGiam ?? 0),
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),
                    const Center(
                      child: Text(
                        "Cảm ơn quý khách!",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // --- NÚT ĐÓNG ---
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRow(String label, String value, {bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDiscount ? AppColors.gold : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

// --- 3. WIDGET VẼ ĐƯỜNG KẺ ĐỨT (Dashed Line) ---
class DashedLine extends StatelessWidget {
  const DashedLine({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 6.0;
        final dashHeight = 1.0;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.black26),
              ),
            );
          }),
        );
      },
    );
  }
}

// --- 4. CLIPPER CẮT RĂNG CƯA (Zigzag Edge) ---
class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height);

    double x = 0;
    double y = size.height;
    double yControlPoint = size.height - 15; // Độ sâu của răng cưa
    double increment = size.width / 20; // Số lượng răng cưa

    while (x < size.width) {
      path.lineTo(x + increment / 2, yControlPoint);
      path.lineTo(x + increment, y);
      x += increment;
    }

    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => false;
}

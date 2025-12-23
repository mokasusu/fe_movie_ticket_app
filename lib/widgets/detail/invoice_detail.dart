import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';
import '../../models/invoice_response.dart';
import '../../theme/colors.dart';

// --- 1. HÀM GỌI POPUP (Helper Function) ---
void showInvoiceDetailPopup(BuildContext context, InvoiceResponse invoice) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.transparent,
    builder: (context) => Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Material(
          color: Colors.transparent,
          child: InvoiceReceiptWidget(invoice: invoice),
        ),
      ),
    ),
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

    return ClipPath(
      clipper: TicketClipper(),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 40),
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // --- HEADER ---
              const SizedBox(height: 8),
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
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(height: 20),

              // --- QR CODE ---
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
              const SizedBox(height: 10),

              // --- THÔNG TIN SUẤT CHIẾU ---
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Thông tin suất chiếu:",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      invoice.tenSuatChieu ?? "Vé xem phim",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13),
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
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13),
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
              _buildRow(
                "Giảm giá",
                currencyFormat.format(invoice.tongTienTruocGiam ?? 0),
              ),
              if ((invoice.soTienGiam ?? 0) > 0)
                _buildRow(
                  "Voucher",
                  "-${currencyFormat.format(invoice.soTienGiam)}",
                  isDiscount: true,
                ),

              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "TỔNG CỘNG",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 18),
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
              const Text(
                "Cảm ơn quý khách!",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.black,
                ),
              ),
              const Text(
                "Đưa hóa đơn cho nhân viên.",
                style: TextStyle(fontSize: 10, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
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
    double increment = size.width / 20; // Số lượng răng cưa (càng lớn càng mịn)

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

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/colors.dart';
import '../../models/film_model.dart';
import '../../models/food.dart';
import '../../services/api/food_service.dart';
import '../../models/cinema.dart';
import '../../models/showtime.dart';
import '../../models/voucher.dart';
import '../../services/api/invoice_service.dart';
import '../../models/invoice_request.dart';
import '../../models/user.dart';
import '../../services/api/user_service.dart';
import '../../utils/utils.dart';

import '../../widgets/appBar/pay_appbar.dart';
import '../../widgets/pay/info_ticket.dart';
import '../../widgets/pay/food_item_widget.dart';
import '../../widgets/pay/voucher_selector.dart';
import '../../widgets/pay/qr_dialog.dart';
import '../../widgets/pay/success_dialog.dart';
import '../home/home_screen.dart';
import '../userInfomation/invoice_screen.dart';

class PayScreen extends StatefulWidget {
  final FilmResponse movie;
  final Cinema cinema;
  final Showtime showtime;
  final List<String> seatNumbers;
  final int totalSeat;

  const PayScreen({
    super.key,
    required this.movie,
    required this.cinema,
    required this.showtime,
    required this.seatNumbers,
    required this.totalSeat,
  });

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  Future<void> _handlePaymentConfirm() async {
    // 1. Lấy thông tin user hiện tại
    final user = await UserService.getMyInfo();
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không lấy được thông tin người dùng!')),
      );
      return;
    }

    // 2. Lấy danh sách đồ ăn đã chọn (id và số lượng)
    final List<FoodRequest> doAnList = _foodQuantities.entries
        .where((e) => e.value > 0)
        .map((e) => FoodRequest(foodId: e.key, soLuong: e.value))
        .toList();

    // 3. Tạo request hóa đơn từ dữ liệu hiện tại
    final invoiceRequest = InvoiceRequest(
      maUser: user.id,
      maSuatChieu: widget.showtime.id,
      voucherId: _selectedVoucher?.maGiamGia,
      gheList: widget.seatNumbers
          .map((seat) => SeatRequest(maSeatType: seat))
          .toList(),
      doAnList: doAnList,
    );

    // 4. Gọi API tạo hóa đơn
    final response = await InvoiceService.createInvoice(invoiceRequest);
    if (response != null) {
      // Thành công: Hiển thị dialog thành công
      showDialog(
        context: context,
        builder: (context) => PaymentSuccessDialog(
          onViewTicket: () {
            Navigator.pop(context); // Đóng dialog trước khi điều hướng
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => InvoiceHistoryScreen(userId: user.id ?? ""),
              ),
            );
          },
          onBackToHome: () {
            // Đóng dialog và chuyển về HomeScreen
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const HomeScreen()),
              (route) => false,
            );
          },
        ),
      );
    } else {
      // Thất bại: Có thể show snackbar hoặc dialog lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thanh toán thất bại, vui lòng thử lại!')),
      );
    }
  }

  // List of available foods fetched from API
  List<FoodItem> _availableFoods = [];
  bool _isLoadingFoods = true;

  // Currently selected voucher
  Voucher? _selectedVoucher;

  // Shopping cart: Key is Food ID, Value is quantity
  final Map<String, int> _foodQuantities = {};

  @override
  void initState() {
    super.initState();
    _fetchFoods();
  }

  Future<void> _fetchFoods() async {
    setState(() {
      _isLoadingFoods = true;
    });
    try {
      final foods = await FoodService.fetchFoods();
      // Đảm bảo foods là List<FoodItem>
      setState(() {
        _availableFoods = foods.cast<FoodItem>();
        _isLoadingFoods = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingFoods = false;
      });
    }
  }

  // Calculate total food price using PriceCalculator
  double get _totalFoodPrice {
    // Tính tổng tiền các món đã chọn
    List<FoodItem> selectedFoods = _availableFoods.map((food) {
      int qty = _foodQuantities[food.maFoodItem ?? ""] ?? 0;
      return FoodItem(
        maFoodItem: food.maFoodItem,
        tenFoodItem: food.tenFoodItem,
        gia: food.gia,
        soLuong: qty,
      );
    }).toList();
    return PriceCalculator.calcFoodTotal(selectedFoods);
  }

  // Handle continue action
  void _onContinue() {
    // Hiển thị popup QRDialog khi nhấn nút thanh toán
    showDialog(
      context: context,
      builder: (context) => PaymentQRDialog(
        amount: PriceCalculator.calculateFinalTotal(
          subTotal: PriceCalculator.calcSubTotal(
            seatTotal: widget.totalSeat.toDouble(),
            foodTotal: _totalFoodPrice,
          ),
          discountAmount: PriceCalculator.calculateDiscountAmount(
            subTotal: PriceCalculator.calcSubTotal(
              seatTotal: widget.totalSeat.toDouble(),
              foodTotal: _totalFoodPrice,
            ),
            voucher: _selectedVoucher,
          ),
        ),
        content: "Thanh toán vé xem phim",
        onPaymentSuccess: () {
          // Khi xác nhận đã thanh toán, gửi request lên BE và show dialog thành công
          _handlePaymentConfirm();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    // 1. Calculate Seat Total
    final double seatTotal = widget.totalSeat.toDouble();

    // 2. Calculate Food Total
    final double foodTotal = _totalFoodPrice;

    // 3. Calculate Subtotal
    final double subTotal = PriceCalculator.calcSubTotal(
      seatTotal: seatTotal,
      foodTotal: foodTotal,
    );

    // 4. Calculate Discount Amount
    final double discountAmount = PriceCalculator.calculateDiscountAmount(
      subTotal: subTotal,
      voucher: _selectedVoucher,
    );

    // 5. Calculate Final Total
    final double grandTotal = PriceCalculator.calculateFinalTotal(
      subTotal: subTotal,
      discountAmount: discountAmount,
    );

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: const PayAppBar(),
      body: _isLoadingFoods
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.gold),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Ticket Information
                  InfoTicket(
                    movie: widget.movie,
                    cinema: widget.cinema,
                    showtime: widget.showtime,
                    seatNumbers: widget.seatNumbers,
                    totalSeat: widget.totalSeat,
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: AppColors.bgElevated, thickness: 8),
                  const SizedBox(height: 20),

                  // 2. Tiêu đề lựa chọn thức ăn
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: const [
                        Icon(Icons.restaurant_menu, color: AppColors.gold),
                        SizedBox(width: 10),
                        Text(
                          "Combo & Bắp nước",
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),

                  // danh sách đồ ăn
                  ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _availableFoods.length,
                    itemBuilder: (context, index) {
                      final food = _availableFoods[index];
                      final qty = _foodQuantities[food.maFoodItem ?? ""] ?? 0;
                      return FoodItemWidget(
                        food: food,
                        quantity: qty,
                        onAdd: () => setState(() {
                          final id = food.maFoodItem ?? "";
                          _foodQuantities[id] = (_foodQuantities[id] ?? 0) + 1;
                        }),
                        onRemove: () {
                          final id = food.maFoodItem ?? "";
                          if ((_foodQuantities[id] ?? 0) > 0) {
                            setState(() {
                              _foodQuantities[id] =
                                  (_foodQuantities[id] ?? 0) - 1;
                            });
                          }
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                  const Divider(color: AppColors.bgElevated, thickness: 8),
                  const SizedBox(height: 20),

                  //chọn voucher
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.discount, color: AppColors.gold),
                            SizedBox(width: 10),
                            Text(
                              "Ưu đãi",
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        VoucherSelector(
                          selectedVoucher: _selectedVoucher,
                          onSelected: (voucher) {
                            setState(() {
                              _selectedVoucher = voucher;
                            });
                          },
                          onRemoved: () {
                            setState(() {
                              _selectedVoucher = null;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  // Tổng tiền & nút thanh toán cuối cùng trong nội dung cuộn
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Tổng tiền ghế
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Tổng giá ghế:",
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              currencyFormat.format(seatTotal),
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        // Tổng tiền đồ ăn
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Tổng đồ ăn:",
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              currencyFormat.format(foodTotal),
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        // Tổng tạm tính
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Tạm tính:",
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              currencyFormat.format(subTotal),
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        // Giảm giá (nếu có)
                        if (discountAmount > 0) ...[
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Giảm giá:",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '-${currencyFormat.format(discountAmount)}',
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 10),
                        // Tổng thanh toán cuối cùng
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Tổng thanh toán:",
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              currencyFormat.format(grandTotal),
                              style: const TextStyle(
                                color: AppColors.gold,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        // Nút thanh toán
                        ElevatedButton(
                          onPressed: _onContinue,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.gold,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 5,
                          ),
                          child: const Text(
                            "Thanh toán",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/colors.dart';
import '../../models/film_model.dart';
import '../../models/food.dart';
import '../../models/cinema.dart';
import '../../models/showtime.dart';

import '../../widgets/appBar/pay_appbar.dart';
import '../../widgets/pay/info_ticket.dart';
import '../../widgets/pay/food_item_widget.dart'; // Import widget vừa tạo ở trên

class PayScreen extends StatefulWidget {
  final FilmResponse movie;
  final Cinema cinema;
  final Showtime showtime;
  final List<String> seatNumbers;
  final int totalSeat; // Tổng tiền ghế (đã tính ở màn trước)

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
  // 1. Dữ liệu Food mẫu (Thực tế nên gọi API lấy về)
  final List<Food> _availableFoods = [
    Food(foodId: "1", tenDoAn: "Bắp Ngọt Lớn", gia: 55000),
    Food(foodId: "2", tenDoAn: "Coca Cola Vừa", gia: 32000),
    Food(foodId: "3", tenDoAn: "Combo Solo (1 Bắp + 1 Nước)", gia: 79000),
  ];

  // 2. Giỏ hàng: Key là ID món ăn, Value là số lượng
  final Map<String, int> _foodQuantities = {};

  // Tính tổng tiền đồ ăn
  double get _totalFoodPrice {
    double total = 0;
    for (var food in _availableFoods) {
      int qty = _foodQuantities[food.foodId] ?? 0;
      if (qty > 0) {
        total += (food.gia ?? 0) * qty;
      }
    }
    return total;
  }

  // Xử lý chuyển màn hình
  void _onContinue() {
    // Lọc ra danh sách các món đã chọn để gửi đi
    List<Food> selectedFoods = [];
    _foodQuantities.forEach((id, qty) {
      if (qty > 0) {
        // Tìm món ăn gốc
        Food originalFood = _availableFoods.firstWhere((f) => f.foodId == id);
        // Tạo object mới với số lượng đã chọn
        selectedFoods.add(Food(
          foodId: originalFood.foodId,
          tenDoAn: originalFood.tenDoAn,
          gia: originalFood.gia,
          soLuong: qty, // Lưu ý: gán số lượng user chọn vào đây
          thanhTien: (originalFood.gia ?? 0) * qty
        ));
      }
    });

    double finalTotal = widget.totalSeat + _totalFoodPrice;

    // TODO: Navigate sang màn Voucher
    // Navigator.push(context, MaterialPageRoute(builder: (context) => VoucherScreen(...)));
    
    print("Tổng tiền: $finalTotal");
    print("Đồ ăn đã chọn: ${selectedFoods.map((e) => "${e.tenDoAn} x${e.soLuong}").toList()}");
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    final double grandTotal = widget.totalSeat + _totalFoodPrice;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: const PayAppBar(),
      body: Column(
        children: [
          // Phần nội dung cuộn được
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Thông tin vé (Widget cũ của bạn)
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

                  // 2. Tiêu đề chọn món
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

                  // 3. Danh sách món ăn
                  ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    shrinkWrap: true, // Quan trọng để nằm trong SingleChildScrollView
                    physics: const NeverScrollableScrollPhysics(), // Tắt cuộn riêng của list
                    itemCount: _availableFoods.length,
                    itemBuilder: (context, index) {
                      final food = _availableFoods[index];
                      final qty = _foodQuantities[food.foodId] ?? 0;

                      return FoodItemWidget(
                        food: food,
                        quantity: qty,
                        onAdd: () => setState(() {
                          _foodQuantities[food.foodId ?? ""] = qty + 1;
                        }),
                        onRemove: () {
                          if (qty > 0) {
                            setState(() {
                              _foodQuantities[food.foodId ?? ""] = qty - 1;
                            });
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // 4. Bottom Bar: Tổng tiền & Nút Tiếp tục
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppColors.bgElevated,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(color: Colors.black54, blurRadius: 10, offset: Offset(0, -5))
              ],
            ),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Tổng thanh toán", style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(
                        currencyFormat.format(grandTotal),
                        style: const TextStyle(
                          color: AppColors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: _onContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 5,
                    ),
                    child: const Text(
                      "Tiếp tục",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
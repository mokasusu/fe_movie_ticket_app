import 'package:home/models/food.dart';

import '../../models/voucher.dart';
import '../../models/seat.dart';
import '../../models/invoice_request.dart';
// chứa các hàm sử dụng lại trong toàn bộ ứng dụng

bool isSameDate(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

int TotalSeatPrice(int seatCount, int seatPrice) {
  return seatCount * seatPrice;
}

// Hàm tính toán giá tiền
class PriceCalculator {
  // ==========================================
  // 1. TÍNH TỔNG TIỀN CÁC MỤC (Ghế & Đồ ăn)
  // ==========================================

  /// Tính tổng tiền ghế
  static double calcSeatTotal(List<Seat> seats) {
    // Cộng dồn giá của tất cả ghế trong list
    return seats.fold(0.0, (sum, seat) => sum + seat.price);
  }

  /// Tính tổng tiền đồ ăn (Giá * Số lượng)
  static double calcFoodTotal(List<FoodItem> foods) {
    return foods.fold(0.0, (sum, food) => sum + ((food.gia ?? 0) * (food.soLuong ?? 0)));
  }

  /// Tổng tạm tính
  static double calcSubTotal({
    required double seatTotal,
    required double foodTotal,
  }) {
    return seatTotal + foodTotal;
  }

  // 2. TÍNH SỐ TIỀN ĐƯỢC GIẢM (Discount Amount)
  static double calculateDiscountAmount({
    required double subTotal,
    Voucher? voucher,
  }) {
    // Chưa chọn voucher thì giảm 0đ
    if (voucher == null) return 0.0;

    // Nếu voucher không hoạt động hoặc hết hạn
    if (voucher.trangThai != true) return 0.0;

    double discount = 0.0;

    // Logic tính toán dựa trên loại voucher
    if (voucher.loaiGiamGia == DiscountType.PERCENTAGE) {
      // Ví dụ: Tổng 200k, giảm 10% -> discount = 20k
      discount = subTotal * (voucher.giaTriGiam / 100);
    } else {
      // Ví dụ: Giảm thẳng 50k -> discount = 50k
      discount = voucher.giaTriGiam;
    }

    return discount > subTotal ? subTotal : discount;
  }

  // 3. TÍNH TỔNG CUỐI CÙNG SAU KHI GIẢM GIÁ
  static double calculateFinalTotal({
    required double subTotal,
    required double discountAmount,
  }) {
    return subTotal - discountAmount;
  }
}

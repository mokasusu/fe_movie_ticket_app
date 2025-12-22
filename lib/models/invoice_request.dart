class InvoiceRequest {
  final String maUser;
  final int maSuatChieu; // Java Long -> Dart int
  final String? voucherId; // Có thể null
  final List<SeatRequest> gheList;
  final List<FoodRequest> doAnList;

  InvoiceRequest({
    required this.maUser,
    required this.maSuatChieu,
    this.voucherId,
    required this.gheList,
    required this.doAnList,
  });

  // Hàm chuyển đổi sang JSON để gửi đi
  Map<String, dynamic> toJson() {
    return {
      'maUser': maUser,
      'maSuatChieu': maSuatChieu,
      'voucherId': voucherId,
      'gheList': gheList.map((e) => e.toJson()).toList(),
      'doAnList': doAnList.map((e) => e.toJson()).toList(),
    };
  }
}

// Class con cho Ghế
class SeatRequest {
  final String maSeatType; // Mapping với Java: String maSeatType

  SeatRequest({required this.maSeatType});

  Map<String, dynamic> toJson() {
    return {
      'maSeatType': maSeatType,
    };
  }
}

// Class con cho Đồ ăn
class FoodRequest {
  final String foodId;
  final int soLuong;

  FoodRequest({
    required this.foodId,
    required this.soLuong,
  });

  Map<String, dynamic> toJson() {
    return {
      'foodId': foodId,
      'soLuong': soLuong,
    };
  }
}
enum SeatType { normal, vip, couple }

class Seat {
  final String id;
  final SeatType type;
  final int price;
  bool isBooked;
  bool isSelected;

  Seat({
    required this.id,
    this.type = SeatType.normal,
    this.price = 45000,
    this.isBooked = false,
    this.isSelected = false,
  });

  /// Tạo sơ đồ ghế
  static List<List<Seat>> generateSeats({List<String>? bookedIds}) {
    bookedIds ??= [];
    List<List<Seat>> seats = [];

    for (int row = 0; row < 6; row++) {
      List<Seat> seatRow = [];
      if (row == 5) {
        // Hàng 6: chỉ 4 ghế đôi
        for (int col = 1; col <= 4; col++) {
          String id = "F$col";
          seatRow.add(Seat(
            id: id,
            type: SeatType.couple,
            price: 120000,
            isBooked: bookedIds.contains(id),
          ));
        }
      } else {
        for (int col = 1; col <= 8; col++) {
          String id = "${String.fromCharCode(65 + row)}$col";

          SeatType type = SeatType.normal;
          int price = 45000;

          if (row == 3 || row == 4) {
            type = SeatType.vip;
            price = 70000;
          }

          seatRow.add(Seat(
            id: id,
            type: type,
            price: price,
            isBooked: bookedIds.contains(id),
          ));
        }
      }
      seats.add(seatRow);
    }

    return seats;
  }
}

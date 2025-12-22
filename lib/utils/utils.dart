// chứa các hàm sử dụng lại trong toàn bộ ứng dụng

bool isSameDate(DateTime a, DateTime b) {
  return a.year == b.year &&
      a.month == b.month &&
      a.day == b.day;
}

int TotalSeatPrice(int seatCount, int seatPrice) {
  return seatCount * seatPrice;
}


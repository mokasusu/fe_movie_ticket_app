class RevenueByDayResponse {
  final DateTime date;
  final int revenue;

  RevenueByDayResponse({
    required this.date,
    required this.revenue,
  });

  factory RevenueByDayResponse.fromJson(Map<String, dynamic> json) {
    return RevenueByDayResponse(
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      revenue: json['revenue'] ?? 0,
    );
  }
}
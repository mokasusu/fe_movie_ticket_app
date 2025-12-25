class RevenueSummaryResponse {
  final int todayRevenue;
  final int monthRevenue;
  final int yearRevenue;
  final int totalTickets;

  RevenueSummaryResponse({
    required this.todayRevenue,
    required this.monthRevenue,
    required this.yearRevenue,
    required this.totalTickets,
  });

  factory RevenueSummaryResponse.fromJson(Map<String, dynamic> json) {
    return RevenueSummaryResponse(
      todayRevenue: json['todayRevenue'] ?? 0,
      monthRevenue: json['monthRevenue'] ?? 0,
      yearRevenue: json['yearRevenue'] ?? 0,
      totalTickets: json['totalTickets'] ?? 0,
    );
  }
}
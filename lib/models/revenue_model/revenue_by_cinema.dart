class RevenueByCinemaResponse {
  final int cinemaId;
  final String cinema;
  final int revenue;

  RevenueByCinemaResponse({
    required this.cinemaId,
    required this.cinema,
    required this.revenue,
  });

  factory RevenueByCinemaResponse.fromJson(Map<String, dynamic> json) {
    return RevenueByCinemaResponse(
      cinemaId: json['cinemaId'] ?? 0,
      cinema: json['cinema'] ?? '',
      revenue: json['revenue'] ?? 0,
    );
  }
}
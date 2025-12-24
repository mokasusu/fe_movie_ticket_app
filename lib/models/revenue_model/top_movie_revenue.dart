class TopMovieRevenueResponse {
  final String movieId;
  final String movieName;
  final int tickets;
  final int revenue;

  TopMovieRevenueResponse({
    required this.movieId,
    required this.movieName,
    required this.tickets,
    required this.revenue,
  });

  factory TopMovieRevenueResponse.fromJson(Map<String, dynamic> json) {
    return TopMovieRevenueResponse(
      movieId: json['movieId'] ?? '',
      movieName: json['movieName'] ?? '',
      tickets: json['tickets'] ?? 0,
      revenue: json['revenue'] ?? 0,
    );
  }
}
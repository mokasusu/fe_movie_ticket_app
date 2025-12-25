import 'package:dio/dio.dart';
import '../../models/revenue_model/revenue_summary.dart';
import '../../models/revenue_model/revenue_by_day.dart';
import '../../models/revenue_model/revenue_by_cinema.dart';
import '../../models/revenue_model/top_movie_revenue.dart';
import '../../api/dio_client.dart';

class RevenueService {
  static const String _endpoint = "/revenue";

  final Dio dio;
  RevenueService({Dio? dio}) : dio = dio ?? DioClient.dio;

  Future<RevenueSummaryResponse> getSummary() async {
    final res = await dio.get("$_endpoint/summary");
    return RevenueSummaryResponse.fromJson(res.data);
  }

  Future<List<RevenueByDayResponse>> getRevenueByDay({
    required DateTime from,
    required DateTime to,
  }) async {
    final res = await dio.get(
      "$_endpoint/by-day",
      queryParameters: {
        "from": _formatDate(from),
        "to": _formatDate(to),
      },
    );
    final list = res.data as List;
    return list.map((e) => RevenueByDayResponse.fromJson(e)).toList();
  }

  Future<List<TopMovieRevenueResponse>> getTopMovies({int limit = 5}) async {
    final res = await dio.get("$_endpoint/top-movies", queryParameters: {
      "limit": limit,
    });
    final list = res.data as List;
    return list.map((e) => TopMovieRevenueResponse.fromJson(e)).toList();
  }

  Future<List<RevenueByCinemaResponse>> getRevenueByCinema() async {
    final res = await dio.get("$_endpoint/by-cinema");
    final list = res.data as List;
    return list.map((e) => RevenueByCinemaResponse.fromJson(e)).toList();
  }

  String _formatDate(DateTime d) => d.toIso8601String().split('T').first;
}
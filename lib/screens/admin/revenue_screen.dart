import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../services/api/revenue_service.dart';
import '../../models/revenue_model/revenue_summary.dart';
import '../../models/revenue_model/revenue_by_day.dart';
import '../../models/revenue_model/top_movie_revenue.dart';
import '../../models/revenue_model/revenue_by_cinema.dart';

class RevenueScreen extends StatefulWidget {
  const RevenueScreen({super.key});

  @override
  State<RevenueScreen> createState() => _RevenueScreenState();
}

class _RevenueScreenState extends State<RevenueScreen> {
  late final RevenueService _service = RevenueService();

  late Future<RevenueSummaryResponse> _summaryFuture;
  late Future<List<RevenueByDayResponse>> _byDayFuture;
  late Future<List<RevenueByCinemaResponse>> _byCinemaFuture;
  late Future<List<TopMovieRevenueResponse>> _topMoviesFuture;

  @override
  void initState() {
    super.initState();
    _reloadData();
  }

  void _reloadData() {
    final now = DateTime.now();
    final from = now.subtract(const Duration(days: 14));
    _summaryFuture = _service.getSummary();
    _byDayFuture = _service.getRevenueByDay(from: from, to: now);
    _byCinemaFuture = _service.getRevenueByCinema();
    _topMoviesFuture = _service.getTopMovies(limit: 5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doanh thu')),
      body: RefreshIndicator(
        onRefresh: () async => setState(_reloadData),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildSummaryCards(),
              const SizedBox(height: 16),
              _buildRevenueLineChart(),
              const SizedBox(height: 16),
              _buildCinemaBarChart(),
              const SizedBox(height: 16),
              _buildTopMoviesList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return FutureBuilder<RevenueSummaryResponse>(
      future: _summaryFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LinearProgressIndicator();
        }
        if (snapshot.hasError) return _errorBox('Không tải được summary: ${snapshot.error}');
        final data = snapshot.data!;
        final items = [
          ('Hôm nay', data.todayRevenue),
          ('Tháng', data.monthRevenue),
          ('Năm', data.yearRevenue),
          ('Vé đã bán', data.totalTickets),
        ];
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 2.0, // giảm để tránh overflow
          ),
          itemBuilder: (_, idx) {
            final (title, value) = items[idx];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      _formatCurrency(value),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRevenueLineChart() {
    return FutureBuilder<List<RevenueByDayResponse>>(
      future: _byDayFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LinearProgressIndicator();
        }
        if (snapshot.hasError) return _errorBox('Không tải được doanh thu ngày: ${snapshot.error}');
        final data = snapshot.data!;
        final spots = <FlSpot>[];
        final labels = <int, String>{};
        for (var i = 0; i < data.length; i++) {
          spots.add(FlSpot(i.toDouble(), data[i].revenue.toDouble()));
          labels[i] =
          "${data[i].date.month.toString().padLeft(2, '0')}-${data[i].date.day.toString().padLeft(2, '0')}";
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              height: 260,
              child: LineChart(
                LineChartData(
                  minY: 0,
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final idx = value.toInt();
                          if (!labels.containsKey(idx)) return const SizedBox();
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(labels[idx]!, style: const TextStyle(fontSize: 10)),
                          );
                        },
                        interval: 2,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 44,
                        getTitlesWidget: (value, meta) => Text(
                          _shortCurrency(value.toInt()),
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                  ),
                  gridData: const FlGridData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blue.withOpacity(0.15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCinemaBarChart() {
    return FutureBuilder<List<RevenueByCinemaResponse>>(
      future: _byCinemaFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LinearProgressIndicator();
        }
        if (snapshot.hasError) return _errorBox('Không tải được doanh thu theo rạp: ${snapshot.error}');
        final data = snapshot.data!;
        final maxRevenue = data.isEmpty
            ? 1
            : data.map((e) => e.revenue).reduce((a, b) => a > b ? a : b).toDouble();

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              height: 260,
              child: BarChart(
                BarChartData(
                  maxY: maxRevenue * 1.1,
                  barGroups: [
                    for (var i = 0; i < data.length; i++)
                      BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: data[i].revenue.toDouble(),
                            color: Colors.deepPurple,
                            width: 18,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                        showingTooltipIndicators: const [0],
                      ),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final idx = value.toInt();
                          if (idx < 0 || idx >= data.length) return const SizedBox();
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              data[idx].cinema,
                              style: const TextStyle(fontSize: 10),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 44,
                        getTitlesWidget: (value, meta) => Text(
                          _shortCurrency(value.toInt()),
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                  ),
                  gridData: const FlGridData(show: true),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopMoviesList() {
    return FutureBuilder<List<TopMovieRevenueResponse>>(
      future: _topMoviesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LinearProgressIndicator();
        }
        if (snapshot.hasError) return _errorBox('Không tải được top phim: ${snapshot.error}');
        final data = snapshot.data!;
        return Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(12),
                child: Text('Top phim theo doanh thu',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              if (data.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text('Chưa có dữ liệu'),
                ),
              for (final movie in data)
                ListTile(
                  title: Text(movie.movieName),
                  subtitle: Text('Vé: ${movie.tickets}'),
                  trailing: Text(_formatCurrency(movie.revenue)),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _errorBox(String msg) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.red.withOpacity(0.08),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(msg, style: const TextStyle(color: Colors.red)),
  );

  String _formatCurrency(int value) {
    return '${value.toString().replaceAllMapped(RegExp(r"(\d)(?=(\d{3})+(?!\d))"), (m) => '${m[1]}.')} đ';
  }

  String _shortCurrency(int value) {
    if (value >= 1000000000) return '${(value / 1000000000).toStringAsFixed(1)}B';
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
    return value.toString();
  }
}
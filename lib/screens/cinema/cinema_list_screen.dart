import 'package:flutter/material.dart';
import '../../models/cinema.dart';
import '../../models/movie.dart';
import '../../services/api/cinema_service.dart';
import '../../services/api/showtime_service.dart';
import '../showtime/showtime_screen.dart';
import '../../theme/colors.dart';

class CinemaListScreen extends StatefulWidget {
  final Movie? selectedMovie;

  const CinemaListScreen({
    super.key,
    this.selectedMovie,
  });

  @override
  State<CinemaListScreen> createState() => _CinemaListScreenState();
}

class _CinemaListScreenState extends State<CinemaListScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<Cinema> _baseCinemas = [];
  List<Cinema> _displayCinemas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCinemasFromApi();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCinemasFromApi() async {
    setState(() => _isLoading = true);

    try {
      final cinemas = await CinemaService.fetchCinemas();
      List<Cinema> filtered = cinemas;

      if (widget.selectedMovie != null) {
        final showtimes =
            await ShowtimeService.fetchByMovie(widget.selectedMovie!.maPhim);
        final cinemaIds = showtimes.map((s) => s.maRap).toSet();
        filtered = cinemas.where((c) => cinemaIds.contains(c.maRap)).toList();
      }

      if (!mounted) return;

      setState(() {
        _baseCinemas = filtered;
        _displayCinemas = filtered;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _displayCinemas = _baseCinemas
          .where((c) => c.tenRap.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final title =
        widget.selectedMovie != null ? "Chọn rạp" : "Danh sách rạp";

    final subTitle =
        widget.selectedMovie?.tenPhim ?? "Chọn rạp bạn muốn đến";

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,

      appBar: AppBar(
        backgroundColor: AppColors.bgSecondary,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    color: AppColors.textPrimary, fontSize: 18)),
            Text(
              subTitle,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 12),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          // SEARCH
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: "Tìm tên rạp...",
                hintStyle:
                    const TextStyle(color: AppColors.textMuted),
                prefixIcon:
                    const Icon(Icons.search, color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.bgSecondary,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.gold,
                    ),
                  )
                : _displayCinemas.isEmpty
                    ? const Center(
                        child: Text(
                          "Không có rạp nào",
                          style: TextStyle(
                              color: AppColors.textMuted, fontSize: 16),
                        ),
                      )
                    : ListView.separated(
                        itemCount: _displayCinemas.length,
                        separatorBuilder: (_, __) => const Divider(
                          height: 1,
                          color: AppColors.disabled,
                        ),
                        itemBuilder: (context, index) {
                          final cinema = _displayCinemas[index];

                          return ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.gold.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.theater_comedy,
                                color: AppColors.gold,
                              ),
                            ),
                            title: Text(
                              cinema.tenRap,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              cinema.diaDiem,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: AppColors.textSecondary),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: AppColors.textMuted,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ShowtimeScreen(
                                    cinemaId: cinema.maRap,
                                    selectedMovie: widget.selectedMovie,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

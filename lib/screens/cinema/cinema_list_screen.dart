import 'package:flutter/material.dart';
import '../../models/cinema.dart';
import '../../models/film_model.dart';
import '../../services/api/cinema_service.dart';
import '../showtime/showtime_screen.dart';
import '../../theme/colors.dart';

// thanh tìm kiếm
class CinemaSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const CinemaSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: "Tìm tên rạp...",
          hintStyle: const TextStyle(color: AppColors.textMuted),
          prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
          filled: true,
          fillColor: AppColors.bgSecondary,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

// ===== CINEMA LIST SCREEN =====
class CinemaListScreen extends StatefulWidget {
  final FilmResponse? selectedMovie;

  const CinemaListScreen({super.key, this.selectedMovie});

  @override
  State<CinemaListScreen> createState() => _CinemaListScreenState();
}

class _CinemaListScreenState extends State<CinemaListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<List<Cinema>> _filteredCinemas = ValueNotifier([]);
  List<Cinema> _allCinemas = [];
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
    _filteredCinemas.dispose();
    super.dispose();
  }

  Future<void> _loadCinemasFromApi() async {
    setState(() => _isLoading = true);
    try {
      final cinemas = await CinemaService.fetchCinemas();
      if (!mounted) return;

      _allCinemas = cinemas;
      _filteredCinemas.value = cinemas;

      setState(() => _isLoading = false);
    } catch (e) {
      debugPrint('❌ Lỗi load rạp: $e');
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    final filtered = _allCinemas
        .where((c) => c.tenRap.toLowerCase().contains(query))
        .toList();
    _filteredCinemas.value = filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgSecondary,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        centerTitle: true,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.selectedMovie != null ? 'Chọn rạp' : 'Danh sách rạp',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            if (widget.selectedMovie != null)
              Text(
                widget.selectedMovie!.tenPhim,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
      body: Column(
        children: [
          CinemaSearchBar(
            controller: _searchController,
            onChanged: (v) => _onSearchChanged(),
          ),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.gold),
                  )
                : ValueListenableBuilder<List<Cinema>>(
                    valueListenable: _filteredCinemas,
                    builder: (context, cinemas, _) {
                      if (cinemas.isEmpty) {
                        return const Center(
                          child: Text(
                            'Không có rạp nào',
                            style: TextStyle(color: AppColors.textMuted),
                          ),
                        );
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        itemCount: cinemas.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 6),
                        itemBuilder: (context, index) {
                          final cinema = cinemas[index];
                          return Card(
                            color: AppColors.bgSecondary,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              leading: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: AppColors.gold.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.location_on,
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
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              trailing: const Icon(
                                Icons.chevron_right,
                                color: AppColors.textMuted,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ShowtimeScreen(
                                      selectedCinema: cinema,
                                      selectedMovie: widget.selectedMovie,
                                    ),
                                  ),
                                );
                              },
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

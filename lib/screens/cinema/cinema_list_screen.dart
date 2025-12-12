import 'package:flutter/material.dart';
import '../../models/cinema.dart';
import '../../models/movie.dart';
import '../../services/api/cinema_service.dart';
import '../../services/api/showtime_service.dart';
import '../showtime/showtime_screen.dart';

class CinemaListScreen extends StatefulWidget {
  final Movie? selectedMovie; // Có thể null

  const CinemaListScreen({
    super.key,
    this.selectedMovie,
  });

  @override
  State<CinemaListScreen> createState() => _CinemaListScreenState();
}

class _CinemaListScreenState extends State<CinemaListScreen> {
  TextEditingController _searchController = TextEditingController();

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

  // LẤY DỮ LIỆU RẠP TỪ API
  Future<void> _loadCinemasFromApi() async {
    setState(() => _isLoading = true);

    try {
      // Lấy tất cả rạp
      final cinemas = await CinemaService.fetchCinemas();
      print("All cinemas from API: ${cinemas.map((c) => c.maRap).toList()}");

      List<Cinema> filtered = cinemas;

      // Nếu đã chọn phim → lọc rạp đang chiếu phim đó
      if (widget.selectedMovie != null) {
        final showtimes =
            await ShowtimeService.fetchByMovie(widget.selectedMovie!.maPhim);
        print(
            "Showtimes for movie ${widget.selectedMovie!.maPhim}: ${showtimes.map((s) => s.maRap).toList()}");

        // Lấy danh sách mã rạp từ suất chiếu
        final cinemaIds = showtimes.map((s) => s.maRap).toSet();
        print("Cinema IDs from showtimes: $cinemaIds");

        // Filter rạp
        filtered = cinemas.where((c) => cinemaIds.contains(c.maRap)).toList();
        print("Filtered cinemas: ${filtered.map((c) => c.maRap).toList()}");
      }

      if (!mounted) return;

      setState(() {
        _baseCinemas = filtered;
        _displayCinemas = filtered;
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading cinemas: $e");
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }



  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _displayCinemas = _baseCinemas
          .where((cinema) => cinema.tenRap.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final String title =
        widget.selectedMovie != null ? "Chọn rạp" : "Danh sách rạp";

    final String subTitle =
        widget.selectedMovie?.tenPhim ?? "Chọn rạp bạn muốn đến";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 18)),
            Text(
              subTitle,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Ô tìm kiếm
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Tìm tên rạp...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),

          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.pinkAccent,
                    ),
                  )
                : _displayCinemas.isEmpty
                    ? const Center(
                        child: Text(
                          "Không có rạp nào",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      )
                    : ListView.separated(
                        itemCount: _displayCinemas.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final cinema = _displayCinemas[index];

                          return ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.pinkAccent.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.theater_comedy,
                                  color: Colors.pinkAccent),
                            ),
                            title: Text(cinema.tenRap,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                            subtitle: Text(
                              cinema.diaDiem,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios,
                                size: 14, color: Colors.grey),
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (_) => ShowtimeScreen(
                              //       cinemaId: cinema.ma,
                              //       selectedMovie: widget.selectedMovie,
                              //     ),
                              //   ),
                              // );
                              print("Chọn rạp: ${cinema.tenRap}");
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

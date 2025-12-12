// import 'package:flutter/material.dart';

// import '../../widgets/appBar/showtime_appbar.dart';
// import '../../widgets/showtime/choice_date.dart';
// import '../../widgets/card/showtime_card.dart';
// import '../../models/movie.dart';
// import '../../models/showtime.dart';
// import '../../screens/seat/seat_selection_screen.dart';

// class ShowtimeScreen extends StatefulWidget {
//   final String? cinemaId;
//   final Movie? selectedMovie;

//   const ShowtimeScreen({super.key, this.cinemaId, this.selectedMovie});

//   @override
//   State<ShowtimeScreen> createState() => _ShowtimeScreenState();
// }

// class _ShowtimeScreenState extends State<ShowtimeScreen> {
//   DateTime selectedDate = DateTime.now();
//   bool isLoading = false;
//   int _loadId = 0;
//   Map<String, List<Showtime>> movieShowtimes = {};

//   String getVietnameseDate(DateTime date) {
//     final List<String> weekdays = [
//       "Chủ Nhật", "Thứ Hai", "Thứ Ba", "Thứ Tư", "Thứ Năm", "Thứ Sáu", "Thứ Bảy"
//     ];
//     String thu = weekdays[date.weekday == 7 ? 0 : date.weekday];
//     return "$thu, ngày ${date.day} tháng ${date.month} năm ${date.year}";
//   }

//   // Lấy danh sách phim CÓ THỂ chiếu tại rạp
//   List<Movie> getMovies() {
//     if (widget.selectedMovie != null) return [widget.selectedMovie!];

//     if (widget.cinemaId != null) {
//       // Lấy danh sách ID phim có lịch chiếu tại rạp này
//       final movieIds = mockShowtimes
//           .where((s) => s.cinemaId == widget.cinemaId)
//           .map((s) => s.movieId)
//           .toSet();
//       // Lọc danh sách Movie object từ ID
//       return mockMovies.where((m) => movieIds.contains(m.MaPhim)).toList();
//     }
//     return [];
//   }

//   // Lọc suất chiếu theo phim và ngày
//   List<Showtime> filterShowtimes(Movie movie, DateTime date) {
//     if (widget.cinemaId == null) return [];
//     return mockShowtimes
//         .where((s) =>
//             s.cinemaId == widget.cinemaId &&
//             s.movieId == movie.MaPhim &&
//             s.startTime.year == date.year &&
//             s.startTime.month == date.month &&
//             s.startTime.day == date.day)
//         .toList();
//   }

//   Future<void> _onDateSelected(DateTime date) async {
//     final int currentId = ++_loadId;

//     setState(() {
//       selectedDate = date;
//       isLoading = true;
//     });

//     // Giả lập delay loading
//     await Future.delayed(const Duration(milliseconds: 300));

//     if (currentId != _loadId) return;

//     final movies = getMovies();
//     final Map<String, List<Showtime>> newShowtimes = {};

//     for (var movie in movies) {
//       newShowtimes[movie.MaPhim] = filterShowtimes(movie, date);
//     }

//     if (!mounted) return;

//     setState(() {
//       movieShowtimes = newShowtimes;
//       isLoading = false;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _onDateSelected(selectedDate);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final cinemaName = widget.cinemaId != null
//         ? cinemas.firstWhere((c) => c.ma == widget.cinemaId!).ten
//         : '';

//     final allMovies = getMovies();

//     // Chỉ lấy những phim THỰC SỰ có suất chiếu vào ngày đã chọn
//     final activeMovies = allMovies.where((movie) {
//       final showtimes = movieShowtimes[movie.MaPhim];
//       return showtimes != null && showtimes.isNotEmpty;
//     }).toList();

//     return Scaffold(
//       appBar: const ShowtimeAppBar(),
//       body: Stack(
//         children: [
//           Column(
//             children: [
//               // Hiển thị tên rạp (nếu có)
//               if (cinemaName.isNotEmpty)
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//                   color: Colors.black,
//                   child: Text(
//                     cinemaName,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 17,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),

//               // Widget chọn ngày
//               MovieDatePicker(
//                 currentDate: selectedDate,
//                 onDateSelected: _onDateSelected,
//               ),

//               // Hiển thị ngày đã chọn bằng chữ
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                 color: Colors.black,
//                 child: Text(
//                   getVietnameseDate(selectedDate),
//                   style: const TextStyle(
//                     color: Colors.white70,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                     fontStyle: FontStyle.italic,
//                   ),
//                 ),
//               ),

//               const Divider(height: 1, color: Colors.grey),

//               // Danh sách phim và suất chiếu
//               Expanded(
//                 child: activeMovies.isEmpty
//                     ? Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: const [
//                             Icon(Icons.event_busy, size: 60, color: Colors.grey),
//                             SizedBox(height: 16),
//                             Text(
//                               "Chưa có lịch chiếu",
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     : ListView.builder(
//                         itemCount: activeMovies.length,
//                         itemBuilder: (context, index) {
//                           final movie = activeMovies[index];
//                           final showtimes = movieShowtimes[movie.MaPhim]!;

//                           return ShowtimeCard(
//                             movie: movie,
//                             showtimes: showtimes,
//                             onShowtimeSelected: (Showtime s) {
//                               // Chuyển sang màn hình chọn ghế
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => CinemaBookingScreen(
//                                     showtime: s,                // Truyền suất chiếu
//                                     movieTitle: movie.TenPhim,  // Truyền tên phim
//                                     cinemaName: cinemaName,     // Truyền tên rạp
//                                   ),
//                                 ),
//                               );
//                             },
//                           );
//                         },
//                       ),
//               ),
//             ],
//           ),

//           // Loading Indicator
//           if (isLoading)
//             Positioned.fill(
//               child: Container(
//                 color: Colors.black.withOpacity(0.5),
//                 child: const Center(
//                   child: CircularProgressIndicator(
//                     color: Colors.redAccent,
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
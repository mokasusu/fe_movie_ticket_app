// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'dart:convert';

// import '../../models/ghe.dart';
// import '../../models/showtime.dart';
// import '../../widgets/seat/screen_widget.dart';
// import '../../widgets/seat/seat_widget.dart';
// import '../../widgets/seat/legend_widget.dart';

// class CinemaBookingScreen extends StatefulWidget {
//   final Showtime showtime;
//   final String movieTitle;
//   final String cinemaName;

//   const CinemaBookingScreen({
//     Key? key,
//     required this.showtime,
//     required this.movieTitle,
//     required this.cinemaName,
//   }) : super(key: key);

//   @override
//   State<CinemaBookingScreen> createState() => _CinemaBookingScreenState();
// }

// class _CinemaBookingScreenState extends State<CinemaBookingScreen> {
//   late final BookingController _controller;

//   Map<String, List<Ghe>> _rows = {};
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _controller = BookingController();
//     _loadSeatData();
//   }

//   Future<void> _loadSeatData() async {
//     await Future.delayed(const Duration(milliseconds: 500));

//     String seatJsonString = '''
//       [
//         {"ma": "A1", "ten": "1", "gia": 90000, "phan_loai": "STANDARD", "da_dat": false},
//         {"ma": "A2", "ten": "2", "gia": 90000, "phan_loai": "STANDARD", "da_dat": false},
//         {"ma": "A3", "ten": "3", "gia": 90000, "phan_loai": "STANDARD", "da_dat": false},
//         {"ma": "A4", "ten": "4", "gia": 90000, "phan_loai": "STANDARD", "da_dat": false},
//         {"ma": "A5", "ten": "5", "gia": 90000, "phan_loai": "STANDARD", "da_dat": false},
//         {"ma": "A6", "ten": "6", "gia": 90000, "phan_loai": "STANDARD", "da_dat": false},
        
//         {"ma": "B1", "ten": "1", "gia": 90000, "phan_loai": "STANDARD", "da_dat": false},
//         {"ma": "B2", "ten": "2", "gia": 90000, "phan_loai": "STANDARD", "da_dat": false},
//         {"ma": "B3", "ten": "3", "gia": 90000, "phan_loai": "STANDARD", "da_dat": true},
//         {"ma": "B4", "ten": "4", "gia": 90000, "phan_loai": "STANDARD", "da_dat": true},
//         {"ma": "B5", "ten": "5", "gia": 90000, "phan_loai": "STANDARD", "da_dat": false},
//         {"ma": "B6", "ten": "6", "gia": 90000, "phan_loai": "STANDARD", "da_dat": false},

//         {"ma": "C1", "ten": "1", "gia": 120000, "phan_loai": "VIP", "da_dat": false},
//         {"ma": "C2", "ten": "2", "gia": 120000, "phan_loai": "VIP", "da_dat": false},
//         {"ma": "C3", "ten": "3", "gia": 120000, "phan_loai": "VIP", "da_dat": true},
//         {"ma": "C4", "ten": "4", "gia": 120000, "phan_loai": "VIP", "da_dat": true},
//         {"ma": "C5", "ten": "5", "gia": 120000, "phan_loai": "VIP", "da_dat": false},
//         {"ma": "C6", "ten": "6", "gia": 120000, "phan_loai": "VIP", "da_dat": false},

//         {"ma": "D1", "ten": "1", "gia": 240000, "phan_loai": "COUPLE", "da_dat": false},
//         {"ma": "D2", "ten": "2", "gia": 240000, "phan_loai": "COUPLE", "da_dat": false},
//         {"ma": "D3", "ten": "3", "gia": 240000, "phan_loai": "COUPLE", "da_dat": false},
//         {"ma": "D4", "ten": "4", "gia": 240000, "phan_loai": "COUPLE", "da_dat": false}
//       ]''';

//     try {
//       List<dynamic> parsedSeatList = json.decode(seatJsonString);
//       List<Ghe> seats = parsedSeatList.map((json) => Ghe.fromJson(json)).toList();

//       _controller.setSeats(seats);

//       Map<String, List<Ghe>> grouped = {};
//       for (var seat in seats) {
//         String row = seat.ma.substring(0, 1);
//         grouped.putIfAbsent(row, () => []);
//         grouped[row]!.add(seat);
//       }

//       // Sort ghế theo tên
//       for (var row in grouped.keys) {
//         grouped[row]!.sort((a, b) => a.ten.compareTo(b.ten));
//       }

//       if (mounted) {
//         setState(() {
//           _rows = grouped;
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       debugPrint("Lỗi parse ghế: $e");
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     String roomName = widget.showtime.room.isNotEmpty ? widget.showtime.room : "Rạp 1";

//     return Scaffold(
//       backgroundColor: const Color(0xFF1A1A2E),
//       appBar: _buildAppBar(roomName),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF6B6B)))
//           : Column(
//               children: [
//                 _buildInfoBar(),
//                 Expanded(
//                   child: InteractiveViewer(
//                     maxScale: 3.0,
//                     minScale: 0.5,
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: 30, bottom: 100),
//                       child: Column(
//                         children: [
//                           const ScreenWidget(),
//                           const SizedBox(height: 40),
//                           _buildSeatMap(),
//                           const SizedBox(height: 50),
//                           const LegendWidget(),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 _buildBottomBar(),
//               ],
//             ),
//     );
//   }

//   AppBar _buildAppBar(String roomName) {
//     return AppBar(
//       backgroundColor: Colors.transparent,
//       elevation: 0,
//       leading: IconButton(
//         icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.white),
//         onPressed: () => Navigator.of(context).pop(),
//       ),
//       title: Column(
//         children: [
//           Text(widget.movieTitle,
//               style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
//           Text("${widget.cinemaName} - $roomName",
//               style: const TextStyle(color: Colors.grey, fontSize: 12)),
//         ],
//       ),
//       centerTitle: true,
//     );
//   }

//   Widget _buildSeatMap() {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: _rows.entries.map((entry) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(vertical: 6),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 SizedBox(
//                   width: 30,
//                   child: Text(
//                     entry.key,
//                     style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 ..._buildSeatsForRow(entry.value),
//               ],
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }

//   List<Widget> _buildSeatsForRow(List<Ghe> seatsInRow) {
//     List<Widget> widgets = [];

//     for (int i = 0; i < seatsInRow.length; i++) {
//       Ghe seat = seatsInRow[i];

//       // FIX: Không chia cặp cho COUPLE
//       if (seat.phanLoai != 'COUPLE') {
//         if (i > 0 && i % 2 == 0) {
//           widgets.add(const SizedBox(width: 20));
//         }
//       }

//       widgets.add(
//         Padding(
//           padding: EdgeInsets.only(right: seat.phanLoai == 'COUPLE' ? 12 : 6),
//           child: SeatWidget(
//             seatData: seat,
//             selectedSeatsNotifier: _controller.selectedSeatIdsNotifier,
//             onTap: () => setState(() => _controller.toggleSeat(seat.ma)),
//           ),
//         ),
//       );
//     }
//     return widgets;
//   }

//   Widget _buildInfoBar() {
//     String dateStr = DateFormat('dd/MM/yyyy').format(widget.showtime.startTime);
//     String timeStr = DateFormat('HH:mm').format(widget.showtime.startTime);

//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       color: const Color(0xFF16213E),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           _infoItem(Icons.calendar_today, dateStr),
//           _infoItem(Icons.access_time, timeStr),
//         ],
//       ),
//     );
//   }

//   Widget _infoItem(IconData icon, String text) {
//     return Row(
//       children: [
//         Icon(icon, size: 16, color: const Color(0xFFFF6B6B)),
//         const SizedBox(width: 4),
//         Text(text, style: const TextStyle(color: Colors.white70, fontSize: 12)),
//       ],
//     );
//   }

//   Widget _buildBottomBar() {
//     final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: const BoxDecoration(
//         color: Color(0xFF16213E),
//         border: Border(top: BorderSide(color: Colors.white10)),
//         boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, -5))],
//       ),
//       child: SafeArea(
//         child: Row(
//           children: [
//             Expanded(
//               child: ValueListenableBuilder<Set<String>>(
//                 valueListenable: _controller.selectedSeatIdsNotifier,
//                 builder: (context, selectedSeats, child) {
//                   double total = _controller.calculateTotal();
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         selectedSeats.isEmpty ? 'Chưa chọn ghế' : selectedSeats.join(', '),
//                         style: const TextStyle(color: Colors.white70, fontSize: 12),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         currencyFormat.format(total),
//                         style: const TextStyle(
//                             color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             ),
//             const SizedBox(width: 20),
//             ValueListenableBuilder<Set<String>>(
//               valueListenable: _controller.selectedSeatIdsNotifier,
//               builder: (context, selectedSeats, _) {
//                 bool isDisabled = selectedSeats.isEmpty;
//                 return ElevatedButton(
//                   onPressed: isDisabled
//                       ? null
//                       : () {
//                           debugPrint(
//                               "Đặt vé: Suất ${widget.showtime.id}, Ghế $selectedSeats");
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text('Đã chọn ghế: ${selectedSeats.join(', ')}')),
//                           );
//                         },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFFFF6B6B),
//                     disabledBackgroundColor: Colors.grey[800],
//                     padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//                     shape:
//                         RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                   ),
//                   child: const Text(
//                     'ĐẶT VÉ',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                 );
//               },
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

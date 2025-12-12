// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// // Đảm bảo import đúng đường dẫn model của bạn
// import '../../models/movie.dart';
// import '../../models/showtime.dart';
// import '../../screens/detailMovie/movie_detail_screen.dart';

// class ShowtimeCard extends StatelessWidget {
//   final Movie movie;
//   final List<Showtime> showtimes;
//   final void Function(Showtime) onShowtimeSelected;
//   // Có thể thêm callback cho nút xem chi tiết nếu cần
//   // final VoidCallback? onDetailsPressed;

//   const ShowtimeCard({
//     super.key,
//     required this.movie,
//     required this.showtimes,
//     required this.onShowtimeSelected,
//     // this.onDetailsPressed,
//   });

//   // Hàm helper để lấy màu cho nhãn độ tuổi
//   Color _getAgeColor(int age) {
//     if (age >= 18) return Colors.red;
//     if (age >= 16) return Colors.orange;
//     if (age >= 13) return Colors.yellow.shade800;
//     return Colors.green;
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (showtimes.isEmpty) {
//       return const SizedBox.shrink();
//     }

//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       elevation: 4,
//       color: Colors.white,
//       child: Column(
//         children: [
//           // ==========================================
//           // PHẦN 1: THÔNG TIN PHIM (HÀNG TRÊN)
//           // ==========================================
//           Padding(
//             padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
//             child: IntrinsicHeight(
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // 1. Poster Phim (Bên trái)
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(8),
//                     child: CachedNetworkImage(
//                       imageUrl: movie.AnhURLDoc,
//                       width: 95, // Tăng nhẹ kích thước
//                       height: 145,
//                       fit: BoxFit.cover,
//                       placeholder: (_, __) => Container(color: movie.posterColor),
//                       errorWidget: (_, __, ___) => Container(
//                         color: movie.posterColor,
//                         child: const Icon(Icons.movie, color: Colors.white54),
//                       ),
//                     ),
//                   ),

//                   const SizedBox(width: 14),

//                   // 2. Thông tin chi tiết
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Tên phim
//                         Text(
//                           movie.TenPhim,
//                           style: const TextStyle(
//                             fontSize: 17,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black87,
//                           ),
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
                        
//                         const SizedBox(height: 6),
                        
//                         // Thể loại
//                         Text(
//                           movie.TheLoai.join(', '),
//                           style: TextStyle(
//                             fontSize: 13,
//                             color: Colors.grey[600],
//                             height: 1.3,
//                           ),
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
                        
//                         const SizedBox(height: 10),
                        
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 Icon(Icons.access_time_filled, size: 15, color: Colors.grey[500]),
//                                 const SizedBox(width: 4),
//                                 Text(
//                                   "${movie.ThoiLuong} phút",
//                                   style: TextStyle(
//                                     fontSize: 13,
//                                     fontWeight: FontWeight.w500,
//                                     color: Colors.grey[700],
//                                   ),
//                                 ),
//                               ],
//                             ),

//                             const SizedBox(height: 6),

//                             Container(
//                               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//                               decoration: BoxDecoration(
//                                 color: _getAgeColor(movie.DoTuoi),
//                                 borderRadius: BorderRadius.circular(4),
//                               ),
//                               child: Text(
//                                 "T${movie.DoTuoi}",
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 11,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
                        
//                         const Spacer(),
//                         // Nút Xem chi tiết
//                         Align(
//                           alignment: Alignment.bottomRight,
//                           child: TextButton(
//                             onPressed: () {
//                                 print("Xem chi tiết ${movie.TenPhim}");
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => MovieDetailPage(movie: movie),
//                                   ),
//                                 );
//                             },
//                             style: TextButton.styleFrom(
//                               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                               minimumSize: Size.zero,
//                               tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                             ),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Text(
//                                   "Xem chi tiết",
//                                   style: TextStyle(
//                                     color: Colors.blueAccent.shade700,
//                                     fontSize: 13,
//                                     fontWeight: FontWeight.w600
//                                   ),
//                                 ),
//                                 Icon(Icons.chevron_right, size: 16, color: Colors.blueAccent.shade700)
//                               ],
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           const SizedBox(height: 8),

//           // ==========================================
//           // ĐƯỜNG KẺ NGANG
//           // ==========================================
//           const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),

//           // ==========================================
//           // PHẦN 2: SUẤT CHIẾU
//           // ==========================================
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(12),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                  const Text(
//                   "Suất chiếu:",
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
                
//                 Wrap(
//                   spacing: 12,
//                   runSpacing: 12,
//                   children: showtimes.map((s) {
//                     final timeStr =
//                       "${s.startTime.hour.toString().padLeft(2, '0')}:${s.startTime.minute.toString().padLeft(2, '0')}";
                          
//                     return InkWell(
//                       onTap: () => onShowtimeSelected(s),
//                       borderRadius: BorderRadius.circular(8),
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 16, vertical: 10
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(8),
//                             border: Border.all(color: Colors.blueAccent.shade100),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.blueAccent.withOpacity(0.1),
//                                 blurRadius: 4,
//                                 offset: const Offset(0, 2),
//                               )
//                             ],
//                           ),
//                           child: Text(
//                             timeStr,
//                             style: TextStyle(
//                               color: Colors.blueAccent.shade700,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 15,
//                             ),
//                           ),
//                         ),
//                     );
//                   }).toList(),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// lib/screens/admin/movie_management_screen.dart
import 'package:flutter/material.dart';
import '../../../models/film_model.dart';
import '../../../models/film_model.dart';
import 'movie_form_screen.dart'; //
import '../../../services/api/film_service.dart';

class MovieManagementScreen extends StatefulWidget {
  const MovieManagementScreen({super.key});

  @override
  State<MovieManagementScreen> createState() => _MovieManagementScreenState();
}

class _MovieManagementScreenState extends State<MovieManagementScreen> {
  final FilmService _filmService = FilmService();
  List<FilmResponse> _films = [];
  bool _isLoading = true;
  String _keyword = "";
  // Controller cho thanh tìm kiếm để có thể clear text
  final TextEditingController _searchCtrl = TextEditingController();

  Color getStatusColor(MovieStatus status) {
    switch (status) {
      case MovieStatus.NOW_SHOWING: return Colors.greenAccent;
      case MovieStatus.UPCOMING: return Colors.orangeAccent;
      case MovieStatus.ENDED: return Colors.redAccent;
      default: return Colors.grey;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadFilms(); // Load dữ liệu khi mở màn hình
  }

  // Hàm gọi API lấy danh sách
  Future<void> _loadFilms() async {
    setState(() => _isLoading = true);
    try {
      final films = await _filmService.getAllFilms(keyword: _keyword);
      setState(() {
        _films = films;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lỗi: ${e.toString()}")));
    }
  }

  // Hàm xử lý xóa phim
  void _confirmDelete(FilmResponse film) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text("Xác nhận xoá", style: TextStyle(color: Colors.redAccent)),
        content: Text("Bạn có chắc muốn xoá/ngưng chiếu phim '${film.tenPhim}'?", style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx), // Đóng dialog
            child: const Text("Hủy", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              Navigator.pop(ctx); // Đóng dialog trước khi gọi API
              try {
                await _filmService.deleteFilm(film.maPhim);
                // Xóa thành công thì load lại danh sách
                _loadFilms();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Đã xoá phim thành công")));
              } catch(e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lỗi: $e")));
              }
            },
            child: const Text("Xóa", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Quản lý Phim", style: TextStyle(color: Colors.white)),
      ),
      // Nút thêm mới nổi ở góc dưới
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          // Điều hướng sang màn hình Form (Chế độ Tạo mới - không truyền film)
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MovieFormScreen()),
          );
          // Nếu màn hình Form trả về 'true' (nghĩa là đã tạo/sửa thành công) -> Load lại list
          if (result == true) _loadFilms();
        },
      ),
      body: Column(
        children: [
          // Thanh tìm kiếm
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Tìm tên phim...",
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: _keyword.isNotEmpty ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchCtrl.clear();
                    setState(() => _keyword = "");
                    _loadFilms();
                  },
                ) : null,
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              ),
              // Khi nhấn Enter trên bàn phím ảo
              onSubmitted: (val) {
                setState(() => _keyword = val.trim());
                _loadFilms();
              },
            ),
          ),

          // Danh sách phim
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.redAccent))
                : _films.isEmpty
                ? const Center(child: Text("Không tìm thấy phim nào", style: TextStyle(color: Colors.grey)))
                : ListView.builder(
              itemCount: _films.length,
              itemBuilder: (context, index) {
                final film = _films[index];
                return Card(
                  color: const Color(0xFF1E1E1E),
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(8),
                    // Ảnh Poster nhỏ bên trái
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: film.anhPosterDoc.isNotEmpty
                          ? Image.network(
                        film.anhPosterDoc,
                        width: 50, height: 75, fit: BoxFit.cover,
                        errorBuilder: (_,__,___) => Container(color: Colors.grey, width: 50, height: 75, child: const Icon(Icons.broken_image)),
                      )
                          : Container(color: Colors.grey, width: 50, height: 75, child: const Icon(Icons.movie)),
                    ),
                    // Tên phim
                    title: Text(film.tenPhim, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                    // Thông tin phụ
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text("${film.thoiLuong} phút | ${film.doTuoi}+", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        const SizedBox(height: 4),
                        // Badge trạng thái
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                              color: getStatusColor(film.trangThai).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: getStatusColor(film.trangThai), width: 0.5)
                          ),
                          child: Text(film.trangThai.name, style: TextStyle(color: getStatusColor(film.trangThai), fontSize: 10, fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                    // Menu 3 chấm (Sửa/Xóa)
                    trailing: PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      color: const Color(0xFF2C2C2C),
                      onSelected: (value) async {
                        if (value == 'Sửa') {
                          // Điều hướng sang Form (Chế độ Sửa - Truyền film vào)
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => MovieFormScreen(film: film)),
                          );
                          if (result == true) _loadFilms();
                        } else if (value == 'delete') {
                          _confirmDelete(film);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'Sửa', child: Row(children: [Icon(Icons.edit, color: Colors.blue), SizedBox(width: 8), Text("Sửa", style: TextStyle(color: Colors.white))])),
                        const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete, color: Colors.redAccent), SizedBox(width: 8), Text("Xóa", style: TextStyle(color: Colors.redAccent))])),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
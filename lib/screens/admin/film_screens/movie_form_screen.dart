import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/film_model.dart';
import '../../../services/api/film_service.dart';
import '../../../services/api/genre_service.dart';
import '../../../models/genre_model.dart';

class MovieFormScreen extends StatefulWidget {
  final FilmResponse? film;

  const MovieFormScreen({super.key, this.film});

  @override
  State<MovieFormScreen> createState() => _MovieFormScreenState();
}

class _MovieFormScreenState extends State<MovieFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final FilmService _service = FilmService();
  final GenreService _genreService = GenreService();

  bool _isSubmitting = false;
  bool _isLoading = true;

  // --- CONTROLLERS ---
  final _tenCtrl = TextEditingController();
  final _daoDienCtrl = TextEditingController();
  final _dienVienCtrl = TextEditingController();
  final _thoiLuongCtrl = TextEditingController();
  final _moTaCtrl = TextEditingController();
  final _trailerCtrl = TextEditingController();
  final _posterDocCtrl = TextEditingController();
  final _posterNgangCtrl = TextEditingController();
  final _doTuoiCtrl = TextEditingController();

  // --- STATE VARIABLES ---
  DateTime? _ngayKhoiChieu;
  DateTime? _ngayKetThuc;

  // ✅ FIX 1: Mặc định là UPCOMING
  MovieStatus _selectedStatus = MovieStatus.UPCOMING;

  List<Genre> _apiGenres = [];
  List<String> _selectedGenreIds = [];

  bool get isEditMode => widget.film != null;

  @override
  void initState() {
    super.initState();
    _fetchGenres();

    if (isEditMode) {
      final f = widget.film!;
      _tenCtrl.text = f.tenPhim;
      _daoDienCtrl.text = f.daoDien;
      _dienVienCtrl.text = f.dienVien;
      _thoiLuongCtrl.text = f.thoiLuong.toString();
      _moTaCtrl.text = f.moTa;
      _trailerCtrl.text = f.trailerUrl;
      _posterDocCtrl.text = f.anhPosterDoc;
      _posterNgangCtrl.text = f.anhPosterNgang;
      _doTuoiCtrl.text = f.doTuoi.toString();
      _ngayKhoiChieu = f.ngayCongChieu;
      _ngayKetThuc = f.ngayKTChieu;

      // ✅ FIX 2: Khi Edit phải lấy trạng thái cũ từ API đắp vào
      _selectedStatus = f.trangThai;
    }
  }

  Future<void> _fetchGenres() async {
    try {
      // 1. Lấy danh sách tất cả thể loại từ API
      final genres = await _genreService.getAllGenres();

      if (mounted) {
        setState(() {
          _apiGenres = genres;

          // 2. LOGIC MAP: Nếu đang là Sửa (Edit Mode)
          if (isEditMode && widget.film!.genres.isNotEmpty) {
            // Duyệt qua danh sách TÊN thể loại của phim
            // Tìm trong _apiGenres xem cái nào trùng TÊN thì lấy ID của nó
            _selectedGenreIds = _apiGenres
                .where((g) => widget.film!.genres.contains(g.tenGenre))
                .map((g) => g.maGenre)
                .toList();
          }

          _isLoading = false;
        });
      }
    } catch (e) {
      print("🔥 Lỗi lấy genre: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ... (Giữ nguyên hàm _showMultiSelectGenres và dispose) ...
  // Để gọn code, tôi ẩn phần này, bạn giữ nguyên như cũ nhé.
  void _showMultiSelectGenres() async {
    // (Code cũ của bạn)
    if (_apiGenres.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Đang tải danh sách thể loại...")));
      return;
    }

    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        List<String> tempSelected = List.from(_selectedGenreIds);
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E1E1E),
              title: const Text("Chọn thể loại", style: TextStyle(color: Colors.white)),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _apiGenres.length,
                  itemBuilder: (context, index) {
                    final genre = _apiGenres[index];
                    final isChecked = tempSelected.contains(genre.maGenre);
                    return CheckboxListTile(
                      title: Text(genre.tenGenre, style: const TextStyle(color: Colors.white)),
                      value: isChecked,
                      activeColor: Colors.redAccent,
                      checkColor: Colors.white,
                      onChanged: (bool? value) {
                        setStateDialog(() {
                          if (value == true) tempSelected.add(genre.maGenre);
                          else tempSelected.remove(genre.maGenre);
                        });
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(child: const Text("Hủy", style: TextStyle(color: Colors.grey)), onPressed: () => Navigator.pop(context)),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                  child: const Text("Xác nhận", style: TextStyle(color: Colors.white)),
                  onPressed: () => Navigator.pop(context, tempSelected),
                ),
              ],
            );
          },
        );
      },
    );

    if (results != null) setState(() => _selectedGenreIds = results);
  }

  @override
  void dispose() {
    _tenCtrl.dispose(); _daoDienCtrl.dispose(); _dienVienCtrl.dispose();
    _thoiLuongCtrl.dispose(); _moTaCtrl.dispose(); _trailerCtrl.dispose();
    _posterDocCtrl.dispose(); _posterNgangCtrl.dispose(); _doTuoiCtrl.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_ngayKhoiChieu == null || _ngayKetThuc == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Vui lòng chọn ngày chiếu")));
      return;
    }
    if (_ngayKetThuc!.isBefore(_ngayKhoiChieu!)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Ngày kết thúc phải sau ngày khởi chiếu")));
      return;
    }
    if (_selectedGenreIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Vui lòng chọn ít nhất 1 thể loại")));
      return;
    }

    setState(() => _isSubmitting = true);
    final dateFormat = DateFormat('yyyy-MM-dd');

    final request = FilmRequest(
      tenPhim: _tenCtrl.text.trim(),
      daoDien: _daoDienCtrl.text.trim(),
      dienVien: _dienVienCtrl.text.trim(),
      thoiLuong: int.parse(_thoiLuongCtrl.text),
      moTa: _moTaCtrl.text.trim(),
      trailerUrl: _trailerCtrl.text.trim(),
      anhPosterDoc: _posterDocCtrl.text.trim(),
      anhPosterNgang: _posterNgangCtrl.text.trim(),
      doTuoi: int.parse(_doTuoiCtrl.text),
      ngayCongChieu: dateFormat.format(_ngayKhoiChieu!),
      ngayKTChieu: dateFormat.format(_ngayKetThuc!),
      // ✅ FIX 3: Luôn gửi trạng thái (dù là tạo mới hay sửa), vì Enum đã handle đúng tên
      trangThai: _selectedStatus.name,
      genresId: _selectedGenreIds,
    );

    try {
      if (isEditMode) {
        await _service.updateFilm(widget.film!.maPhim, request);
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Cập nhật thành công!")));
      } else {
        await _service.createFilm(request);
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Thêm phim mới thành công!")));
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      setState(() => _isSubmitting = false);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lỗi: ${e.toString()}"), backgroundColor: Colors.red));
    }
  }

  // ... (Giữ nguyên hàm _pickDate) ...
  Future<void> _pickDate(bool isStart) async {
    final initialDate = isStart
        ? (_ngayKhoiChieu ?? DateTime.now())
        : (_ngayKetThuc ?? (_ngayKhoiChieu ?? DateTime.now()));

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.redAccent,
              onPrimary: Colors.white,
              surface: Color(0xFF1E1E1E),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStart) _ngayKhoiChieu = picked;
        else _ngayKetThuc = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatDisplay = DateFormat('dd/MM/yyyy');

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(isEditMode ? "Sửa phim" : "Thêm phim mới", style: const TextStyle(color: Colors.white)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.redAccent))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Thông tin cơ bản"),
              _buildTextField(_tenCtrl, "Tên phim", validator: (v) => v!.isEmpty ? "Cần nhập tên" : null),
              Row(
                children: [
                  Expanded(child: _buildTextField(_thoiLuongCtrl, "Thời lượng (phút)", isNumber: true, validator: (v) => int.tryParse(v!) == null ? "Nhập số" : null)),
                  const SizedBox(width: 10),
                  Expanded(child: _buildTextField(_doTuoiCtrl, "Độ tuổi (VD: 18)", isNumber: true, validator: (v) => int.tryParse(v!) == null ? "Nhập số" : null)),
                ],
              ),

              const SizedBox(height: 10),
              _buildSectionTitle("Lịch chiếu & Trạng thái"),
              Row(
                children: [
                  Expanded(child: _buildDatePickerButton(label: "Ngày KC", selectedDate: _ngayKhoiChieu, onTap: () => _pickDate(true), formatter: dateFormatDisplay)),
                  const SizedBox(width: 10),
                  Expanded(child: _buildDatePickerButton(label: "Ngày KT", selectedDate: _ngayKetThuc, onTap: () => _pickDate(false), formatter: dateFormatDisplay)),
                ],
              ),
              const SizedBox(height: 15),

              // ✅ FIX 4: Sửa DropdownButtonFormField (Nguyên nhân crash chính)
              DropdownButtonFormField<MovieStatus>(
                value: _selectedStatus,
                dropdownColor: const Color(0xFF1E1E1E),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Trạng thái",
                  labelStyle: const TextStyle(color: Colors.grey),
                  filled: true, fillColor: const Color(0xFF1E1E1E),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                // ✅ HIỂN THỊ TẤT CẢ - Không dùng .where() để lọc nữa
                items: MovieStatus.values.map((e) {
                  return DropdownMenuItem(
                      value: e,
                      child: Text(_getStatusName(e)) // Hàm hiển thị tên đẹp hơn
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedStatus = val!),
              ),

              const SizedBox(height: 20),
              _buildSectionTitle("Chi tiết & Media"),
              _buildTextField(_daoDienCtrl, "Đạo diễn"),
              _buildTextField(_dienVienCtrl, "Diễn viên"),

              // ... (Phần UI Thể loại Genre giữ nguyên) ...
              const Text("Thể loại", style: TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade800),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hiển thị Chip
                    _selectedGenreIds.isEmpty
                        ? const Text("Chưa chọn thể loại nào", style: TextStyle(color: Colors.grey))
                        : Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _selectedGenreIds.map((id) {
                        // Tìm tên từ ID để hiển thị
                        String name = "Đang tải...";
                        try {
                          name = _apiGenres.firstWhere((g) => g.maGenre == id).tenGenre;
                        } catch (_) {}

                        return Chip(
                          label: Text(name, style: const TextStyle(color: Colors.white)),
                          backgroundColor: Colors.redAccent.withOpacity(0.8),
                          deleteIcon: const Icon(Icons.close, size: 18, color: Colors.white),
                          onDeleted: () {
                            setState(() {
                              _selectedGenreIds.remove(id);
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    // Nút thêm
                    InkWell(
                      onTap: _showMultiSelectGenres,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.redAccent),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, color: Colors.redAccent, size: 16),
                            SizedBox(width: 5),
                            Text("Thêm thể loại", style: TextStyle(color: Colors.redAccent)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              _buildTextField(_posterDocCtrl, "Link Poster Dọc (URL)"),
              _buildTextField(_posterNgangCtrl, "Link Banner Ngang (URL)"),
              _buildTextField(_trailerCtrl, "Link Trailer Youtube (URL)"),
              _buildTextField(_moTaCtrl, "Mô tả nội dung phim", maxLines: 4),

              const SizedBox(height: 30),
              // ... (Nút submit giữ nguyên) ...
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _isSubmitting ? null : _submitForm,
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(isEditMode ? "CẬP NHẬT" : "TẠO MỚI", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Helper để hiển thị tên trạng thái tiếng Việt
  String _getStatusName(MovieStatus status) {
    switch (status) {
      case MovieStatus.UPCOMING: return "Sắp chiếu (Upcoming)";
      case MovieStatus.NOW_SHOWING: return "Đang chiếu (Now Showing)";
      case MovieStatus.ENDED: return "Đã kết thúc (Ended)";
    }
  }

  // ... (Giữ nguyên _buildSectionTitle, _buildTextField, _buildDatePickerButton) ...
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 5),
      child: Text(title, style: const TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String label, {bool isNumber = false, int maxLines = 1, String? hint, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: ctrl,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          labelStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: const Color(0xFF1E1E1E),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.redAccent)),
        ),
      ),
    );
  }

  Widget _buildDatePickerButton({required String label, required DateTime? selectedDate, required VoidCallback onTap, required DateFormat formatter}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
        decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: selectedDate == null ? Colors.transparent : Colors.redAccent.withOpacity(0.5))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(selectedDate == null ? label : formatter.format(selectedDate),
                style: TextStyle(color: selectedDate == null ? Colors.grey : Colors.white, fontSize: 16)),
            const Icon(Icons.calendar_today, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }
}
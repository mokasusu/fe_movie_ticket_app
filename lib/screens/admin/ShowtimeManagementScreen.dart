import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Đảm bảo đường dẫn import đúng với dự án của bạn
import '../../../models/cinema.dart';
import '../../../models/room_model.dart';
import '../../../models/film_model.dart';
import '../../../models/showtime.dart';
import '../../services/api/cinema_service.dart';
import '../../services/api/film_service.dart';
import '../../services/api/showtime_service.dart';

class ShowtimeManagementScreen extends StatefulWidget {
  const ShowtimeManagementScreen({super.key});

  @override
  State<ShowtimeManagementScreen> createState() => _ShowtimeManagementScreenState();
}

class _ShowtimeManagementScreenState extends State<ShowtimeManagementScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý Lịch Chiếu"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.view_timeline), text: "Timeline"),
            Tab(icon: Icon(Icons.auto_awesome), text: "Xếp Tự Động"),
            Tab(icon: Icon(Icons.add_circle), text: "Tạo Thủ Công"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          TimelineViewTab(),       // Tab 1: Hiển thị đẹp
          AutoGenerateTab(),       // Tab 2: Gọi API Auto
          ManualCreateTab(),       // Tab 3: Form nhập liệu an toàn
        ],
      ),
    );
  }
}

// ============================================================================
// TAB 1: TIMELINE VIEW (GANTT CHART CHO RẠP)
// ============================================================================
class TimelineViewTab extends StatefulWidget {
  const TimelineViewTab({super.key});

  @override
  State<TimelineViewTab> createState() => _TimelineViewTabState();
}

class _TimelineViewTabState extends State<TimelineViewTab> {
  final CinemaService _cinemaService = CinemaService();
  final ShowtimeService _showtimeService = ShowtimeService();

  List<Cinema> cinemas = [];
  Cinema? selectedCinema;
  DateTime selectedDate = DateTime.now();
  List<Showtime> showtimes = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCinemas();
  }

  void _loadCinemas() async {
    try {
      final list = await CinemaService.fetchCinemas();
      if (mounted) {
        setState(() {
          cinemas = list;
          if (list.isNotEmpty) selectedCinema = list[0];
        });
        _loadShowtimes();
      }
    } catch (e) {
      print("Lỗi load rạp: $e");
    }
  }

  void _loadShowtimes() async {
    if (selectedCinema == null) return;

    setState(() => isLoading = true);

    try {
      // Gọi API lọc theo ngày và rạp từ Backend
      final list = await _showtimeService.getShowtimesByCinemaAndDate(
          selectedCinema!.maRap,
          selectedDate
      );

      if (mounted) {
        setState(() {
          showtimes = list;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Lỗi tải Timeline: $e");
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. Bộ lọc trên cùng
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: DropdownButton<Cinema>(
                  value: selectedCinema,
                  isExpanded: true, // ✅ Fix lỗi tràn màn hình
                  hint: const Text("Chọn rạp"),
                  items: cinemas.map((c) => DropdownMenuItem(
                    value: c,
                    child: Text(
                      c.tenRap,
                      overflow: TextOverflow.ellipsis, // ✅ Cắt chữ nếu quá dài
                      maxLines: 1,
                    ),
                  )).toList(),
                  onChanged: (val) {
                    setState(() => selectedCinema = val);
                    _loadShowtimes();
                  },
                ),
              ),
              const SizedBox(width: 10),
              TextButton.icon(
                icon: const Icon(Icons.calendar_month),
                label: Text(DateFormat('dd/MM').format(selectedDate)),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2024),
                    lastDate: DateTime(2026),
                  );
                  if (picked != null) {
                    setState(() => selectedDate = picked);
                    _loadShowtimes();
                  }
                },
              ),
              IconButton(icon: const Icon(Icons.refresh), onPressed: _loadShowtimes),
            ],
          ),
        ),
        const Divider(),

        // 2. Timeline Chính
        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildTimelineContent(),
        ),
      ],
    );
  }

  Widget _buildTimelineContent() {
    if (showtimes.isEmpty) return const Center(child: Text("Không có suất chiếu nào."));

    // Group suất chiếu theo Tên Phòng
    Map<String, List<Showtime>> roomGroups = {};
    for (var s in showtimes) {
      roomGroups.putIfAbsent(s.tenPhong, () => []).add(s);
    }

    const double hourWidth = 60.0;
    const int startHour = 8;
    const int endHour = 24;

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header giờ
            Row(
              children: [
                const SizedBox(width: 80),
                for (int i = startHour; i <= endHour; i++)
                  Container(
                    width: hourWidth,
                    alignment: Alignment.centerLeft,
                    child: Text("$i:00", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ),
              ],
            ),
            const SizedBox(height: 10),

            // Các hàng Phòng
            ...roomGroups.entries.map((entry) {
              String roomName = entry.key;
              List<Showtime> shows = entry.value;

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                height: 60,
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      alignment: Alignment.center,
                      color: Colors.blueGrey.shade50,
                      child: Text(roomName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), overflow: TextOverflow.ellipsis),
                    ),
                    Container(
                      width: (endHour - startHour) * hourWidth + 50,
                      color: Colors.grey.shade100,
                      child: Stack(
                        children: shows.map((s) {
                          double startOffset = (s.tgBatDau.hour - startHour) * hourWidth +
                              (s.tgBatDau.minute / 60) * hourWidth;
                          int duration = s.tgKetThuc!.difference(s.tgBatDau).inMinutes;
                          double width = (duration / 60) * hourWidth;

                          return Positioned(
                            left: startOffset,
                            top: 5,
                            bottom: 5,
                            width: width,
                            child: Tooltip(
                              message: "${s.tenPhim}\n${s.startTimeDisplay} - ${s.endTimeDisplay}",
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.blue.shade900),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                alignment: Alignment.center,
                                child: Text(
                                  s.tenPhim,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.white, fontSize: 10),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// TAB 2: AUTO GENERATE (GỌI API THÔNG MINH)
// ============================================================================
class AutoGenerateTab extends StatefulWidget {
  const AutoGenerateTab({super.key});

  @override
  State<AutoGenerateTab> createState() => _AutoGenerateTabState();
}

class _AutoGenerateTabState extends State<AutoGenerateTab> {
  final FilmService _filmService = FilmService();
  final ShowtimeService _showtimeService = ShowtimeService();

  List<FilmResponse> nowShowingFilms = [];
  List<Cinema> cinemas = [];

  Cinema? selectedCinema;
  List<String> selectedFilmIds = [];
  DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay openTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay closeTime = const TimeOfDay(hour: 23, minute: 0);
  int breakTime = 20;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final films = await _filmService.getNowShowingFilms();
    final cines = await CinemaService.fetchCinemas();
    if(mounted) {
      setState(() {
        nowShowingFilms = films;
        cinemas = cines;
        if (cines.isNotEmpty) selectedCinema = cines[0];
      });
    }
  }

  void _submit() async {
    if (selectedCinema == null || selectedFilmIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Vui lòng chọn Rạp và Phim!")));
      return;
    }

    String formatTime(TimeOfDay t) => "${t.hour.toString().padLeft(2,'0')}:${t.minute.toString().padLeft(2,'0')}:00";

    final body = {
      "dsMaPhim": selectedFilmIds,
      "maRap": selectedCinema!.maRap,
      "ngayChieu": DateFormat('yyyy-MM-dd').format(selectedDate),
      "gioMoCua": formatTime(openTime),
      "gioDongCua": formatTime(closeTime),
      "thoiGianNghi": breakTime,
    };

    try {
      showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));
      await _showtimeService.generateAutoShowtimes(body);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("✅ Xếp lịch thành công!"), backgroundColor: Colors.green));
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lỗi: ${e.toString()}"), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader("1. Chọn Rạp & Ngày"),
          DropdownButtonFormField<Cinema>(
            value: selectedCinema,
            isExpanded: true, // ✅ Fix lỗi tràn
            decoration: const InputDecoration(labelText: "Rạp chiếu"),
            items: cinemas.map((c) => DropdownMenuItem(
              value: c,
              child: Text(c.tenRap, overflow: TextOverflow.ellipsis),
            )).toList(),
            onChanged: (val) => setState(() => selectedCinema = val),
          ),
          const SizedBox(height: 10),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text("Ngày áp dụng"),
            trailing: Chip(label: Text(DateFormat('dd/MM/yyyy').format(selectedDate))),
            onTap: () async {
              final picked = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime.now(), lastDate: DateTime(2030));
              if (picked != null) setState(() => selectedDate = picked);
            },
          ),
          const Divider(height: 30),
          _buildHeader("2. Chọn Phim (Xếp So Le)"),
          Wrap(
            spacing: 8,
            children: nowShowingFilms.map((film) {
              final isSelected = selectedFilmIds.contains(film.maPhim);
              return FilterChip(
                label: Text(film.tenPhim),
                selected: isSelected,
                onSelected: (val) {
                  setState(() {
                    if (val) selectedFilmIds.add(film.maPhim);
                    else selectedFilmIds.remove(film.maPhim);
                  });
                },
              );
            }).toList(),
          ),
          const Divider(height: 30),
          _buildHeader("3. Cấu hình giờ"),
          Row(
            children: [
              Expanded(child: _buildTimePicker("Mở cửa", openTime, (t) => setState(() => openTime = t))),
              const SizedBox(width: 10),
              Expanded(child: _buildTimePicker("Đóng cửa", closeTime, (t) => setState(() => closeTime = t))),
            ],
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.flash_on),
              label: const Text("KÍCH HOẠT XẾP LỊCH"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white, padding: const EdgeInsets.all(16)),
              onPressed: _submit,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeader(String text) => Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue));

  Widget _buildTimePicker(String label, TimeOfDay time, Function(TimeOfDay) onPicked) {
    return InkWell(
      onTap: () async {
        final picked = await showTimePicker(context: context, initialTime: time);
        if (picked != null) onPicked(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        child: Text(time.format(context)),
      ),
    );
  }
}

// ============================================================================
// TAB 3: MANUAL CREATE (ĐÃ SỬA DÙNG BOTTOM SHEET ĐỂ TRÁNH LỖI OVERFLOW)
// ============================================================================
class ManualCreateTab extends StatefulWidget {
  const ManualCreateTab({super.key});

  @override
  State<ManualCreateTab> createState() => _ManualCreateTabState();
}

class _ManualCreateTabState extends State<ManualCreateTab> {
  final FilmService _filmService = FilmService();
  final ShowtimeService _showtimeService = ShowtimeService();

  List<FilmResponse> films = [];
  List<Cinema> cinemas = [];
  List<Room> rooms = [];

  String? selectedFilmId;
  Cinema? selectedCinema;
  int? selectedRoomId;
  DateTime startDateTime = DateTime.now().add(const Duration(hours: 1));

  // Controllers để hiển thị Text lên Form
  final TextEditingController _filmController = TextEditingController();
  final TextEditingController _cinemaController = TextEditingController();
  final TextEditingController _roomController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInitData();
  }

  @override
  void dispose() {
    _filmController.dispose();
    _cinemaController.dispose();
    _roomController.dispose();
    super.dispose();
  }

  void _loadInitData() async {
    final fs = await _filmService.getNowShowingFilms();
    final cs = await CinemaService.fetchCinemas();
    if(mounted) {
      setState(() {
        films = fs;
        cinemas = cs;
      });
    }
  }

  // Hàm hiển thị danh sách chọn (Modal Bottom Sheet) - Giải pháp triệt để cho overflow
  void _showSelectionSheet<T>({
    required String title,
    required List<T> items,
    required String Function(T) getLabel,
    required Function(T) onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          maxChildSize: 0.9,
          minChildSize: 0.3,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5))),
                  child: Center(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
                ),
                Expanded(
                  child: items.isEmpty
                      ? const Center(child: Text("Không có dữ liệu"))
                      : ListView.separated(
                    controller: scrollController,
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ListTile(
                        title: Text(getLabel(item)),
                        onTap: () {
                          onSelected(item);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _onCinemaChanged(Cinema c) async {
    setState(() {
      selectedCinema = c;
      selectedRoomId = null;
      rooms = [];
      _roomController.clear();
      _cinemaController.text = c.tenRap;
    });

    try {
      // Gọi API lấy phòng theo rạp
      final rs = await CinemaService.getRoomsByCinema(c.maRap);
      if(mounted) {
        setState(() {
          rooms = rs;
          if (rooms.isNotEmpty) {
            // Tự động chọn phòng đầu tiên nếu thích, hoặc để null
            // selectedRoomId = rooms[0].maPhong;
            // _roomController.text = rooms[0].tenPhong;
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lỗi tải phòng: $e")));
    }
  }

  void _submit() async {
    if (selectedFilmId == null || selectedCinema == null || selectedRoomId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Nhập đủ thông tin!")));
      return;
    }

    final body = {
      "maPhim": selectedFilmId,
      "maRap": selectedCinema!.maRap,
      "maPhong": selectedRoomId,
      "tgBatDau": startDateTime.toIso8601String(),
    };

    try {
      await _showtimeService.createManualShowtime(body);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("✅ Tạo thành công!"), backgroundColor: Colors.green));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lỗi: $e"), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 1. CHỌN PHIM
          TextFormField(
            controller: _filmController,
            readOnly: true,
            decoration: const InputDecoration(labelText: "Chọn Phim", border: OutlineInputBorder(), suffixIcon: Icon(Icons.movie)),
            onTap: () => _showSelectionSheet<FilmResponse>(
              title: "Danh sách Phim",
              items: films,
              getLabel: (f) => f.tenPhim,
              onSelected: (f) => setState(() {
                selectedFilmId = f.maPhim;
                _filmController.text = f.tenPhim;
              }),
            ),
          ),
          const SizedBox(height: 15),

          // 2. CHỌN RẠP
          TextFormField(
            controller: _cinemaController,
            readOnly: true,
            decoration: const InputDecoration(labelText: "Chọn Rạp", border: OutlineInputBorder(), suffixIcon: Icon(Icons.store)),
            onTap: () => _showSelectionSheet<Cinema>(
              title: "Danh sách Rạp",
              items: cinemas,
              getLabel: (c) => c.tenRap,
              onSelected: (c) => _onCinemaChanged(c),
            ),
          ),
          const SizedBox(height: 15),

          // 3. CHỌN PHÒNG
          TextFormField(
            controller: _roomController,
            readOnly: true,
            decoration: const InputDecoration(labelText: "Chọn Phòng", border: OutlineInputBorder(), suffixIcon: Icon(Icons.meeting_room)),
            onTap: () {
              if (selectedCinema == null) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Vui lòng chọn Rạp trước")));
                return;
              }
              _showSelectionSheet<Room>(
                title: "Danh sách Phòng",
                items: rooms,
                getLabel: (r) => "${r.tenPhong} (${r.soGhe} ghế)",
                onSelected: (r) => setState(() {
                  selectedRoomId = r.maPhong;
                  _roomController.text = r.tenPhong;
                }),
              );
            },
          ),
          const SizedBox(height: 15),

          // 4. CHỌN THỜI GIAN
          ListTile(
            title: const Text("Thời gian bắt đầu"),
            subtitle: Text(DateFormat('dd/MM/yyyy HH:mm').format(startDateTime)),
            trailing: const Icon(Icons.access_time),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: Colors.grey)),
            onTap: () async {
              final d = await showDatePicker(context: context, initialDate: startDateTime, firstDate: DateTime.now(), lastDate: DateTime(2030));
              if (d != null) {
                final t = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(startDateTime));
                if (t != null) {
                  setState(() => startDateTime = DateTime(d.year, d.month, d.day, t.hour, t.minute));
                }
              }
            },
          ),

          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _submit,
              child: const Text("TẠO SUẤT CHIẾU"),
            ),
          )
        ],
      ),
    );
  }
}
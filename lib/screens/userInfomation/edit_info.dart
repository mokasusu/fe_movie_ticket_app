import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/colors.dart';
import '../../models/user.dart';
import '../../services/api/user_service.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _dobController;
  String? _selectedGender;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _dobController = TextEditingController();
    _selectedGender = null;
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    final user = await UserService.getMyInfo();
    final u = user ?? widget.user;
    setState(() {
      _nameController.text = u.hoTen ?? "";
      _emailController.text = u.email ?? "";
      _dobController.text = u.ngaySinh ?? "";
      _selectedGender = (u.gioiTinh.toLowerCase() == 'nam') ? 'Nam' : 'Nữ';
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  // Hàm chọn ngày sinh
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          //datetime picker
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.gold,
              onPrimary: Colors.black,
              surface: AppColors.bgSecondary,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        // Format lại thành dd/MM/yyyy để hiển thị và gửi lên server
        _dobController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  // Hàm Lưu thay đổi
  Future<void> _handleSave() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Vui lòng nhập họ tên")));
      return;
    }

    setState(() => _isLoading = true);

    // Chuẩn bị data
    Map<String, dynamic> updateData = {
      "hoTen": _nameController.text,
      "gioiTinh": _selectedGender,
      "ngaySinh": _dobController.text,
    };

    final success = await UserService.updateUser(widget.user.id, updateData);

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        // Trả về true để màn hình trước biết là cần reload lại data
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Cập nhật thành công!"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Cập nhật thất bại. Vui lòng thử lại."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Chỉnh sửa hồ sơ",
          style: TextStyle(color: AppColors.textPrimary),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _handleSave,
            child: _isLoading
                ? const SizedBox(
                    width: 15,
                    height: 15,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.gold,
                    ),
                  )
                : const Text(
                    "LƯU",
                    style: TextStyle(
                      color: AppColors.gold,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 30),

            // 1. Các trường thông tin
            _buildTextField(
              label: "Họ và tên",
              controller: _nameController,
              icon: Icons.person_outline,
            ),

            const SizedBox(height: 20),

            // Email bị disable (Read-only)
            _buildTextField(
              label: "Email",
              controller: _emailController,
              icon: Icons.email_outlined,
              isReadOnly: true,
            ),

            const SizedBox(height: 20),

            // Giới tính
            Row(
              children: [
                const Icon(Icons.wc, color: AppColors.textSecondary),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedGender,
                    decoration: const InputDecoration(
                      labelText: "Giới tính",
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Nam', child: Text('Nam')),
                      DropdownMenuItem(value: 'Nữ', child: Text('Nữ')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Ngày sinh (Bấm vào hiện lịch)
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                // Chặn bàn phím hiện lên
                child: _buildTextField(
                  label: "Ngày sinh",
                  controller: _dobController,
                  icon: Icons.calendar_today_outlined,
                  isReadOnly: false,
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Helper tạo Input Field chuẩn Dark Theme
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool isReadOnly = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: isReadOnly,
          keyboardType: keyboardType,
          style: TextStyle(
            color: isReadOnly
                ? AppColors.textMuted
                : AppColors.textPrimary, // Nếu readonly thì màu tối hơn
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.bgSecondary,
            prefixIcon: Icon(
              icon,
              color: isReadOnly ? AppColors.disabled : AppColors.gold,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.gold, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ],
    );
  }
}

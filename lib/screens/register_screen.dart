import 'package:flutter/material.dart';
import '../services/api/user_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // Các controller tương ứng với các field
  final TextEditingController _hoTenController = TextEditingController();
  String? _selectedGender;
  final TextEditingController _ngaySinhController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _matKhauController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đăng ký tài khoản"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Họ tên
              TextFormField(
                controller: _hoTenController,
                decoration: const InputDecoration(labelText: "Họ và tên"),
                validator: (value) =>
                    value!.isEmpty ? "Không được để trống" : null,
              ),

              // Giới tính Dropdown
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: const InputDecoration(labelText: "Giới tính"),
                items: const [
                  DropdownMenuItem(value: "Nam", child: Text("Nam")),
                  DropdownMenuItem(value: "Nữ", child: Text("Nữ")),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
                validator: (value) => value == null || value.isEmpty
                    ? "Không được để trống"
                    : null,
              ),

              // Ngày sinh DatePicker
              TextFormField(
                controller: _ngaySinhController,
                readOnly: true,
                decoration: const InputDecoration(labelText: "Ngày sinh"),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().subtract(
                      const Duration(days: 365 * 18),
                    ),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                    locale: const Locale('vi', 'VN'),
                  );
                  if (pickedDate != null) {
                    _ngaySinhController.text =
                        "${pickedDate.year.toString().padLeft(4, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                  }
                },
                validator: (value) =>
                    value!.isEmpty ? "Không được để trống" : null,
              ),

              // Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (value) =>
                    value!.isEmpty ? "Không được để trống" : null,
              ),

              // Mật khẩu
              TextFormField(
                controller: _matKhauController,
                decoration: const InputDecoration(labelText: "Mật khẩu"),
                obscureText: true,
                validator: (value) =>
                    value!.isEmpty ? "Không được để trống" : null,
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: isLoading ? null : _registerUser,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Đăng ký"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final userData = {
      "hoTen": _hoTenController.text,
      "gioiTinh": _selectedGender ?? '',
      "ngaySinh": _ngaySinhController.text.trim(),
      "email": _emailController.text,
      "matKhau": _matKhauController.text, // mặc định rỗng
    };

    final success = await UserService.registerUser(userData);

    setState(() => isLoading = false);

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Đăng ký thành công")));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Đăng ký thất bại")));
    }
  }
}

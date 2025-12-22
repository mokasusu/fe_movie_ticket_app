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
  final TextEditingController _gioiTinhController = TextEditingController();
  final TextEditingController _ngaySinhController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _matKhauController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Đăng ký tài khoản"),
        centerTitle: true,
      ),
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
                validator: (value) => value!.isEmpty ? "Không được để trống" : null,
              ),

              // Giới tính
              TextFormField(
                controller: _gioiTinhController,
                decoration: const InputDecoration(labelText: "Giới tính"),
                validator: (value) => value!.isEmpty ? "Không được để trống" : null,
              ),

              // Ngày sinh
              TextFormField(
                controller: _ngaySinhController,
                decoration: const InputDecoration(labelText: "Ngày sinh (yyyy-MM-dd)"),
                validator: (value) => value!.isEmpty ? "Không được để trống" : null,
              ),

              // Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (value) => value!.isEmpty ? "Không được để trống" : null,
              ),

              // Mật khẩu
              TextFormField(
                controller: _matKhauController,
                decoration: const InputDecoration(labelText: "Mật khẩu"),
                obscureText: true,
                validator: (value) => value!.isEmpty ? "Không được để trống" : null,
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
      "gioiTinh": _gioiTinhController.text,
      "ngaySinh": _ngaySinhController.text.trim(),
      "email": _emailController.text,
      "matKhau": _matKhauController.text,// mặc định rỗng
    };

    final success = await UserService.registerUser(userData);

    setState(() => isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đăng ký thành công")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đăng ký thất bại")),
      );
    }
  }
}

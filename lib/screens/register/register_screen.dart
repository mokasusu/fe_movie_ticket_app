// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import '../models/user_request.dart';
// import '../services/user_service.dart';
//
// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({Key? key}) : super(key: key);
//
//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }
//
// class _RegisterScreenState extends State<RegisterScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final UserService _userService = UserService();
//
//   final TextEditingController _hoTenController = TextEditingController();
//   final TextEditingController _gioiTinhController = TextEditingController();
//   final TextEditingController _ngaySinhController = TextEditingController();
//   final TextEditingController _sdtController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _matKhauController = TextEditingController();
//
//   File? _avatarImage;
//
//   final ImagePicker _picker = ImagePicker();
//
//   Future<void> _pickImage() async {
//     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//     if (image != null) {
//       setState(() {
//         _avatarImage = File(image.path);
//       });
//       // TODO: Upload image to drive/storage nếu cần và lấy URL
//     }
//   }
//
//   void _submit() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     UserRequest request = UserRequest(
//       hoTen: _hoTenController.text.trim(),
//       gioiTinh: _gioiTinhController.text.trim(),
//       ngaySinh: _ngaySinhController.text.trim(),
//       sdt: _sdtController.text.trim(),
//       email: _emailController.text.trim(),
//       matKhau: _matKhauController.text.trim(),
//       anhURL: null, // Nếu đã upload image, gán URL ở đây
//     );
//
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => const Center(child: CircularProgressIndicator()),
//     );
//
//     try {
//       // Gọi API tạo user
//       final result = await UserService.createUser(request);
//
//       Navigator.of(context).pop(); // Đóng loading
//
//       // Nếu tới đây nghĩa là statusCode = 200 hoặc 201 (createUser đã kiểm tra)
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Đăng ký thành công!')),
//       );
//
//       Navigator.of(context).pop(); // Quay về login
//
//     } catch (e) {
//       Navigator.of(context).pop(); // Đóng loading nếu lỗi
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Lỗi: $e')),
//       );
//     }
//
//   }
//
//   @override
//   void dispose() {
//     _hoTenController.dispose();
//     _gioiTinhController.dispose();
//     _ngaySinhController.dispose();
//     _sdtController.dispose();
//     _emailController.dispose();
//     _matKhauController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Đăng ký')),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               GestureDetector(
//                 onTap: _pickImage,
//                 child: CircleAvatar(
//                   radius: 50,
//                   backgroundImage: _avatarImage != null
//                       ? FileImage(_avatarImage!)
//                       : null,
//                   child: _avatarImage == null
//                       ? const Icon(Icons.add_a_photo, size: 40)
//                       : null,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _hoTenController,
//                 decoration: const InputDecoration(labelText: 'Họ và tên'),
//                 validator: (v) => v == null || v.isEmpty ? 'Nhập họ tên' : null,
//               ),
//               const SizedBox(height: 8),
//               TextFormField(
//                 controller: _gioiTinhController,
//                 decoration: const InputDecoration(labelText: 'Giới tính'),
//                 validator: (v) => v == null || v.isEmpty ? 'Nhập giới tính' : null,
//               ),
//               const SizedBox(height: 8),
//               TextFormField(
//                 controller: _ngaySinhController,
//                 decoration: const InputDecoration(labelText: 'Ngày sinh (yyyy-mm-dd)'),
//                 validator: (v) => v == null || v.isEmpty ? 'Nhập ngày sinh' : null,
//               ),
//               const SizedBox(height: 8),
//               TextFormField(
//                 controller: _sdtController,
//                 keyboardType: TextInputType.phone,
//                 decoration: const InputDecoration(labelText: 'Số điện thoại'),
//                 validator: (v) => v == null || v.isEmpty ? 'Nhập số điện thoại' : null,
//               ),
//               const SizedBox(height: 8),
//               TextFormField(
//                 controller: _emailController,
//                 keyboardType: TextInputType.emailAddress,
//                 decoration: const InputDecoration(labelText: 'Email'),
//                 validator: (v) {
//                   if (v == null || v.isEmpty) return 'Nhập email';
//                   if (!RegExp(r'\S+@\S+\.\S+').hasMatch(v)) return 'Email không hợp lệ';
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 8),
//               TextFormField(
//                 controller: _matKhauController,
//                 obscureText: true,
//                 decoration: const InputDecoration(labelText: 'Mật khẩu'),
//                 validator: (v) {
//                   if (v == null || v.isEmpty) return 'Nhập mật khẩu';
//                   if (v.length < 6) return 'Mật khẩu ít nhất 6 ký tự';
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 24),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: _submit,
//                   child: const Text('Đăng ký'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import '../../services/api/user_service.dart';

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
  final TextEditingController _sdtController = TextEditingController();
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

              // SĐT
              TextFormField(
                controller: _sdtController,
                decoration: const InputDecoration(labelText: "Số điện thoại"),
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
      "sdt": _sdtController.text,
      "email": _emailController.text,
      "matKhau": _matKhauController.text,
      "anhURL": "", // mặc định rỗng
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
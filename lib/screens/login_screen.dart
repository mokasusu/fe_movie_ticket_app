import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:home/services/auth/auth_service.dart';
import 'package:home/utils/storage.dart';

// Import màn hình đích
import '../screens/admin/admin_screen.dart';
// import '../screens/home/home_screen.dart';
import '../screens/forgot_password_screen.dart';
import '../screens/register_screen.dart';
import '../../widgets/bottomBar/bottom_nav_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false; // Biến trạng thái loading

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- HÀM XỬ LÝ ĐĂNG NHẬP (ĐÃ TỐI ƯU AN TOÀN) ---
  Future<void> _login() async {
    // 1. Validate Form
    if (!_formKey.currentState!.validate()) return;

    // 2. Bắt đầu xoay loading
    setState(() => _isLoading = true);

    try {
      // 3. Gọi API Login
      final bool success = await AuthService.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!mounted) return; // Kiểm tra màn hình còn tồn tại không

      if (success) {
        // --- XỬ LÝ KHI ĐĂNG NHẬP THÀNH CÔNG ---

        // A. Lấy token từ Storage (AuthService đã lưu rồi)
        final token = await Storage.getToken();

        if (token != null) {
          // B. Giải mã Token để xem Role
          Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
          print("🔍 Thông tin Token: $decodedToken");

          // C. Kiểm tra Role (Key thường là "scope" hoặc "roles")
          // Spring Security mặc định thường trả về chuỗi "SCOPE_ROLE_ADMIN" hoặc "ROLE_ADMIN"
          String roleData = decodedToken["scope"] ?? "";

          if (roleData.contains("ADMIN")) {
            // => CHUYỂN ĐẾN TRANG ADMIN
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const AdminHomeScreen()),
            );
          } else {
            // => CHUYỂN ĐẾN TRANG USER
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const BottomNavBar()),
            );
          }
        print("✅ Đăng nhập thành công");
        }
      } else {
        // --- XỬ LÝ KHI SAI USER/PASS ---
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email hoặc mật khẩu không đúng"), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      // --- XỬ LÝ KHI CÓ LỖI (Mạng, Code, Server sập...) ---
      print("🔥 Lỗi đăng nhập: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi hệ thống: $e"), backgroundColor: Colors.red),
      );
    } finally {
      // 4. KẾT THÚC: Tắt loading dù thành công hay thất bại (Tránh treo app)
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Ảnh header
              SizedBox(
                height: 250,
                width: double.infinity,
                child: Image.asset(
                  'assets/images/movie_intro.png', // Đảm bảo bạn có ảnh này hoặc thay bằng Icon
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Center(child: Icon(Icons.movie, size: 100, color: Colors.redAccent)),
                ),
              ),
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text("🎟️ Đăng nhập", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 30),

                      // Email Field
                      TextFormField(
                        controller: _emailController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: const TextStyle(color: Colors.grey),
                          prefixIcon: const Icon(Icons.email, color: Colors.redAccent),
                          filled: true,
                          fillColor: Colors.grey[900],
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.redAccent)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Vui lòng nhập email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Password Field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Mật khẩu",
                          labelStyle: const TextStyle(color: Colors.grey),
                          prefixIcon: const Icon(Icons.lock, color: Colors.redAccent),
                          suffixIcon: IconButton(
                            icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
                            onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                          ),
                          filled: true,
                          fillColor: Colors.grey[900],
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.redAccent)),
                        ),
                        validator: (value) => (value == null || value.isEmpty) ? 'Vui lòng nhập mật khẩu' : null,
                      ),
                      const SizedBox(height: 40),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _login, // Disable nút khi đang load
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            disabledBackgroundColor: Colors.redAccent.withOpacity(0.5),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                              height: 20, width: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                          )
                              : const Text("Đăng nhập", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Forgot Pass
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ForgotPasswordScreen())),
                        child: const Text("Quên mật khẩu?", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 20),

                      // Register Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Chưa có tài khoản? ", style: TextStyle(color: Colors.grey)),
                          GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
                            child: const Text("Đăng ký ngay", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
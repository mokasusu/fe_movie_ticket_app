import 'package:flutter/material.dart';
import '../../services/auth/auth_service.dart';
import '../register/register_screen.dart';
import '../../widgets/bottomNavBar/bottom_nav_bar.dart';
import 'dart:async';

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
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
  if (_formKey.currentState!.validate()) {
    setState(() => _isLoading = true);

    try {
      bool result = await AuthService.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException("Timeout");
        },
      );

      setState(() => _isLoading = false);

      if (result == true) {
        print("Đăng nhập thành công!");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavBar()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email hoặc mật khẩu không đúng!")),
        );
      }

    } on TimeoutException catch (_) {
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lỗi mạng, vui lòng thử lại!")),
      );
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
              SizedBox(
                height: 250,
                width: double.infinity,
                // child: Image.asset(
                //   'assets/images/movie_intro.png',
                //   fit: BoxFit.cover,
                // ),
                child: Icon(
                  Icons.movie,
                  color: Colors.redAccent,
                  size: 120,
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text(
                        "🎟️ Đăng nhập",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Email
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: const TextStyle(color: Colors.grey),
                          prefixIcon: const Icon(Icons.email, color: Colors.redAccent),
                          filled: true,
                          fillColor: Colors.grey[900],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Vui lòng nhập email';
                          if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                            return 'Email không hợp lệ';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Password
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Mật khẩu",
                          labelStyle: const TextStyle(color: Colors.grey),
                          prefixIcon: const Icon(Icons.lock, color: Colors.redAccent),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: Colors.grey[900],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập mật khẩu';
                          }
                          return null; // hợp lệ
                        },
                      ),

                      const SizedBox(height: 40),

                      // Button Login
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                            "Đăng nhập",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Register link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Chưa có tài khoản? ",
                              style: TextStyle(color: Colors.grey)),

                          // const SizedBox(height: 30),
                          // SizedBox(
                          //   width: double.infinity,
                          //   child: ElevatedButton.icon(
                          //     onPressed: () async {
                          //       // final data = await GoogleSignInService.signInWithGoogle();
                          //       //
                          //       // if (data != null) {
                          //       //   ScaffoldMessenger.of(context).showSnackBar(
                          //       //     const SnackBar(content: Text("Đăng nhập Google thành công!")),
                          //       //   );
                          //       //
                          //       //   print("GOOGLE USER DATA: $data");
                          //       //
                          //       //   // TODO: Lưu token / user info vào SharedPreferences
                          //       //   // TODO: Navigate sang HomeScreen
                          //       // } else {
                          //       //   ScaffoldMessenger.of(context).showSnackBar(
                          //       //     const SnackBar(content: Text("Đăng nhập Google thất bại!")),
                          //       //   );
                          //       // }
                          //     },
                          //     icon: Image.asset(
                          //       "assets/images/google.png",
                          //       height: 24,
                          //       width: 24,
                          //     ),
                          //     label: const Text(
                          //       "Đăng nhập với Google",
                          //       style: TextStyle(color: Colors.white, fontSize: 16),
                          //     ),
                          //     style: ElevatedButton.styleFrom(
                          //       backgroundColor: Colors.blueAccent,
                          //       padding: const EdgeInsets.symmetric(vertical: 14),
                          //       shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(12),
                          //       ),
                          //     ),
                          //   ),
                          // ),

                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const RegisterScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Đăng ký ngay",
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
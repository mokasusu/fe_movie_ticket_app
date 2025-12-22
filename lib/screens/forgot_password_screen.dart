import 'package:flutter/material.dart';
import '../services/auth/auth_api.dart';
import 'otp_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  bool loading = false;

  Future<void> sendOtp() async {
    setState(() => loading = true);

    bool ok = await AuthApi.requestOtp(emailController.text.trim());

    setState(() => loading = false);

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đã gửi OTP vào email của bạn")),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpVerifyScreen(email: emailController.text.trim()),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email không tồn tại")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quên mật khẩu")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            SizedBox(height: 20),
            loading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: sendOtp,
              child: Text("Gửi OTP"),
            ),
          ],
        ),
      ),
    );
  }
}

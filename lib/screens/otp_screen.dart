import 'package:flutter/material.dart';
import '../services/auth/auth_api.dart';
import 'ResetPasswordScreen.dart';

class OtpVerifyScreen extends StatefulWidget {
  final String email;
  OtpVerifyScreen({required this.email});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  TextEditingController otpController = TextEditingController();
  bool loading = false;

  Future<void> verify() async {
    setState(() => loading = true);

    bool ok = await AuthApi.verifyOtp(widget.email, otpController.text.trim());

    setState(() => loading = false);

    if (ok) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              ResetPasswordScreen(email: widget.email, otp: otpController.text.trim()),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("OTP không đúng hoặc đã hết hạn")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Xác thực OTP")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text("OTP đã gửi đến email ${widget.email}"),
            SizedBox(height: 20),
            TextField(
              controller: otpController,
              decoration: InputDecoration(labelText: "Nhập OTP"),
            ),
            SizedBox(height: 20),
            loading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: verify,
              child: Text("Xác nhận OTP"),
            )
          ],
        ),
      ),
    );
  }
}

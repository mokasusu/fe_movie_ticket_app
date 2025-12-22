import 'package:flutter/material.dart';
import '../services/auth/auth_api.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;

  ResetPasswordScreen({required this.email, required this.otp});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController newPassController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  bool loading = false;

  Future<void> resetPass() async {
    if (newPassController.text != confirmPassController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Mật khẩu không trùng nhau")),
      );
      return;
    }

    setState(() => loading = true);

    bool ok = await AuthApi.resetPassword(
      widget.email,
      widget.otp,
      newPassController.text.trim(),
    );

    setState(() => loading = false);

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đổi mật khẩu thành công")),
      );

      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi không xác định")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Đặt lại mật khẩu")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: newPassController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Mật khẩu mới"),
            ),
            TextField(
              controller: confirmPassController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Nhập lại mật khẩu"),
            ),
            SizedBox(height: 20),
            loading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: resetPass,
              child: Text("Đổi mật khẩu"),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../services/api/user_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  // Controller để lấy dữ liệu nhập vào
  final _currentPassController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _currentPassController.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  // Xử lý logic đổi mật khẩu
  Future<void> _handleSubmit() async {
    // 1. Validate cơ bản
    if (_newPassController.text.length < 6) {
      setState(() => _errorMessage = "Mật khẩu mới phải có ít nhất 6 ký tự");
      return;
    }
    if (_newPassController.text != _confirmPassController.text) {
      setState(() => _errorMessage = "Mật khẩu xác nhận không khớp");
      return;
    }
    
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    // try {
    //   // API đổi mật khẩu
    //   bool success = await UserService.changePassword(
    //     currentPassword: _currentPassController.text,
    //     newPassword: _newPassController.text,
    //   );
    //   await Future.delayed(const Duration(seconds: 2));

    //   if (!mounted) return;

    //   if (success) {
    //     _showSuccessDialog();
    //   } else {
    //     setState(() => _errorMessage = "Mật khẩu hiện tại không đúng");
    //   }
    // } catch (e) {
    //   setState(() => _errorMessage = "Lỗi kết nối: $e");
    // } finally {
    //   if (mounted) setState(() => _isLoading = false);
    // }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.bgSecondary,
        title: const Text("Thành công", style: TextStyle(color: AppColors.textPrimary)),
        content: const Text("Mật khẩu đã được cập nhật. Vui lòng đăng nhập lại.", 
          style: TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Điều hướng về trang Login
              Navigator.of(context).pop(); // Đóng dialog
              Navigator.of(context).pop(); // Đóng màn hình đổi pass
            },
            child: const Text("Đồng ý", style: TextStyle(color: AppColors.gold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Đổi mật khẩu", style: TextStyle(color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tạo mật khẩu mới cho tài khoản của bạn để bảo mật tốt hơn.",
              style: TextStyle(color: AppColors.textMuted, fontSize: 14),
            ),
            const SizedBox(height: 30),

            // --- FORM INPUT ---
            _buildPasswordField(
              label: "Mật khẩu hiện tại",
              controller: _currentPassController,
              obscureText: _obscureCurrent,
              onToggleVisibility: () => setState(() => _obscureCurrent = !_obscureCurrent),
            ),
            const SizedBox(height: 20),
            
            _buildPasswordField(
              label: "Mật khẩu mới",
              controller: _newPassController,
              obscureText: _obscureNew,
              onToggleVisibility: () => setState(() => _obscureNew = !_obscureNew),
            ),
            const SizedBox(height: 20),
            
            _buildPasswordField(
              label: "Xác nhận mật khẩu mới",
              controller: _confirmPassController,
              obscureText: _obscureConfirm,
              onToggleVisibility: () => setState(() => _obscureConfirm = !_obscureConfirm),
            ),

            // --- HIỂN THỊ LỖI ---
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.red, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: AppColors.red, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 40),

            // --- NÚT XÁC NHẬN ---
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold, // Màu chủ đạo
                  foregroundColor: Colors.black,   // Chữ đen trên nền vàng cho dễ đọc
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 5,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20, width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                      )
                    : const Text(
                        "Cập nhật mật khẩu",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget con tái sử dụng cho Input Password
  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          style: const TextStyle(color: AppColors.textPrimary),
          cursorColor: AppColors.gold,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.bgSecondary, // Nền input tối hơn nền chính
            hintText: "••••••••",
            hintStyle: TextStyle(color: AppColors.textMuted.withOpacity(0.5)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.gold, width: 1), // Viền vàng khi focus
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: AppColors.textMuted,
              ),
              onPressed: onToggleVisibility,
            ),
          ),
        ),
      ],
    );
  }
}
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateHelper {
  // ⚠️ THAY LINK RAW CỦA BẠN VÀO ĐÂY:
  static const String configUrl = "https://raw.githubusercontent.com/mokasusu/movie_ticket_app_images/refs/heads/main/cinemode_version.json"; 

  static Future<void> checkForUpdate(BuildContext context) async {
    try {
      // Lấy phiên bản hiện tại
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;
      print("Phiên bản hiện tại: $currentVersion");

      // Tải file cấu hình từ GitHub
      final response = await http.get(Uri.parse(configUrl));

      if (response.statusCode == 200) {
        // Giải mã JSON
        final Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        
        String latestVersion = data['latest_version'];
        String downloadUrl = data['download_url'];
        String message = data['message'];
        bool isForce = data['force_update'] ?? false;

        print("Phiên bản trên GitHub: $latestVersion");

        // 3. So sánh: Nếu khác nhau thì báo update
        if (currentVersion != latestVersion) {
          _showUpdateDialog(context, latestVersion, message, downloadUrl, isForce);
        }
      }
    } catch (e) {
      print("Lỗi kiểm tra update: $e");
    }
  }

  // Hàm hiện bảng thông báo
  static void _showUpdateDialog(BuildContext context, String version, String message, String url, bool isForce) {
    showDialog(
      context: context,
      barrierDismissible: !isForce,
      builder: (context) => AlertDialog(
        title: Text("Cập nhật mới ($version)"),
        content: Text(message),
        actions: [
          // Nếu không bắt buộc thì hiện nút "Để sau"
          if (!isForce)
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Để sau", style: TextStyle(color: Colors.grey)),
            ),
          
          // Nút cập nhật
          ElevatedButton(
            onPressed: () async {
              final Uri uri = Uri.parse(url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
                print("Lỗi không mở được link");
              }
            },
            child: Text("Cập nhật ngay"),
          ),
        ],
      ),
    );
  }
}
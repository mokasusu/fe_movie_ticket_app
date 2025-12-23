import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsDetailScreen extends StatefulWidget {
  final String newsUrl;
  final String title;

  const NewsDetailScreen({
    super.key,
    required this.newsUrl,
    required this.title,
  });

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  late final WebViewController _controller;
  bool isLoading = true; // Biến trạng thái để hiện loading

  @override
  void initState() {
    super.initState();
    // Khởi tạo WebViewController
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() { isLoading = true; });
          },
          onPageFinished: (String url) {
            setState(() { isLoading = false; });
          },
          onWebResourceError: (error) {
            debugPrint("Lỗi tải trang: ${error.description}");
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.newsUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 16),
          overflow: TextOverflow.ellipsis, // Cắt bớt nếu tiêu đề quá dài
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Stack(
        children: [
          // 1. Hiển thị nội dung Web
          WebViewWidget(controller: _controller),
          
          // 2. Hiển thị vòng xoay khi đang tải
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(color: Colors.orange),
            ),
        ],
      ),
    );
  }
}
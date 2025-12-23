import 'package:flutter/material.dart';
import 'news_detail.dart';
import '../../theme/colors.dart';
import '../../models/news.dart';

// --- Màn hình Danh Sách ---
class NewsListScreen extends StatelessWidget {
  const NewsListScreen({super.key});

  static List<News> dummyNews = [
    News(
      id: 1,
      title:
          'Avatar 3 mở màn bùng nổ với 345 triệu USD toàn cầu nhưng vẫn thua phần 2',
      ngayDang: DateTime.parse('2025-12-22'),
      imageUrl: 'assets/images/news1.jpg',
      url:
          'https://tuoitre.vn/avatar-3-mo-man-bung-no-voi-345-trieu-usd-toan-cau-nhung-van-thua-phan-2-20251222083910098.htm',
    ),
    News(
      id: 2,
      title:
          'Jujutsu Kaisen dẫn đầu phòng vé Nhật, vượt qua Chainsaw Man và Thanh Gươm Diệt Quỷ',
      ngayDang: DateTime.parse('2025-11-12'),
      imageUrl: 'assets/images/news2.jpg',
      url:
          'https://tuoitre.vn/jujutsu-kaisen-dan-dau-phong-ve-nhat-vuot-qua-chainsaw-man-va-thanh-guom-diet-quy-20251112182735028.htm',
    ),
    News(
      id: 3,
      title: 'Nhận voucher 30.000đ khi thanh toán qua MOMO',
      ngayDang: DateTime.parse('2025-12-23'),
      imageUrl: 'assets/images/news3.jpg',
      url: 'https://chieuphimquocgia.com.vn/promotions/9546',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tin Tức",
          style: TextStyle(
            fontSize: 20,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.bgSecondary,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      backgroundColor: AppColors.bgPrimary,
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: dummyNews.length,
        separatorBuilder: (ctx, index) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final news = dummyNews[index];
          return _buildNewsItem(context, news, isSelected: false);
        },
      ),
    );
  }

  // Widget hiển thị từng dòng tin tức
  Widget _buildNewsItem(
    BuildContext context,
    News news, {
    bool isSelected = false,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                NewsDetailScreen(newsUrl: news.url, title: news.title),
          ),
        );
      },
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          color: AppColors.bgElevated,
          borderRadius: BorderRadius.circular(14),
          border: isSelected
              ? Border.all(color: AppColors.gold, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // 1. Ảnh bên trái
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                bottomLeft: Radius.circular(14),
              ),
              child: SizedBox(
                width: 120,
                height: double.infinity,
                child: Image.asset(
                  news.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.bgSecondary,
                      child: const Icon(
                        Icons.movie,
                        color: AppColors.textMuted,
                        size: 40,
                      ),
                    );
                  },
                ),
              ),
            ),
            // 2. Nội dung bên phải
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Tiêu đề
                    Text(
                      news.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    // Ngày đăng
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 14,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          news.ngayDang != null
                              ? '${news.ngayDang.day.toString().padLeft(2, '0')}/${news.ngayDang.month.toString().padLeft(2, '0')}/${news.ngayDang.year}'
                              : '',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../news/news_list_screen.dart';

class HelperScreen extends StatelessWidget {
  const HelperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: const Text(
          'Hỗ Trợ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.bgSecondary,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'CINEMODE Hỗ Trợ Khách Hàng',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.gold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.bgElevated,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'CINEMODE luôn đặt trải nghiệm và sự hài lòng của khách hàng làm ưu tiên hàng đầu. Đội ngũ hỗ trợ của chúng tôi sẵn sàng đồng hành và giải đáp mọi thắc mắc liên quan đến lịch chiếu, đặt vé, dịch vụ rạp và các chương trình ưu đãi. Với phong cách phục vụ chuyên nghiệp, tận tâm và nhanh chóng, CINEMODE cam kết mang đến cho khách hàng sự an tâm và thuận tiện trong suốt quá trình trải nghiệm điện ảnh.',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Thông tin liên hệ:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildContactItem(Icons.phone, 'Hotline:', '1900 1234'),
            const SizedBox(height: 12),
            _buildContactItem(Icons.email, 'Email:', 'support@cinemode.com'),
            const SizedBox(height: 12),
            _buildContactItem(Icons.language, 'Website:', 'www.cinemode.com'),
            const SizedBox(height: 12),
            _buildContactItem(Icons.location_on, 'Địa chỉ:', 'BANKING ACADEMY'),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.gold, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class CinemaModeInfoScreen extends StatelessWidget {
  const CinemaModeInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: const Text(
          'Về CINEMODE',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.bgSecondary,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.gold),
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
                'CINEMODE - Trải Nghiệm Điện Ảnh Đỉnh Cao',
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
                'CINEMODE được thành lập vào ngày 15 tháng 6 năm 2020, ra đời từ khát vọng kiến tạo một chuẩn mực mới trong trải nghiệm điện ảnh cao cấp. Ngay từ những ngày đầu, CINEMODE đã định vị mình không chỉ là một hệ thống rạp chiếu phim, mà là một không gian nghệ thuật, nơi công nghệ trình chiếu hiện đại, thiết kế tinh tế và dịch vụ chuyên nghiệp cùng hội tụ.',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.bgElevated,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Trải qua quá trình hình thành và phát triển, CINEMODE không ngừng đầu tư vào chất lượng hình ảnh, âm thanh và không gian phòng chiếu nhằm mang đến trải nghiệm xem phim trọn vẹn và khác biệt. Với triết lý lấy cảm xúc khán giả làm trung tâm, thương hiệu từng bước khẳng định vị thế bằng sự chỉn chu trong từng chi tiết, từ hệ thống ghế ngồi cao cấp đến phong cách phục vụ chuẩn mực. CINEMODE ngày nay là điểm đến của những khán giả yêu điện ảnh, nơi mỗi thước phim không chỉ được trình chiếu, mà còn được tôn vinh như một tác phẩm nghệ thuật.',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

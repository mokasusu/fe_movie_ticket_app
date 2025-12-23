import 'package:flutter/material.dart';
import '../../models/promotion.dart';
import '../../theme/colors.dart';

class PromotionsSlider extends StatefulWidget {
  final List<Promotion> promotions;

  const PromotionsSlider({super.key, required this.promotions});

  @override
  State<PromotionsSlider> createState() => _PromotionsSliderState();
}

class _PromotionsSliderState extends State<PromotionsSlider> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, viewportFraction: 1.0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final desiredHeight = screenHeight / 6;

    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: desiredHeight,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.promotions.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              physics: const PageScrollPhysics(),
              itemBuilder: (context, index) {
                final promo = widget.promotions[index];

                return InkWell(
                  onTap: () {
                    debugPrint('Clicked on: ${promo.title}');
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        promo.imagePath,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.bgSecondary,
                            child: Center(
                              child: Text(
                                promo.title,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),

          // Dot indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.promotions.length, (index) {
              final isActive = _currentPage == index;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isActive ? 12 : 8,
                height: isActive ? 12 : 8,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.gold : AppColors.textMuted,
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

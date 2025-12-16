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
    _pageController = PageController(
      initialPage: 0,
      viewportFraction: 1.0,
    );
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
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.bgSecondary,
                          AppColors.bgElevated,
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(18.0),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.movie_filter,
                          color: AppColors.gold,
                          size: 28,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          promo.title,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
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
                  color: isActive
                      ? AppColors.gold
                      : AppColors.textMuted,
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

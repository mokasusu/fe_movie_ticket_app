import 'package:flutter/material.dart';
import '../../models/promotion.dart';

class PromotionsSlider extends StatefulWidget {
  final List<Promotion> promotions;

  const PromotionsSlider({super.key, required this.promotions});

  @override
  _PromotionsSliderState createState() => _PromotionsSliderState();
}

class _PromotionsSliderState extends State<PromotionsSlider> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 0,
      viewportFraction: 1.0, // full width
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
    final desiredHeight = screenHeight / 6; // chiều cao cố định

    return SafeArea(
      top: false, // sát AppBar
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: desiredHeight, // giữ chiều cao cố định
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.promotions.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              physics: const PageScrollPhysics(), // chỉ lướt 1 trang
              itemBuilder: (context, index) {
                final promo = widget.promotions[index];
                return InkWell(
                  onTap: () {
                    print('Clicked on: ${promo.title}');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: promo.color.withOpacity(0.9),
                    ),
                    padding: const EdgeInsets.all(18.0),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.movie_filter,
                          color: Colors.white,
                          size: 28,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          promo.title,
                          style: const TextStyle(
                            color: Colors.white,
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
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                width: _currentPage == index ? 12.0 : 8.0,
                height: _currentPage == index ? 12.0 : 8.0,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? Colors.blueAccent
                      : Colors.grey.shade400,
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

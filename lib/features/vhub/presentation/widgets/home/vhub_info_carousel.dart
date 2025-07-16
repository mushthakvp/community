import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';

class VHubInfoCarousel extends StatefulWidget {
  const VHubInfoCarousel({super.key});

  @override
  State<VHubInfoCarousel> createState() => _VHubInfoCarouselState();
}

class _VHubInfoCarouselState extends State<VHubInfoCarousel> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<CarouselItem> _items = [
    CarouselItem(
      title: 'Phase 1: Prepare',
      description: 'Lean canvas, Market Testing, Pitch deck and video',
      icon: Icons.lightbulb_outline,
      color: AppConstants.appPrimaryColor,
    ),
    CarouselItem(
      title: 'Phase 2: Build',
      description: 'Early stage funding, Build your MVP, Business Plans',
      icon: Icons.build_outlined,
      color: Colors.blue,
    ),
    CarouselItem(
      title: 'Phase 3: Deliver',
      description: 'Sales, Feedback, Next level of funding',
      icon: Icons.rocket_launch_outlined,
      color: Colors.green,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: _items.length,
            itemBuilder: (context, index) {
              final item = _items[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      item.color.withOpacity(0.2),
                      item.color.withOpacity(0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: item.color.withOpacity(0.3)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: item.color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(item.icon, size: 40, color: item.color),
                    ),
                    const SizedBox(height: 16),
                    CommonTextWidget(
                      text: item.title,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppConstants.white,
                      align: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    CommonTextWidget(
                      text: item.description,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppConstants.white.withOpacity(0.8),
                      align: TextAlign.center,
                      maxLines: 3,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),

        // Page Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _items.length,
            (index) => AnimatedContainer(
              duration: AppConstants.defaultAnimationDuration,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentIndex == index ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentIndex == index
                    ? AppConstants.appPrimaryColor
                    : AppConstants.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CarouselItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  CarouselItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

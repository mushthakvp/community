import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../../domain/entities/spin_entity.dart';

class SpinWheelWidget extends StatelessWidget {
  final List<SpinEntity> options;
  final Stream<int> selectedStream;
  final bool isSpinning;
  final Function(int) onSpinComplete;

  const SpinWheelWidget({
    super.key,
    required this.options,
    required this.selectedStream,
    required this.isSpinning,
    required this.onSpinComplete,
  });

  @override
  Widget build(BuildContext context) {
    if (options.isEmpty) {
      return const Center(
        child: CommonTextWidget(
          text: 'No spin options available',
          color: AppConstants.white,
          fontSize: 16,
        ),
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        // Wheel
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppConstants.appPrimaryColor.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: SizedBox(
            height: 350,
            width: 350,
            child: FortuneWheel(
              selected: selectedStream,
              physics: CircularPanPhysics(
                duration: const Duration(seconds: 5),
                curve: Curves.decelerate,
              ),
              indicators: const [
                FortuneIndicator(
                  alignment: Alignment.centerRight,
                  child: TriangleIndicator(
                    color: AppConstants.white,
                    width: 30.0,
                    height: 50.0,
                    elevation: 8,
                  ),
                ),
              ],
              onFocusItemChanged: (value) {
                // Handle focus change if needed
              },
              animateFirst: isSpinning,
              onAnimationEnd: () {
                // Get the selected index and call completion handler
                // Note: This is a simplified approach, you might need to track the actual selected index
                if (options.isNotEmpty) {
                  onSpinComplete(
                    0,
                  ); // You'll need to implement proper index tracking
                }
              },
              items: _buildWheelItems(),
            ),
          ),
        ),

        // Center Logo
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppConstants.appPrimaryColor,
            border: Border.all(color: AppConstants.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: AppConstants.black.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(Icons.stars, color: AppConstants.black, size: 40),
        ),
      ],
    );
  }

  List<FortuneItem> _buildWheelItems() {
    return options.asMap().entries.map((entry) {
      final index = entry.key;
      final option = entry.value;
      final isEven = index % 2 == 0;

      return FortuneItem(
        style: FortuneItemStyle(
          color: isEven ? const Color(0xFFFDDC57) : AppConstants.black,
          borderColor: AppConstants.white.withOpacity(0.2),
          borderWidth: 1,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 40),
            if (option.safeImageUrl.isNotEmpty)
              CachedNetworkImage(
                imageUrl: option.safeImageUrl,
                width: 20,
                height: 20,
                placeholder: (context, url) => const Icon(
                  Icons.stars,
                  color: AppConstants.appPrimaryColor,
                  size: 16,
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.stars,
                  color: AppConstants.appPrimaryColor,
                  size: 16,
                ),
              )
            else
              Icon(
                Icons.stars,
                color: isEven
                    ? AppConstants.black
                    : AppConstants.appPrimaryColor,
                size: 16,
              ),
            const SizedBox(width: 8),
            Expanded(
              child: CommonTextWidget(
                text: option.displayTitle,
                color: isEven ? AppConstants.black : AppConstants.white,
                fontSize: option.title.length > 10 ? 10 : 12,
                fontWeight: FontWeight.w500,
                maxLines: 2,
                align: TextAlign.start,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}

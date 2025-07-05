import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../../domain/entities/spin_entity.dart';

class SpinWheelWidget extends StatefulWidget {
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
  State<SpinWheelWidget> createState() => _SpinWheelWidgetState();
}

class _SpinWheelWidgetState extends State<SpinWheelWidget> {
  int? _lastSelectedIndex;

  @override
  Widget build(BuildContext context) {
    if (widget.options.isEmpty) {
      return const Center(
        child: CommonTextWidget(
          text: 'No spin options available',
          color: AppConstants.white,
          fontSize: 16,
        ),
      );
    }

    print(
      '🎯 Spin Wheel Widget - Building with ${widget.options.length} options',
    );

    // Debug print options
    for (int i = 0; i < widget.options.length; i++) {
      final option = widget.options[i];
      print(
        '[$i] ${option.title} - Points: ${option.loyaltyPoint} - Coupon: ${option.couponCode}',
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
              selected: widget.selectedStream,
              physics: CircularPanPhysics(
                duration: const Duration(seconds: 4),
                curve: Curves.decelerate,
              ),
              indicators: const [
                FortuneIndicator(
                  alignment: Alignment.topCenter,
                  child: TriangleIndicator(
                    color: AppConstants.white,
                    width: 20.0,
                    height: 30.0,
                    elevation: 8,
                  ),
                ),
              ],
              onFocusItemChanged: (value) {
                // Track the currently focused item
                _lastSelectedIndex = value;
                print('🎯 Focus changed to index: $value');
              },
              animateFirst: false,
              onAnimationEnd: () {
                print(
                  '🎯 Animation ended, selected index: $_lastSelectedIndex',
                );
                if (_lastSelectedIndex != null) {
                  widget.onSpinComplete(_lastSelectedIndex!);
                } else {
                  // Fallback to random selection if something goes wrong
                  final randomIndex = math.Random().nextInt(
                    widget.options.length,
                  );
                  widget.onSpinComplete(randomIndex);
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
    print('🎯 Building ${widget.options.length} wheel items');

    return widget.options.asMap().entries.map((entry) {
      final index = entry.key;
      final option = entry.value;

      // Create alternating colors for better visibility
      final colors = [
        const Color(0xFFFDDC57), // Yellow
        const Color(0xFF4ECDC4), // Teal
        const Color(0xFFFF6B6B), // Red
        const Color(0xFF45B7D1), // Blue
        const Color(0xFF96CEB4), // Green
        const Color(0xFFFFA726), // Orange
        const Color(0xFF9C27B0), // Purple
        const Color(0xFF26A69A), // Cyan
      ];

      final backgroundColor = colors[index % colors.length];
      final textColor = _getContrastColor(backgroundColor);

      print('[$index] Creating wheel item: ${option.title}');
      print('  - Background: $backgroundColor');
      print('  - Text Color: $textColor');
      print('  - Has Image: ${option.image?.isNotEmpty == true}');
      print('  - Loyalty Points: ${option.loyaltyPoint}');

      return FortuneItem(
        style: FortuneItemStyle(
          color: backgroundColor,
          borderColor: AppConstants.white,
          borderWidth: 2,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon or Image
              if (option.image?.isNotEmpty == true)
                CachedNetworkImage(
                  imageUrl: option.image!,
                  width: 24,
                  height: 24,
                  placeholder: (context, url) =>
                      Icon(_getItemIcon(option), color: textColor, size: 20),
                  errorWidget: (context, url, error) =>
                      Icon(_getItemIcon(option), color: textColor, size: 20),
                )
              else
                Icon(_getItemIcon(option), color: textColor, size: 20),

              const SizedBox(height: 4),

              // Title
              CommonTextWidget(
                text: _getDisplayText(option),
                color: textColor,
                fontSize: _getTextSize(option.title),
                fontWeight: FontWeight.w600,
                maxLines: 2,
                align: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  IconData _getItemIcon(SpinEntity option) {
    if (option.hasLoyaltyPoints) return Icons.stars;
    if (option.hasCouponCode) return Icons.local_offer;
    if (option.isBetterLuck) return Icons.sentiment_neutral;
    if (option.isSpinAgain) return Icons.refresh;
    return Icons.emoji_events;
  }

  String _getDisplayText(SpinEntity option) {
    if (option.hasLoyaltyPoints) {
      return '${option.loyaltyPoint}\nPoints';
    }
    if (option.title.isNotEmpty) {
      return option.title;
    }
    return 'Prize';
  }

  double _getTextSize(String text) {
    if (text.length > 15) return 10;
    if (text.length > 10) return 11;
    return 12;
  }

  Color _getContrastColor(Color backgroundColor) {
    // Calculate the relative luminance
    final luminance =
        (0.299 * backgroundColor.red +
            0.587 * backgroundColor.green +
            0.114 * backgroundColor.blue) /
        255;

    // Return black for light backgrounds, white for dark backgrounds
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}

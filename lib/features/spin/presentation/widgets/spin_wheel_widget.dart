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

class _SpinWheelWidgetState extends State<SpinWheelWidget>
    with TickerProviderStateMixin {
  int? _lastSelectedIndex;
  late AnimationController _glowController;
  late AnimationController _rotateController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _rotateController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _glowController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

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
    return Stack(
      alignment: Alignment.center,
      children: [
        // Animated glow effect
        AnimatedBuilder(
          animation: _glowController,
          builder: (context, child) {
            return Container(
              width: 380,
              height: 380,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppConstants.appPrimaryColor.withOpacity(
                      0.1 + (_glowController.value * 0.3),
                    ),
                    blurRadius: 30 + (_glowController.value * 20),
                    spreadRadius: 10 + (_glowController.value * 10),
                  ),
                ],
              ),
            );
          },
        ),

        // Rotating light effects
        AnimatedBuilder(
          animation: _rotateController,
          builder: (context, child) {
            return Transform.rotate(
              angle: _rotateController.value * 2 * math.pi,
              child: Container(
                width: 370,
                height: 370,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    colors: [
                      Colors.transparent,
                      AppConstants.appPrimaryColor.withOpacity(0.1),
                      Colors.transparent,
                      AppConstants.appPrimaryColor.withOpacity(0.1),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.2, 0.4, 0.6, 1.0],
                  ),
                ),
              ),
            );
          },
        ),

        // Main wheel container with border
        Container(
          width: 360,
          height: 360,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppConstants.appPrimaryColor, width: 4),
            boxShadow: [
              BoxShadow(
                color: AppConstants.black.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 3,
              ),
            ],
          ),
          child: FortuneWheel(
            selected: widget.selectedStream,
            physics: CircularPanPhysics(
              duration: const Duration(seconds: 4),
              curve: Curves.decelerate,
            ),
            indicators: [
              FortuneIndicator(
                alignment: Alignment.topCenter,
                child: Container(
                  width: 24,
                  height: 35,
                  decoration: const BoxDecoration(
                    color: AppConstants.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    color: AppConstants.black,
                    size: 20,
                  ),
                ),
              ),
            ],
            onFocusItemChanged: (value) {
              _lastSelectedIndex = value;
            },
            animateFirst: false,
            onAnimationEnd: () {
              if (_lastSelectedIndex != null) {
                widget.onSpinComplete(_lastSelectedIndex!);
              } else {
                final randomIndex = math.Random().nextInt(
                  widget.options.length,
                );
                widget.onSpinComplete(randomIndex);
              }
            },
            items: _buildWheelItems(),
          ),
        ),

        // Center logo with animated GIF
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppConstants.appPrimaryColor,
                AppConstants.appPrimaryColor.withOpacity(0.8),
              ],
            ),
            border: Border.all(color: AppConstants.white, width: 4),
            boxShadow: [
              BoxShadow(
                color: AppConstants.black.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
              BoxShadow(
                color: AppConstants.appPrimaryColor.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(41),
            child: Image.asset(
              'assets/animation/vivera-animation.gif',
              width: 82,
              height: 82,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.stars,
                  color: AppConstants.black,
                  size: 45,
                );
              },
            ),
          ),
        ),

        // Spinning indicator
        if (widget.isSpinning)
          Positioned(
            bottom: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppConstants.appPrimaryColor.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppConstants.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      color: AppConstants.black,
                      strokeWidth: 2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const CommonTextWidget(
                    text: 'Spinning...',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.black,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  List<FortuneItem> _buildWheelItems() {
    return widget.options.asMap().entries.map((entry) {
      final index = entry.key;
      final option = entry.value;

      // Enhanced color palette - same as original
      final colors = [
        const Color(0xFFFDDC57), // Golden Yellow
        const Color(0xFF4ECDC4), // Turquoise
        const Color(0xFFFF6B6B), // Coral Red
        const Color(0xFF45B7D1), // Sky Blue
        const Color(0xFF96CEB4), // Mint Green
        const Color(0xFFFFA726), // Orange
        const Color(0xFF9C27B0), // Purple
        const Color(0xFF26A69A), // Teal
        const Color(0xFFEF5350), // Red
        const Color(0xFF5C6BC0), // Indigo
      ];
      final backgroundColor = colors[index % colors.length];
      final textColor = _getContrastColor(backgroundColor);

      return FortuneItem(
        style: FortuneItemStyle(
          color: backgroundColor,
          borderColor: AppConstants.white,
          borderWidth: 2,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon/Image - fixed to show properly
              if (option.image?.isNotEmpty == true)
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl: option.image!,
                      width: 32,
                      height: 32,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          _getItemIcon(option),
                          color: textColor,
                          size: 20,
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(
                        _getItemIcon(option),
                        color: textColor,
                        size: 20,
                      ),
                    ),
                  ),
                )
              else
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Icon(
                      _getItemIcon(option),
                      color: textColor,
                      size: 20,
                    ),
                  ),
                ),
              const SizedBox(height: 6),
              CommonTextWidget(
                text: _getDisplayText(option),
                color: Colors.white,
                fontSize: _getTextSize(option.title, widget.options.length),
                fontWeight: FontWeight.w700,
                maxLines: _getMaxLines(widget.options.length),
                align: TextAlign.right,
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
      // Return full title without truncation
      return option.title;
    }
    return 'Prize';
  }

  // Improved text sizing based on number of items and text length
  double _getTextSize(String text, int totalItems) {
    if (totalItems > 8) {
      if (text.length > 20) return 8;
      if (text.length > 15) return 9;
      return 10;
    } else if (totalItems > 6) {
      if (text.length > 25) return 9;
      if (text.length > 20) return 10;
      return 11;
    } else {
      if (text.length > 30) return 10;
      if (text.length > 25) return 11;
      return 12;
    }
  }

  // Max lines based on number of items
  int _getMaxLines(int totalItems) {
    if (totalItems > 8) return 2;
    if (totalItems > 6) return 3;
    return 3;
  }

  Color _getContrastColor(Color backgroundColor) {
    final luminance =
        (0.299 * backgroundColor.red +
            0.587 * backgroundColor.green +
            0.114 * backgroundColor.blue) /
        255;
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}

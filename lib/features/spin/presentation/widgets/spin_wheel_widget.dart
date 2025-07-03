import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../../domain/entities/spin_option_entity.dart';

class SpinWheelWidget extends StatefulWidget {
  final List<SpinOptionEntity> options;
  final Stream<int> controller;
  final VoidCallback? onAnimationEnd;
  final Function(int)? onFocusItemChanged;
  final bool isSpinning;
  final double size;
  final bool showLabels;
  final bool showIcons;

  const SpinWheelWidget({
    super.key,
    required this.options,
    required this.controller,
    this.onAnimationEnd,
    this.onFocusItemChanged,
    this.isSpinning = false,
    this.size = 300,
    this.showLabels = true,
    this.showIcons = true,
  });

  @override
  State<SpinWheelWidget> createState() => _SpinWheelWidgetState();
}

class _SpinWheelWidgetState extends State<SpinWheelWidget>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.options.isEmpty) {
      return _buildEmptyWheel();
    }

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer glow effect
          _buildGlowEffect(),

          // Main wheel
          _buildWheel(),

          // Center hub
          _buildCenterHub(),

          // Pointer
          _buildPointer(),
        ],
      ),
    );
  }

  Widget _buildEmptyWheel() {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade300,
        border: Border.all(color: Colors.grey.shade400, width: 4),
      ),
      child: const Center(
        child: CommonTextWidget(
          text: 'No Options Available',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildGlowEffect() {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          width: widget.size + 20,
          height: widget.size + 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppConstants.appPrimaryColor.withOpacity(
                  0.3 * _glowAnimation.value,
                ),
                blurRadius: 20 + (10 * _glowAnimation.value),
                spreadRadius: 5 + (5 * _glowAnimation.value),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWheel() {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: FortuneWheel(
          selected: widget.controller,
          physics: CircularPanPhysics(
            duration: const Duration(seconds: 3),
            curve: Curves.decelerate,
          ),
          onFocusItemChanged: widget.onFocusItemChanged,
          onAnimationEnd: widget.onAnimationEnd,
          hapticImpact: HapticImpact.heavy,
          indicators: [
            FortuneIndicator(
              alignment: Alignment.topCenter,
              child: TriangleIndicator(
                color: Colors.white,
                width: 20.0,
                height: 30.0,
                elevation: 8,
              ),
            ),
          ],
          items: _buildWheelItems(),
        ),
      ),
    );
  }

  List<FortuneItem> _buildWheelItems() {
    final colors = _generateColors();

    return List.generate(widget.options.length, (index) {
      final option = widget.options[index];
      final color = colors[index % colors.length];

      return FortuneItem(
        style: FortuneItemStyle(
          color: color,
          borderColor: Colors.white,
          borderWidth: 2,
          textStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        child: _buildWheelItemContent(option, color),
      );
    });
  }

  Widget _buildWheelItemContent(
    SpinOptionEntity option,
    Color backgroundColor,
  ) {
    final isLight = _isLightColor(backgroundColor);
    final textColor = isLight ? Colors.black : Colors.white;

    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.showIcons) ...[
            Icon(option.rewardIcon, color: textColor, size: 20),
            const SizedBox(height: 4),
          ],
          if (widget.showLabels) ...[
            Flexible(
              child: CommonTextWidget(
                text: option.rewardDisplayText,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: textColor,
                maxLines: 2,
                align: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCenterHub() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConstants.appPrimaryColor,
            AppConstants.appPrimaryColor.withOpacity(0.8),
          ],
        ),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: widget.isSpinning
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Icon(Icons.casino, color: Colors.white, size: 24),
      ),
    );
  }

  Widget _buildPointer() {
    return Positioned(
      top: -5,
      child: Container(
        width: 0,
        height: 0,
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: Colors.transparent, width: 10),
            right: BorderSide(color: Colors.transparent, width: 10),
            bottom: BorderSide(color: Colors.red, width: 25),
          ),
        ),
      ),
    );
  }

  List<Color> _generateColors() {
    final baseColors = [
      const Color(0xFF8B5CF6), // Purple
      const Color(0xFF06B6D4), // Cyan
      const Color(0xFF10B981), // Emerald
      const Color(0xFFF59E0B), // Amber
      const Color(0xFFEF4444), // Red
      const Color(0xFF3B82F6), // Blue
      const Color(0xFFEC4899), // Pink
      const Color(0xFF84CC16), // Lime
      const Color(0xFF6366F1), // Indigo
      const Color(0xFF8B5A2B), // Brown
    ];

    // Generate more colors if needed
    final colors = <Color>[];
    for (int i = 0; i < widget.options.length; i++) {
      if (i < baseColors.length) {
        colors.add(baseColors[i]);
      } else {
        // Generate complementary colors
        final hue = (i * 137.5) % 360; // Golden angle
        colors.add(HSLColor.fromAHSL(1.0, hue, 0.7, 0.5).toColor());
      }
    }

    return colors;
  }

  bool _isLightColor(Color color) {
    final luminance = color.computeLuminance();
    return luminance > 0.5;
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:livera/core/utils/extensions.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../providers/home_provider.dart';

class StickyHomeAppBar extends StatefulWidget {
  const StickyHomeAppBar({super.key});

  @override
  State<StickyHomeAppBar> createState() => _StickyHomeAppBarState();
}

class _StickyHomeAppBarState extends State<StickyHomeAppBar>
    with TickerProviderStateMixin {
  late AnimationController _moonController;
  late AnimationController _starsController;

  late Animation<double> _starsOpacityAnimation;

  @override
  void initState() {
    super.initState();
    _moonController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    _starsController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _starsOpacityAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _starsController, curve: Curves.easeInOut),
    );
    _moonController.repeat();
    _starsController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _moonController.dispose();
    _starsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF0A0A0A),
            const Color(0xFF1A1A2E).withOpacity(0.9),
            Colors.transparent,
          ],
          stops: const [0.0, 0.7, 1.0],
        ),
      ),
      child: Stack(
        children: [
          _buildStarsBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildWelcomeSection(context),
                  _buildActionIcons(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarsBackground() {
    return AnimatedBuilder(
      animation: _starsOpacityAnimation,
      builder: (context, child) {
        return Positioned.fill(
          child: CustomPaint(
            painter: StarsPainter(_starsOpacityAnimation.value),
          ),
        );
      },
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        final userName =
            provider.userDetails?.name.capitalizeFirstLetter() ??
            "Community User";
        return Row(
          children: [
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CommonTextWidget(
                  color: AppConstants.white,
                  text: 'Welcome',
                  align: TextAlign.start,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
                CommonTextWidget(
                  color: AppConstants.white,
                  text: userName,
                  align: TextAlign.start,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionIcons(BuildContext context) {
    return Row(
      children: [
        _buildIconButton(icon: AppConstants.chatIcon, onTap: () {}),
        const SizedBox(width: 8),
        _buildNotificationButton(),
      ],
    );
  }

  Widget _buildIconButton({required String icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppConstants.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppConstants.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: SvgPicture.string(
          icon,
          height: 20,
          width: 20,
          color: AppConstants.white,
        ),
      ),
    );
  }

  Widget _buildNotificationButton() {
    return GestureDetector(
      onTap: () {
        // Navigate to notifications
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppConstants.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppConstants.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            const Icon(
              Icons.notifications_outlined,
              color: AppConstants.white,
              size: 20,
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppConstants.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for stars
class StarsPainter extends CustomPainter {
  final double opacity;

  StarsPainter(this.opacity);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(opacity * 0.8)
      ..style = PaintingStyle.fill;

    final dimPaint = Paint()
      ..color = Colors.white.withOpacity(opacity * 0.4)
      ..style = PaintingStyle.fill;

    // Generate small stars for the app bar area
    final random = Random(42); // Fixed seed for consistent positions

    for (int i = 0; i < 30; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height * 0.7; // Only upper portion
      final starSize = random.nextDouble() * 1.0 + 0.3;

      final currentPaint = (i % 3 == 0) ? paint : dimPaint;
      canvas.drawCircle(Offset(x, y), starSize, currentPaint);
    }
  }

  @override
  bool shouldRepaint(covariant StarsPainter oldDelegate) {
    return oldDelegate.opacity != opacity;
  }
}

// Custom painter for moon
class MoonPainter extends CustomPainter {
  final double rotation;
  final double glow;

  MoonPainter(this.rotation, this.glow);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 3;

    // Moon glow effect
    final glowPaint = Paint()
      ..color = const Color(0xFFFFCB28).withOpacity(0.3 * glow)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawCircle(center, radius + 5, glowPaint);

    // Moon base
    final moonPaint = Paint()
      ..color = const Color(0xFFFFCB28)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, moonPaint);

    // Moon craters with rotation
    final craterPaint = Paint()
      ..color = const Color(0xFFE8B732).withOpacity(0.6)
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation * 2 * 3.14159);
    canvas.translate(-center.dx, -center.dy);

    // Draw craters
    canvas.drawCircle(Offset(center.dx - 6, center.dy - 8), 2, craterPaint);
    canvas.drawCircle(Offset(center.dx + 4, center.dy - 3), 1.5, craterPaint);
    canvas.drawCircle(Offset(center.dx - 2, center.dy + 6), 1.8, craterPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant MoonPainter oldDelegate) {
    return oldDelegate.rotation != rotation || oldDelegate.glow != glow;
  }
}

import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../providers/home_provider.dart';

class MarqueeText extends StatefulWidget {
  const MarqueeText({super.key});

  @override
  State<MarqueeText> createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<MarqueeText>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late AnimationController _iconController;

  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _iconRotationAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _iconController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
        );

    _iconRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _iconController, curve: Curves.linear));

    _pulseController.repeat(reverse: true);
    _slideController.forward();
    _iconController.repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        final marqueeText = provider.userDetails?.marquee;
        if (marqueeText == null || marqueeText.isEmpty) {
          return const SizedBox.shrink();
        }

        return SlideTransition(
          position: _slideAnimation,
          child: ScaleTransition(
            scale: _pulseAnimation,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppConstants.appPrimaryColor.withOpacity(0.9),
                    AppConstants.appPrimaryColor.withOpacity(0.7),
                    AppConstants.appPrimaryColor.withOpacity(0.9),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppConstants.appPrimaryColor.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 0,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Animated background pattern
                  _buildAnimatedBackground(),

                  // Main content
                  Row(
                    children: [
                      _buildIconSection(Icons.campaign_rounded, isLeft: true),
                      Expanded(child: _buildMarqueeText(marqueeText)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _iconRotationAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.transparent,
                Colors.white.withOpacity(0.05),
              ],
              stops: [
                (_iconRotationAnimation.value - 0.3).clamp(0.0, 1.0),
                _iconRotationAnimation.value.clamp(0.0, 1.0),
                (_iconRotationAnimation.value + 0.3).clamp(0.0, 1.0),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildIconSection(IconData icon, {required bool isLeft}) {
    return AnimatedBuilder(
      animation: _iconRotationAnimation,
      builder: (context, child) {
        return Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppConstants.black.withOpacity(0.1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isLeft ? 16 : 0),
              bottomLeft: Radius.circular(isLeft ? 16 : 0),
              topRight: Radius.circular(isLeft ? 0 : 16),
              bottomRight: Radius.circular(isLeft ? 0 : 16),
            ),
            border: Border(
              right: isLeft
                  ? BorderSide(
                      color: AppConstants.black.withOpacity(0.1),
                      width: 1,
                    )
                  : BorderSide.none,
              left: !isLeft
                  ? BorderSide(
                      color: AppConstants.black.withOpacity(0.1),
                      width: 1,
                    )
                  : BorderSide.none,
            ),
          ),
          child: Center(
            child: Transform.rotate(
              angle: isLeft
                  ? _iconRotationAnimation.value * 2 * 3.14159
                  : -_iconRotationAnimation.value * 2 * 3.14159,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppConstants.black.withOpacity(0.2),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppConstants.black.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, color: AppConstants.black, size: 20),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMarqueeText(String text) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Center(
        child: text.length > 30
            ? Marquee(
                text: text,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppConstants.black,
                  fontSize: 16,
                  height: 1.2,
                  letterSpacing: 0.5,
                  shadows: [
                    Shadow(
                      color: Colors.white24,
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                scrollAxis: Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.center,
                blankSpace: 50.0,
                velocity: 60.0,
                pauseAfterRound: const Duration(seconds: 3),
                startPadding: 20.0,
                accelerationDuration: const Duration(seconds: 1),
                accelerationCurve: Curves.easeInOut,
                decelerationDuration: const Duration(milliseconds: 800),
                decelerationCurve: Curves.easeOut,
                showFadingOnlyWhenScrolling: true,
                fadingEdgeStartFraction: 0.15,
                fadingEdgeEndFraction: 0.15,
              )
            : Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppConstants.black,
                  fontSize: 16,
                  height: 1.2,
                  letterSpacing: 0.5,
                  shadows: [
                    Shadow(
                      color: Colors.white24,
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
      ),
    );
  }
}

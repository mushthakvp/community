import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../../domain/entities/spin_entity.dart';

class SpinResultDialog extends StatefulWidget {
  final SpinEntity option;
  final bool isUnlimited;
  final VoidCallback onContinue;
  final VoidCallback? onSpinAgain;

  const SpinResultDialog({
    super.key,
    required this.option,
    this.isUnlimited = false,
    required this.onContinue,
    this.onSpinAgain,
  });

  @override
  State<SpinResultDialog> createState() => _SpinResultDialogState();
}

class _SpinResultDialogState extends State<SpinResultDialog>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _slideController;
  late AnimationController _bounceController;
  late AnimationController _rotateController;
  late AnimationController _confettiController;
  late AnimationController _shimmerController;

  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _confettiAnimation;
  late Animation<double> _shimmerAnimation;

  bool _isWin = false;
  bool _isBetterLuck = false;
  bool _showContent = false;

  @override
  void initState() {
    super.initState();
    _determineResultType();
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _determineResultType() {
    _isWin = widget.option.hasLoyaltyPoints || widget.option.hasCouponCode;
    _isBetterLuck = widget.option.isBetterLuck;
  }

  void _initializeAnimations() {
    // Scale animation for dialog entrance
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    // Slide animation for content
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
        );

    // Bounce animation for icon
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.bounceOut),
    );

    // Rotate animation for celebration
    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _rotateAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.easeInOut),
    );

    // Confetti animation
    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _confettiAnimation = CurvedAnimation(
      parent: _confettiController,
      curve: Curves.easeOut,
    );

    // Shimmer animation for win results
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _shimmerAnimation = CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    );
  }

  void _startAnimationSequence() async {
    // Start scale animation
    _scaleController.forward();

    await Future.delayed(const Duration(milliseconds: 200));

    // Start content animations
    _slideController.forward();
    _bounceController.forward();

    setState(() {
      _showContent = true;
    });

    // If it's a win, start celebration animations
    if (_isWin) {
      await Future.delayed(const Duration(milliseconds: 400));
      _confettiController.forward();
      _rotateController.repeat();
      _shimmerController.repeat(reverse: true);

      // Add haptic feedback for wins
      HapticFeedback.heavyImpact();
    } else if (_isBetterLuck) {
      // Gentle feedback for better luck
      HapticFeedback.lightImpact();
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _slideController.dispose();
    _bounceController.dispose();
    _rotateController.dispose();
    _confettiController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 350),
          child: Stack(
            children: [
              // Confetti background for wins
              if (_isWin) _buildConfettiBackground(),

              // Main dialog content
              _buildDialogContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfettiBackground() {
    return AnimatedBuilder(
      animation: _confettiAnimation,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(350, 500),
          painter: ConfettiPainter(_confettiAnimation.value),
        );
      },
    );
  }

  Widget _buildDialogContent() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: _getBackgroundGradient(),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _getBorderColor(), width: 2),
        boxShadow: [
          BoxShadow(color: _getShadowColor(), blurRadius: 25, spreadRadius: 5),
          BoxShadow(
            color: AppConstants.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Close button
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppConstants.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  onPressed: widget.onContinue,
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppConstants.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Animated result icon
          _buildAnimatedIcon(),

          const SizedBox(height: 20),

          // Animated title with shimmer effect
          if (_showContent) _buildAnimatedTitle(),

          const SizedBox(height: 12),

          // Animated subtitle
          if (_showContent) _buildAnimatedSubtitle(),

          const SizedBox(height: 20),

          // Coupon code section with special animation
          if (widget.option.hasCouponCode && _showContent)
            _buildAnimatedCouponSection(),

          // Points display with counter animation
          if (widget.option.hasLoyaltyPoints && _showContent)
            _buildAnimatedPointsSection(),

          const SizedBox(height: 24),

          // Animated action buttons
          if (_showContent) _buildAnimatedButtons(),
        ],
      ),
    );
  }

  Widget _buildAnimatedIcon() {
    return AnimatedBuilder(
      animation: _bounceAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _bounceAnimation.value,
          child: _isWin
              ? AnimatedBuilder(
                  animation: _rotateAnimation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotateAnimation.value,
                      child: _buildIconContainer(),
                    );
                  },
                )
              : _buildIconContainer(),
        );
      },
    );
  }

  Widget _buildIconContainer() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            _getIconColor().withOpacity(0.3),
            _getIconColor().withOpacity(0.1),
          ],
        ),
        border: Border.all(color: _getIconColor(), width: 3),
        boxShadow: [
          BoxShadow(
            color: _getIconColor().withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(_getResultIcon(), color: _getIconColor(), size: 50),
    );
  }

  Widget _buildAnimatedTitle() {
    return SlideTransition(
      position: _slideAnimation,
      child: _isWin
          ? AnimatedBuilder(
              animation: _shimmerAnimation,
              builder: (context, child) {
                return ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      colors: [
                        AppConstants.white,
                        _getIconColor(),
                        AppConstants.white,
                      ],
                      stops: [
                        _shimmerAnimation.value - 0.3,
                        _shimmerAnimation.value,
                        _shimmerAnimation.value + 0.3,
                      ].map((e) => e.clamp(0.0, 1.0)).toList(),
                    ).createShader(bounds);
                  },
                  child: CommonTextWidget(
                    text: _getResultTitle(),
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppConstants.white,
                    align: TextAlign.center,
                  ),
                );
              },
            )
          : CommonTextWidget(
              text: _getResultTitle(),
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppConstants.white,
              align: TextAlign.center,
            ),
    );
  }

  Widget _buildAnimatedSubtitle() {
    return SlideTransition(
      position: _slideAnimation,
      child: CommonTextWidget(
        text: _getResultSubtitle(),
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.white54,
        align: TextAlign.center,
        maxLines: 3,
      ),
    );
  }

  Widget _buildAnimatedCouponSection() {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppConstants.appPrimaryColor.withOpacity(0.2),
              AppConstants.appPrimaryColor.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppConstants.appPrimaryColor.withOpacity(0.5),
          ),
        ),
        child: Column(
          children: [
            const CommonTextWidget(
              text: '🎟️ Your Coupon Code',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppConstants.white,
              align: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppConstants.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppConstants.appPrimaryColor.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CommonTextWidget(
                      text: widget.option.couponCode!,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppConstants.appPrimaryColor,
                      align: TextAlign.center,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppConstants.appPrimaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: () => _copyCouponCode(context),
                      icon: const Icon(
                        Icons.copy_rounded,
                        color: AppConstants.appPrimaryColor,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedPointsSection() {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppConstants.appPrimaryColor.withOpacity(0.2),
              AppConstants.appPrimaryColor.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppConstants.appPrimaryColor.withOpacity(0.5),
          ),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.stars_rounded,
              color: AppConstants.appPrimaryColor,
              size: 40,
            ),
            const SizedBox(height: 8),
            TweenAnimationBuilder<int>(
              tween: IntTween(begin: 0, end: widget.option.loyaltyPoint ?? 0),
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return CommonTextWidget(
                  text: '$value',
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: AppConstants.appPrimaryColor,
                  align: TextAlign.center,
                );
              },
            ),
            const CommonTextWidget(
              text: 'Loyalty Points Earned!',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppConstants.white,
              align: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedButtons() {
    return SlideTransition(
      position: _slideAnimation,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: PrimaryButton(
                text: 'Close',
                onPressed: widget.onContinue,
                backgroundColor: Colors.grey.shade600,
                textColor: AppConstants.white,
                height: 50,
              ),
            ),
          ),
          if (widget.isUnlimited && widget.onSpinAgain != null) ...[
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppConstants.appPrimaryColor.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: PrimaryButton(
                  text: 'Spin Again',
                  onPressed: widget.onSpinAgain!,
                  backgroundColor: AppConstants.appPrimaryColor,
                  textColor: AppConstants.white,
                  height: 50,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Helper methods for styling based on result type
  LinearGradient _getBackgroundGradient() {
    if (_isWin) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF1A5F1A), Color(0xFF0D4A2D), Color(0xFF1A3A2E)],
      );
    } else if (_isBetterLuck) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF5F4A1A), Color(0xFF4A3D0D), Color(0xFF3A341A)],
      );
    }
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
    );
  }

  Color _getBorderColor() {
    if (_isWin) return Colors.green;
    if (_isBetterLuck) return Colors.orange;
    return AppConstants.appPrimaryColor;
  }

  Color _getShadowColor() {
    if (_isWin) return Colors.green.withOpacity(0.3);
    if (_isBetterLuck) return Colors.orange.withOpacity(0.3);
    return AppConstants.appPrimaryColor.withOpacity(0.3);
  }

  Color _getIconColor() {
    if (_isWin) return Colors.green;
    if (_isBetterLuck) return Colors.orange;
    return AppConstants.appPrimaryColor;
  }

  IconData _getResultIcon() {
    if (widget.option.hasLoyaltyPoints) return Icons.stars_rounded;
    if (widget.option.hasCouponCode) return Icons.local_offer_rounded;
    if (widget.option.isBetterLuck) return Icons.sentiment_neutral_rounded;
    if (widget.option.isSpinAgain) return Icons.refresh_rounded;
    return Icons.emoji_events_rounded;
  }

  String _getResultTitle() {
    if (widget.option.hasLoyaltyPoints) return '🎉 Congratulations!';
    if (widget.option.hasCouponCode) return '🎁 You Won a Coupon!';
    if (widget.option.isBetterLuck) return '🍀 Better Luck Next Time';
    if (widget.option.isSpinAgain) return '🎯 Spin Again!';
    return '🏆 Amazing!';
  }

  String _getResultSubtitle() {
    if (widget.option.hasLoyaltyPoints) {
      return 'You\'ve earned ${widget.option.loyaltyPoint} loyalty points! Keep spinning for more exciting rewards.';
    }
    if (widget.option.hasCouponCode) {
      return 'Use this coupon code to get amazing discounts on your next purchase!';
    }
    if (widget.option.isBetterLuck) {
      return 'Don\'t give up! Every spin is a new opportunity to win big. Try again!';
    }
    if (widget.option.isSpinAgain) {
      return 'Lucky you! You get another free chance to spin and win amazing prizes.';
    }
    return widget.option.title;
  }

  void _copyCouponCode(BuildContext context) {
    if (widget.option.couponCode != null) {
      Clipboard.setData(ClipboardData(text: widget.option.couponCode!));

      // Add haptic feedback
      HapticFeedback.selectionClick();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                const Text(
                  'Coupon code copied to clipboard!',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }
}

// Custom painter for confetti animation
class ConfettiPainter extends CustomPainter {
  final double animationValue;

  ConfettiPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final random = math.Random(42); // Fixed seed for consistent animation

    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y =
          (random.nextDouble() * size.height * 2) -
          (size.height * animationValue);

      if (y > 0 && y < size.height) {
        paint.color = _getRandomColor(random);

        // Different shapes for confetti
        if (i % 3 == 0) {
          // Circle
          canvas.drawCircle(Offset(x, y), 3, paint);
        } else if (i % 3 == 1) {
          // Square
          canvas.drawRect(
            Rect.fromCenter(center: Offset(x, y), width: 6, height: 6),
            paint,
          );
        } else {
          // Triangle
          final path = Path();
          path.moveTo(x, y - 3);
          path.lineTo(x - 3, y + 3);
          path.lineTo(x + 3, y + 3);
          path.close();
          canvas.drawPath(path, paint);
        }
      }
    }
  }

  Color _getRandomColor(math.Random random) {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      Colors.teal,
    ];
    return colors[random.nextInt(colors.length)];
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

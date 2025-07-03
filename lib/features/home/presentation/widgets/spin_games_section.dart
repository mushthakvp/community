import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/route_constants.dart';

class SpinGamesSection extends StatefulWidget {
  const SpinGamesSection({super.key});

  @override
  State<SpinGamesSection> createState() => _SpinGamesSectionState();
}

class _SpinGamesSectionState extends State<SpinGamesSection>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _floatingController;

  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _floatingAnimation;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _floatingAnimation = Tween<double>(begin: 0.0, end: 8.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _rotationController.repeat();
    _pulseController.repeat(reverse: true);
    _floatingController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Padding(
          padding: const EdgeInsets.only(left: 24, bottom: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.amber.shade400, Colors.orange.shade500],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.casino, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'Spin Games',
                style: TextStyle(
                  color: AppConstants.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  shadows: [
                    Shadow(
                      color: Colors.amber.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Spin game buttons
        Container(
          height: 160,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Daily Spin Button
              Expanded(child: _buildDailySpinButton()),
              const SizedBox(width: 16),
              // Spin & Win Button
              Expanded(child: _buildSpinAndWinButton()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDailySpinButton() {
    return GestureDetector(
      onTap: () => context.push(RouteConstants.dailySpin),
      child: AnimatedBuilder(
        animation: Listenable.merge([_pulseAnimation, _floatingAnimation]),
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _floatingAnimation.value),
            child: Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.orange.shade400,
                      Colors.deepOrange.shade600,
                      Colors.red.shade500,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.4),
                      blurRadius: 15,
                      spreadRadius: 2,
                      offset: const Offset(0, 6),
                    ),
                    BoxShadow(
                      color: Colors.deepOrange.withOpacity(0.3),
                      blurRadius: 25,
                      spreadRadius: 0,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Background pattern
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _CirclePatternPainter(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),

                    // Content
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon and badge
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.wb_sunny,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade400,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'FREE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const Spacer(),

                          // Title
                          const Text(
                            'Daily Spin',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),

                          // Subtitle
                          const Text(
                            'Free spin every day!\nWin points & rewards',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              height: 1.3,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Action indicator
                          Row(
                            children: [
                              const Text(
                                'Spin Now',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 16,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSpinAndWinButton() {
    return GestureDetector(
      onTap: () => context.push(RouteConstants.spinAndWin),
      child: AnimatedBuilder(
        animation: Listenable.merge([_rotationAnimation, _floatingAnimation]),
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, -_floatingAnimation.value),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppConstants.appPrimaryColor,
                    const Color(0xFF6366F1),
                    const Color(0xFF8B5CF6),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppConstants.appPrimaryColor.withOpacity(0.4),
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: const Offset(0, 6),
                  ),
                  BoxShadow(
                    color: const Color(0xFF8B5CF6).withOpacity(0.3),
                    blurRadius: 25,
                    spreadRadius: 0,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Animated background
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Transform.rotate(
                        angle: _rotationAnimation.value * 2 * 3.14159,
                        child: CustomPaint(
                          painter: _StarPatternPainter(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Content
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon and badge
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Transform.rotate(
                                angle: _rotationAnimation.value * 2 * 3.14159,
                                child: const Icon(
                                  Icons.casino,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber.shade400,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'PREMIUM',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const Spacer(),

                        // Title
                        const Text(
                          'Spin & Win',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Subtitle
                        const Text(
                          'Use points to spin!\nBigger rewards await',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            height: 1.3,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Action indicator
                        Row(
                          children: [
                            const Text(
                              'Play Now',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 16,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Floating sparkles
                  ...List.generate(3, (index) {
                    return Positioned(
                      top: 20.0 + (index * 20),
                      right: 10.0 + (index * 15),
                      child: AnimatedBuilder(
                        animation: _rotationAnimation,
                        builder: (context, child) {
                          final offset =
                              (_rotationAnimation.value + index * 0.3) % 1.0;
                          return Transform.translate(
                            offset: Offset(
                              10 * (offset - 0.5),
                              15 * (offset - 0.5),
                            ),
                            child: Opacity(
                              opacity: 0.6 + 0.4 * offset,
                              child: Icon(
                                Icons.auto_awesome,
                                color: Colors.white,
                                size: 12 + (4 * offset),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CirclePatternPainter extends CustomPainter {
  final Color color;

  _CirclePatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw scattered circles
    for (int i = 0; i < 15; i++) {
      final x = (i * 47) % size.width;
      final y = (i * 73) % size.height;
      final radius = 2.0 + (i % 3);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _StarPatternPainter extends CustomPainter {
  final Color color;

  _StarPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw star pattern
    for (int i = 0; i < 8; i++) {
      final x = (i * 35) % size.width;
      final y = (i * 55) % size.height;
      _drawStar(canvas, Offset(x, y), 3.0 + (i % 2), paint);
    }
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    const numPoints = 5;

    for (int i = 0; i < numPoints; i++) {
      final x =
          center.dx +
          radius *
              0.5 *
              (i % 2 == 0 ? 1 : 0.5) *
              (i == 0
                  ? 1
                  : (i == 1
                        ? 0.309
                        : (i == 2 ? -0.809 : (i == 3 ? -0.809 : 0.309))));
      final y =
          center.dy +
          radius *
              0.5 *
              (i % 2 == 0 ? 1 : 0.5) *
              (i == 0
                  ? 0
                  : (i == 1
                        ? 0.951
                        : (i == 2 ? 0.588 : (i == 3 ? -0.588 : -0.951))));

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

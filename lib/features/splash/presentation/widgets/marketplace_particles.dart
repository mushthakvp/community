import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';

class MarketplaceParticles extends StatefulWidget {
  final bool isActive;

  const MarketplaceParticles({super.key, required this.isActive});

  @override
  State<MarketplaceParticles> createState() => _MarketplaceParticlesState();
}

class _MarketplaceParticlesState extends State<MarketplaceParticles>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _fadeController;
  final List<MarketplaceItem> _items = [];

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _generateMarketplaceItems();
  }

  void _generateMarketplaceItems() {
    final random = math.Random();
    final itemTypes = [
      MarketplaceItemType.vegetables,
      MarketplaceItemType.fruits,
      MarketplaceItemType.handicrafts,
      MarketplaceItemType.textiles,
      MarketplaceItemType.spices,
      MarketplaceItemType.flowers,
    ];

    for (int i = 0; i < 12; i++) {
      _items.add(
        MarketplaceItem(
          type: itemTypes[random.nextInt(itemTypes.length)],
          x: random.nextDouble(),
          y: random.nextDouble() * 0.6 + 0.1, // Keep in upper area
          size: random.nextDouble() * 20 + 15,
          speed: random.nextDouble() * 0.3 + 0.1,
          rotationSpeed: random.nextDouble() * 2 - 1,
          delay: i * 0.2,
        ),
      );
    }
  }

  @override
  void didUpdateWidget(MarketplaceParticles oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _fadeController.forward();
      _floatController.repeat();
    } else if (!widget.isActive && oldWidget.isActive) {
      _fadeController.reverse();
      _floatController.stop();
    }
  }

  @override
  void dispose() {
    _floatController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_floatController, _fadeController]),
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeController,
          child: CustomPaint(
            painter: MarketplacePainter(_items, _floatController.value),
            size: MediaQuery.of(context).size,
          ),
        );
      },
    );
  }
}

enum MarketplaceItemType {
  vegetables,
  fruits,
  handicrafts,
  textiles,
  spices,
  flowers,
}

class MarketplaceItem {
  final MarketplaceItemType type;
  final double x, y, size, speed, rotationSpeed, delay;

  MarketplaceItem({
    required this.type,
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.rotationSpeed,
    required this.delay,
  });
}

class MarketplacePainter extends CustomPainter {
  final List<MarketplaceItem> items;
  final double animationValue;

  MarketplacePainter(this.items, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (var item in items) {
      final adjustedAnimation = math.max(
        0.0,
        (animationValue - item.delay).clamp(0.0, 1.0),
      );

      if (adjustedAnimation <= 0) continue;

      final currentY = (item.y + adjustedAnimation * item.speed * 0.3) % 1.0;
      final floatOffset =
          math.sin(adjustedAnimation * 4 * math.pi + item.delay * 5) * 20;
      final rotation = adjustedAnimation * item.rotationSpeed * 4;

      final position = Offset(
        item.x * size.width + floatOffset,
        currentY * size.height,
      );

      canvas.save();
      canvas.translate(position.dx, position.dy);
      canvas.rotate(rotation);
      canvas.scale(adjustedAnimation); // Fade in effect

      _drawMarketplaceItem(canvas, item);

      canvas.restore();
    }
  }

  void _drawMarketplaceItem(Canvas canvas, MarketplaceItem item) {
    switch (item.type) {
      case MarketplaceItemType.vegetables:
        _drawVegetable(canvas, item.size);
        break;
      case MarketplaceItemType.fruits:
        _drawFruit(canvas, item.size);
        break;
      case MarketplaceItemType.handicrafts:
        _drawHandicraft(canvas, item.size);
        break;
      case MarketplaceItemType.textiles:
        _drawTextile(canvas, item.size);
        break;
      case MarketplaceItemType.spices:
        _drawSpice(canvas, item.size);
        break;
      case MarketplaceItemType.flowers:
        _drawFlower(canvas, item.size);
        break;
    }
  }

  void _drawVegetable(Canvas canvas, double size) {
    // Draw a tomato-like vegetable
    final paint = Paint()
      ..color = Colors.red.shade400
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset.zero, size * 0.4, paint);

    // Add highlight
    final highlightPaint = Paint()
      ..color = Colors.red.shade200
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(-size * 0.1, -size * 0.1),
      size * 0.15,
      highlightPaint,
    );

    // Add stem
    final stemPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(0, -size * 0.4), Offset(0, -size * 0.6), stemPaint);
  }

  void _drawFruit(Canvas canvas, double size) {
    // Draw an orange
    final paint = Paint()
      ..color = Colors.orange.shade400
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset.zero, size * 0.4, paint);

    // Add texture lines
    final texturePaint = Paint()
      ..color = Colors.orange.shade600
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 6; i++) {
      final angle = (i * math.pi * 2) / 6;
      canvas.drawLine(
        Offset.zero,
        Offset(math.cos(angle) * size * 0.3, math.sin(angle) * size * 0.3),
        texturePaint,
      );
    }
  }

  void _drawHandicraft(Canvas canvas, double size) {
    // Draw a decorative pot
    final paint = Paint()
      ..color = Colors.brown.shade600
      ..style = PaintingStyle.fill;

    // Pot body
    final potPath = Path();
    potPath.moveTo(-size * 0.3, size * 0.2);
    potPath.lineTo(-size * 0.2, -size * 0.3);
    potPath.lineTo(size * 0.2, -size * 0.3);
    potPath.lineTo(size * 0.3, size * 0.2);
    potPath.close();

    canvas.drawPath(potPath, paint);

    // Decorative pattern
    final patternPaint = Paint()
      ..color = Colors.amber.shade300
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(-size * 0.25, 0),
      Offset(size * 0.25, 0),
      patternPaint,
    );
  }

  void _drawTextile(Canvas canvas, double size) {
    // Draw a fabric pattern
    final colors = [
      AppConstants.appPrimaryColor,
      Colors.pink.shade300,
      Colors.purple.shade300,
    ];

    for (int i = 0; i < 3; i++) {
      final paint = Paint()
        ..color = colors[i].withOpacity(0.7)
        ..style = PaintingStyle.fill;

      final rect = Rect.fromCenter(
        center: Offset(0, i * size * 0.15 - size * 0.15),
        width: size * 0.6,
        height: size * 0.15,
      );

      canvas.drawRect(rect, paint);
    }

    // Add border
    final borderPaint = Paint()
      ..color = Colors.amber
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    canvas.drawRect(
      Rect.fromCenter(
        center: Offset.zero,
        width: size * 0.6,
        height: size * 0.45,
      ),
      borderPaint,
    );
  }

  void _drawSpice(Canvas canvas, double size) {
    // Draw spice container
    final containerPaint = Paint()
      ..color = Colors.brown.shade300
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset.zero,
          width: size * 0.5,
          height: size * 0.7,
        ),
        Radius.circular(size * 0.1),
      ),
      containerPaint,
    );

    // Add spice particles
    final spicePaint = Paint()
      ..color = Colors.red.shade700
      ..style = PaintingStyle.fill;

    final random = math.Random(42); // Fixed seed for consistent pattern
    for (int i = 0; i < 8; i++) {
      final x = (random.nextDouble() - 0.5) * size * 0.3;
      final y = (random.nextDouble() - 0.5) * size * 0.5;
      canvas.drawCircle(Offset(x, y), 1, spicePaint);
    }
  }

  void _drawFlower(Canvas canvas, double size) {
    // Draw a lotus flower
    final petalPaint = Paint()
      ..color = Colors.pink.shade300
      ..style = PaintingStyle.fill;

    // Draw petals
    for (int i = 0; i < 6; i++) {
      final angle = (i * math.pi * 2) / 6;
      canvas.save();
      canvas.rotate(angle);

      final petal = Path();
      petal.moveTo(0, 0);
      petal.quadraticBezierTo(size * 0.2, -size * 0.3, 0, -size * 0.4);
      petal.quadraticBezierTo(-size * 0.2, -size * 0.3, 0, 0);

      canvas.drawPath(petal, petalPaint);
      canvas.restore();
    }

    // Center
    final centerPaint = Paint()
      ..color = Colors.yellow.shade300
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset.zero, size * 0.1, centerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

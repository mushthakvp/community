// lib/core/widgets/loading/loading_widget.dart
import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';
import '../common/text_widget.dart';

class LoadingWidget extends StatefulWidget {
  final String? message;
  final double size;
  final Color? color;
  final bool showMessage;

  const LoadingWidget({
    super.key,
    this.message,
    this.size = 40,
    this.color,
    this.showMessage = true,
  });

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _rotationAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationAnimation.value * 2 * 3.14159,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(
                      colors: [
                        (widget.color ?? AppConstants.appPrimaryColor)
                            .withOpacity(0.1),
                        widget.color ?? AppConstants.appPrimaryColor,
                      ],
                      stops: const [0.0, 1.0],
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppConstants.black,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            },
          ),
          if (widget.showMessage && widget.message != null) ...[
            const SizedBox(height: 16),
            CommonTextWidget(
              text: widget.message!,
              color: AppConstants.white.withOpacity(0.8),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              align: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

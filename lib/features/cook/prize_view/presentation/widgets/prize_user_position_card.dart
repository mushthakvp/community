import 'package:flutter/material.dart';

import '../../domain/entities/prize_position.dart';
import 'profile_image_widget.dart';

class PrizeUserPositionCard extends StatelessWidget {
  final PrizePosition myPosition;
  final Function(dynamic) onNavigateToRecipe;

  const PrizeUserPositionCard({
    super.key,
    required this.myPosition,
    required this.onNavigateToRecipe,
  });

  @override
  Widget build(BuildContext context) {
    final userName = myPosition.user?.name ?? 'You';
    final userPosition = myPosition.position?.toString() ?? '0';

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xff1E1E1E),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.only(
                left: 20,
                top: 12,
                right: 12,
                bottom: 12,
              ),
              margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
              child: Row(
                children: [
                  ProfileImageWidget(
                    imageUrl: myPosition.user?.profileImage,
                    size: 32,
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Text(
                      '$userName your position is $userPosition',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 13),
                  GestureDetector(
                    onTap: () => onNavigateToRecipe(myPosition),
                    child: Container(
                      width: 78,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Center(
                        child: Text(
                          'View recipe',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

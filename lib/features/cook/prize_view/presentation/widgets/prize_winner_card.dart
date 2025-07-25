import 'package:flutter/material.dart';

import '../../domain/entities/prize_position.dart';
import 'profile_image_widget.dart';

class PrizeWinnerCard extends StatelessWidget {
  final PrizePosition? winner;
  final AnimationController confettiController;
  final bool isUserWinner;
  final Function(dynamic) onNavigateToRecipe;

  const PrizeWinnerCard({
    super.key,
    this.winner,
    required this.confettiController,
    required this.isUserWinner,
    required this.onNavigateToRecipe,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 300,
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [_buildWinnerDetails()],
          ),
        ),
        // Prize trophy icon
        const Positioned(
          left: 100,
          right: 100,
          top: 25,
          child: Hero(
            tag: 'prize-trophy',
            child: Icon(Icons.emoji_events, color: Colors.amber, size: 120),
          ),
        ),
        // Confetti animation for winner
        if (isUserWinner)
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                // Placeholder for confetti animation
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [Colors.amber.withOpacity(0.3), Colors.transparent],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildWinnerDetails() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xff1E1E1E),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildWinnerProfile(),
          const SizedBox(height: 20),
          _buildViewRecipeButton(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildWinnerProfile() {
    final winnerName = winner?.user?.name ?? 'Winner';
    final winnerProfileUrl = winner?.user?.profileImage;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProfileImageWidget(
                imageUrl: winnerProfileUrl,
                size: 48,
                showBorder: true,
              ),
              const SizedBox(width: 13),
              Text(
                winnerName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildViewRecipeButton() {
    return GestureDetector(
      onTap: () => onNavigateToRecipe(winner),
      child: Container(
        width: 120,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(100),
        ),
        child: const Center(
          child: Text(
            'View recipe',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

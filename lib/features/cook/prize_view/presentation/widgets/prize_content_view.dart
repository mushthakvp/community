import 'package:flutter/material.dart';

import '../../domain/entities/prize_overview.dart';
import 'prize_app_bar.dart';
import 'prize_leaderboard_list.dart';
import 'prize_user_position_card.dart';
import 'prize_winner_card.dart';

class PrizeContentView extends StatelessWidget {
  final PrizeOverview prizeOverview;
  final AnimationController confettiController;
  final Function(dynamic) onNavigateToRecipe;
  final VoidCallback onGoBack;

  const PrizeContentView({
    super.key,
    required this.prizeOverview,
    required this.confettiController,
    required this.onNavigateToRecipe,
    required this.onGoBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PrizeAppBar(onGoBack: onGoBack),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrizeWinnerCard(
                  winner: prizeOverview.winner,
                  confettiController: confettiController,
                  isUserWinner: prizeOverview.isUserWinner,
                  onNavigateToRecipe: onNavigateToRecipe,
                ),
                if (prizeOverview.hasMyPosition && !prizeOverview.isUserWinner)
                  PrizeUserPositionCard(
                    myPosition: prizeOverview.myPosition!,
                    onNavigateToRecipe: onNavigateToRecipe,
                  ),
                PrizeLeaderboardList(
                  leaderboard: prizeOverview.leaderboard.take(20).toList(),
                  onNavigateToRecipe: onNavigateToRecipe,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

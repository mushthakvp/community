import 'package:flutter/material.dart';

import '../../domain/entities/prize_position.dart';
import 'profile_image_widget.dart';

class PrizeLeaderboardList extends StatelessWidget {
  final List<PrizePosition> leaderboard;
  final Function(dynamic) onNavigateToRecipe;

  const PrizeLeaderboardList({
    super.key,
    required this.leaderboard,
    required this.onNavigateToRecipe,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        color: Color(0xff1E1E1E),
      ),
      padding: const EdgeInsets.only(left: 0, top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 37),
            child: Text(
              'Standings',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Divider(color: Color(0xff1B1B1B)),
          const SizedBox(height: 6),
          _buildLeaderboardHeader(),
          const SizedBox(height: 6),
          const Divider(color: Color(0xff1B1B1B)),
          const SizedBox(height: 20),
          _buildLeaderboardItems(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildLeaderboardHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Position',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          Text(
            'User',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.6),
              letterSpacing: 2,
            ),
          ),
          Text(
            'Action',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardItems() {
    if (leaderboard.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Text(
            'No winners available yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.only(left: 48, right: 15),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 300 + (index * 50)),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(50 * (1 - value), 0),
                child: _buildLeaderboardItem(index, leaderboard[index]),
              ),
            );
          },
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 30),
      itemCount: leaderboard.length,
    );
  }

  Widget _buildLeaderboardItem(int index, PrizePosition position) {
    final positionNumber = position.position?.toString() ?? '${index + 1}';
    final userName = position.user?.name ?? 'User ${index + 1}';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$positionNumber${position.positionSuffix}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        Row(
          children: [
            ProfileImageWidget(imageUrl: position.user?.profileImage, size: 34),
            const SizedBox(width: 8),
            Text(
              userName,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () => onNavigateToRecipe(position),
          child: const Text(
            'View recipe',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.amber,
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/route_constants.dart';

// Spin Game Model
class SpinGameModel {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final String route;
  final bool isFree;
  final String badgeText;
  final Color badgeColor;

  const SpinGameModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.route,
    required this.isFree,
    required this.badgeText,
    required this.badgeColor,
  });
}

class SpinGamesSection extends StatelessWidget {
  const SpinGamesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final spinGames = _getSpinGames();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(),
        const SizedBox(height: 16),
        _buildSpinGamesGrid(spinGames, context),
      ],
    );
  }

  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.casino, color: Colors.black, size: 20),
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
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpinGamesGrid(
    List<SpinGameModel> spinGames,
    BuildContext context,
  ) {
    return Container(
      height: 160,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildGameCard(
              spinGames[0],
              onTap: () {
                context.push(RouteConstants.dailySpin);
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildGameCard(
              spinGames[1],
              onTap: () {
                context.push(RouteConstants.spinAndWin);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameCard(SpinGameModel game, {required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1C1C1C), Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFFFD700).withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
            BoxShadow(
              color: const Color(0xFFFFD700).withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(game.icon, color: Colors.black, size: 24),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: game.badgeColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      game.badgeText,
                      style: const TextStyle(
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
              Text(
                game.title,
                style: const TextStyle(
                  color: Color(0xFFFFD700),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),

              // Subtitle
              Text(
                game.subtitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 2),

              // Description
              Text(
                game.description,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 11,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 8),

              // Action indicator
              Row(
                children: [
                  Text(
                    game.isFree ? 'Spin Now' : 'Play Now',
                    style: const TextStyle(
                      color: Color(0xFFFFD700),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward,
                    color: Color(0xFFFFD700),
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<SpinGameModel> _getSpinGames() {
    return [
      const SpinGameModel(
        id: 'daily_spin',
        title: 'Daily Spin',
        subtitle: 'Free spin every day!',
        description: 'Win points & rewards',
        icon: Icons.wb_sunny,
        route: RouteConstants.dailySpin,
        isFree: true,
        badgeText: 'FREE',
        badgeColor: Colors.green,
      ),
      const SpinGameModel(
        id: 'spin_and_win',
        title: 'Spin & Win',
        subtitle: 'Use points to spin!',
        description: 'Bigger rewards await',
        icon: Icons.casino,
        route: RouteConstants.spinAndWin,
        isFree: false,
        badgeText: 'PREMIUM',
        badgeColor: Colors.amber,
      ),
    ];
  }
}

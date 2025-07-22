import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyChallengeEmptyState extends StatelessWidget {
  final String status;

  const MyChallengeEmptyState({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildEmptyIcon(),
          const SizedBox(height: 30),
          _buildTitle(),
          const SizedBox(height: 10),
          _buildSubtitle(),
          const SizedBox(height: 30),
          if (status == 'active') _buildActionButton(context),
        ],
      ),
    );
  }

  Widget _buildEmptyIcon() {
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          status == 'active' ? Icons.restaurant_menu : Icons.emoji_events,
          size: 80,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      status == 'active' ? "No Active Challenges" : "No Completed Challenges",
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubtitle() {
    return Text(
      status == 'active'
          ? "You haven't joined any challenges yet.\nStart exploring and join your first challenge!"
          : "Complete challenges to see your progress here.\nYour achievements will be displayed in this section.",
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.grey,
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        context.go('/cook');
      },
      icon: const Icon(Icons.explore, size: 18),
      label: const Text('Explore Challenges'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
    );
  }
}

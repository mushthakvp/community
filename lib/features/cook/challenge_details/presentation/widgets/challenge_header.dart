import 'package:flutter/material.dart';

import '../../domain/entities/challenge_details.dart';

class ChallengeHeader extends StatelessWidget {
  final ChallengeDetails challengeDetails;

  const ChallengeHeader({super.key, required this.challengeDetails});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          challengeDetails.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            _buildInfoChip(
              icon: Icons.access_time,
              text: '${challengeDetails.daysLeft} days left',
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildInfoChip(
                icon: Icons.people,
                text:
                    '${challengeDetails.joinedUsers}/${challengeDetails.maximumParticipants} joined',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoChip({required IconData icon, required String text}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 16),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.white70,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

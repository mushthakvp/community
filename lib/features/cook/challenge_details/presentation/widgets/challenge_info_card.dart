import 'package:flutter/material.dart';

import '../../domain/entities/challenge_details.dart';

class ChallengeInfoCard extends StatelessWidget {
  final ChallengeDetails challengeDetails;

  const ChallengeInfoCard({super.key, required this.challengeDetails});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xff1E1E1E),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildDateColumn(
              'Start Date',
              challengeDetails.formattedStartDate,
            ),
          ),
          Container(width: 1, height: 40, color: Colors.grey.withOpacity(0.3)),
          Expanded(
            child: _buildDateColumn(
              'End Date',
              challengeDetails.formattedEndDate,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateColumn(String label, String date) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          date,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

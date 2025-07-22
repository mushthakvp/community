import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/my_challenge.dart';

class MyChallengeCard extends StatelessWidget {
  final MyChallenge challenge;
  final bool isActive;
  final VoidCallback? onTap;

  const MyChallengeCard({
    super.key,
    required this.challenge,
    required this.isActive,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => _handleTap(context),
      child: Container(
        padding: const EdgeInsets.only(
          left: 13,
          top: 14,
          bottom: 14,
          right: 18,
        ),
        decoration: BoxDecoration(
          color: const Color(0xff1E1E1E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildChallengeImage(),
            const SizedBox(width: 12),
            Expanded(child: _buildChallengeContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 96,
        height: 96,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          image: challenge.image != null
              ? DecorationImage(
                  image: NetworkImage(challenge.image!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: challenge.image == null
            ? const Center(
                child: Icon(Icons.restaurant, color: Colors.grey, size: 40),
              )
            : null,
      ),
    );
  }

  Widget _buildChallengeContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                challenge.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isActive) ...[
              const SizedBox(width: 8),
              _buildStatusIndicator(),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Text(
          challenge.description ?? 'No description available',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),
        if (challenge.createdAt != null) ...[
          const SizedBox(height: 8),
          _buildCreatedAtInfo(),
        ],
      ],
    );
  }

  Widget _buildStatusIndicator() {
    Color statusColor = challenge.status.toLowerCase() == 'joined'
        ? const Color(0xff4CAF50)
        : const Color(0XFFE87B1C);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(radius: 4, backgroundColor: statusColor),
        const SizedBox(width: 4),
        Text(
          challenge.status,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: statusColor,
          ),
        ),
      ],
    );
  }

  Widget _buildCreatedAtInfo() {
    final createdAt = challenge.createdAt!;
    final formattedDate =
        '${createdAt.day.toString().padLeft(2, '0')}/'
        '${createdAt.month.toString().padLeft(2, '0')}/'
        '${createdAt.year}';

    return Row(
      children: [
        const Icon(Icons.schedule, color: Colors.grey, size: 12),
        const SizedBox(width: 4),
        Text(
          'Joined on $formattedDate',
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ],
    );
  }

  void _handleTap(BuildContext context) {
    if (isActive) {
      if (challenge.isActive) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Add recipe for: ${challenge.title}'),
            backgroundColor: Colors.amber,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      context.push('/cook/challenge-details?challengeId=${challenge.id}');
    }
  }
}

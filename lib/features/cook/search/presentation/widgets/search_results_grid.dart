import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/entities/base_challenge.dart';

class SearchResultsGrid extends StatelessWidget {
  final List<BaseChallenge> challenges;

  const SearchResultsGrid({super.key, required this.challenges});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.75,
      ),
      itemCount: challenges.length,
      itemBuilder: (context, index) {
        return _buildChallengeItem(context, challenges[index]);
      },
    );
  }

  Widget _buildChallengeItem(BuildContext context, BaseChallenge challenge) {
    return GestureDetector(
      onTap: () {
        context.push('/cook/challenge-details?challengeId=${challenge.id}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xff1E1E1E),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildChallengeImage(challenge.image),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    challenge.title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  _buildChallengeDetails(challenge),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeImage(String? imageUrl) {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(13),
        image: imageUrl != null
            ? DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover)
            : null,
      ),
      child: imageUrl == null
          ? const Center(child: Icon(Icons.image, color: Colors.grey, size: 40))
          : null,
    );
  }

  Widget _buildChallengeDetails(BaseChallenge challenge) {
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.access_time, color: Colors.white, size: 12),
            const SizedBox(width: 4),
            Text(
              '${challenge.daysLeft} days left',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w300,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.people, color: Colors.white, size: 12),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                '${challenge.joinedUsers}/${challenge.maximumParticipants} joined',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

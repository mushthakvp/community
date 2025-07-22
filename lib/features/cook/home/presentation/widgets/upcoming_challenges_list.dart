import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/challenge.dart';

class UpcomingChallengesList extends StatelessWidget {
  final List<Challenge> challenges;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;
  final VoidCallback onViewAll;

  const UpcomingChallengesList({
    super.key,
    required this.challenges,
    required this.isLoadingMore,
    required this.onLoadMore,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Challenges',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              if (challenges.length > 10)
                GestureDetector(
                  onTap: onViewAll,
                  child: const Text(
                    'View all',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.amber,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels ==
                scrollInfo.metrics.maxScrollExtent) {
              onLoadMore();
            }
            return false;
          },
          child: SizedBox(
            height: 240,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 20),
              itemCount: challenges.length + (isLoadingMore ? 1 : 0),
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                if (index == challenges.length) {
                  return const SizedBox(
                    width: 60,
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.amber),
                    ),
                  );
                }
                return _buildUpcomingChallengeItem(context, challenges[index]);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingChallengeItem(
    BuildContext context,
    Challenge challenge,
  ) {
    return GestureDetector(
      onTap: () {
        context.push('/cook/challenge-details?challengeId=${challenge.id}');
      },
      child: Container(
        width: 190,
        decoration: BoxDecoration(
          color: const Color(0xff1E1E1E),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildChallengeImage(challenge.image),
            const SizedBox(height: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
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
                    Expanded(child: _buildChallengeDetails(challenge)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeImage(String? imageUrl) {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(13),
        image: imageUrl != null
            ? DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover)
            : null,
      ),
      child: imageUrl == null
          ? const Center(
              child: Icon(Icons.restaurant, color: Colors.grey, size: 40),
            )
          : null,
    );
  }

  Widget _buildChallengeDetails(Challenge challenge) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTimerRow(challenge),
        const SizedBox(height: 6),
        _buildPeopleJoinedRow(challenge),
        const SizedBox(height: 6),
        _buildDateRow(challenge),
      ],
    );
  }

  Widget _buildTimerRow(Challenge challenge) {
    return Row(
      children: [
        const Icon(Icons.access_time, color: Colors.white, size: 14),
        const SizedBox(width: 6),
        Flexible(
          // Changed from regular Text to handle overflow
          child: Text(
            '${challenge.daysLeft} days left',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildPeopleJoinedRow(Challenge challenge) {
    return Row(
      children: [
        const Icon(Icons.people, color: Colors.white, size: 14),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            '${challenge.joinedUsers} / ${challenge.maximumParticipants} peoples joined',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildDateRow(Challenge challenge) {
    return Row(
      children: [
        const Icon(Icons.calendar_today, color: Colors.white, size: 14),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            challenge.formattedEndDate,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

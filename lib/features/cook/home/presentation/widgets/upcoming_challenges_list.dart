import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/router/helper_router_cook.dart';
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
              Text(
                'Challenges (${challenges.length})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              if (challenges.length > 4)
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
        _buildGridWithPagination(),
        if (isLoadingMore)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: CircularProgressIndicator(color: Colors.amber),
            ),
          ),
      ],
    );
  }

  Widget _buildGridWithPagination() {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          onLoadMore();
        }
        return false;
      },
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.74,
        ),
        itemCount: challenges.length,
        itemBuilder: (context, index) {
          return _buildChallengeCard(challenges[index]);
        },
      ),
    );
  }

  Widget _buildChallengeCard(Challenge challenge, {double? width}) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () {
          HelperRouterCook.challengeDetailsPath(challenge.id);
        },
        child: Container(
          width: width,
          decoration: BoxDecoration(
            color: const Color(0xff1E1E1E),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
            ? DecorationImage(
                image: CachedNetworkImageProvider(imageUrl),
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {},
              )
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

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/challenge.dart';

class CurrentChallengeCarousel extends StatelessWidget {
  final List<Challenge> challenges;
  final Function(int) onPageChanged;
  final int currentIndex;

  const CurrentChallengeCarousel({
    super.key,
    required this.challenges,
    required this.onPageChanged,
    required this.currentIndex,
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
                'Current Challenge (${challenges.length})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              if (challenges.length > 2)
                GestureDetector(
                  onTap: () => context.push('/cook/my-challenges'),
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
        const SizedBox(height: 21),
        SizedBox(
          height: 290,
          child: PageView.builder(
            itemCount: challenges.length,
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              return _buildCarouselItem(context, challenges[index], index);
            },
          ),
        ),
        const SizedBox(height: 21),
        if (challenges.length > 1) _buildCarouselIndicator(),
      ],
    );
  }

  Widget _buildCarouselItem(
    BuildContext context,
    Challenge challenge,
    int index,
  ) {
    return GestureDetector(
      onTap: () {
        context.push('/cook/challenge-details?challengeId=${challenge.id}');
      },
      child: Container(
        width: 360,
        height: 290,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey[800],
          image: challenge.image != null
              ? DecorationImage(
                  image: NetworkImage(challenge.image!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: challenge.image != null
            ? _buildCarouselItemOverlay(challenge)
            : _buildPlaceholderContent(challenge),
      ),
    );
  }

  Widget _buildCarouselItemOverlay(Challenge challenge) {
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.76, sigmaY: 3.76),
              child: _buildCarouselItemContent(challenge),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderContent(Challenge challenge) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.grey[700]!, Colors.grey[900]!],
        ),
      ),
      child: Stack(
        children: [
          const Center(
            child: Icon(Icons.restaurant, color: Colors.white54, size: 80),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildCarouselItemContent(challenge),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselItemContent(Challenge challenge) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            const Color(0xffDADADA).withOpacity(0.12),
            const Color(0xff999795).withOpacity(0.12),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          _buildChallengeDetails(challenge),
        ],
      ),
    );
  }

  Widget _buildChallengeDetails(Challenge challenge) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTimerRow(challenge),
        const SizedBox(height: 4),
        _buildPeopleJoinedRow(challenge),
        const SizedBox(height: 4),
        _buildDateRow(challenge),
      ],
    );
  }

  Widget _buildTimerRow(Challenge challenge) {
    return Row(
      children: [
        const Icon(Icons.access_time, color: Colors.white, size: 16),
        const SizedBox(width: 8),
        Text(
          '${challenge.daysLeft} days left',
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w300,
            color: Colors.white,
          ),
        ),
        const Spacer(),
        Container(
          width: 80,
          height: 26,
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(100),
          ),
          child: const Center(
            child: Text(
              'Details',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPeopleJoinedRow(Challenge challenge) {
    return Row(
      children: [
        const Icon(Icons.people, color: Colors.white, size: 16),
        const SizedBox(width: 8),
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
        const Icon(Icons.calendar_today, color: Colors.white, size: 16),
        const SizedBox(width: 8),
        Text(
          challenge.formattedEndDate,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w300,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildCarouselIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        challenges.length,
        (index) => Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentIndex == index ? Colors.white : Colors.grey,
          ),
        ),
      ),
    );
  }
}

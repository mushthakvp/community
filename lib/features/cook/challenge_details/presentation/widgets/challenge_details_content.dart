import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/challenge_details.dart';
import 'challenge_header.dart';
import 'challenge_info_card.dart';
import 'join_challenge_button.dart';

class ChallengeDetailsContent extends StatelessWidget {
  final ChallengeDetails challengeDetails;
  final VoidCallback onJoinChallenge;
  final bool isJoinLoading;
  final VoidCallback onNavigateToPrizeOverview;

  const ChallengeDetailsContent({
    super.key,
    required this.challengeDetails,
    required this.onJoinChallenge,
    required this.isJoinLoading,
    required this.onNavigateToPrizeOverview,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ChallengeHeader(challengeDetails: challengeDetails),
          const SizedBox(height: 20),
          _buildChallengeImage(),
          const SizedBox(height: 20),
          _buildDescriptionSection(),
          const SizedBox(height: 20),
          _buildIngredientsSection(),
          const SizedBox(height: 20),
          ChallengeInfoCard(challengeDetails: challengeDetails),
          const SizedBox(height: 20),
          _buildPrizeSection(),
          const SizedBox(height: 30),
          _buildActionButtons(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildChallengeImage() {
    return CachedNetworkImage(
      imageUrl: challengeDetails.image ?? "",
      progressIndicatorBuilder: (context, url, progress) =>
          const Center(child: CircularProgressIndicator(color: Colors.amber)),
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          challengeDetails.description ?? 'No description available',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: Colors.white.withOpacity(0.8),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ingredients',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Get creative! The challenge allows you to select any ingredients for your recipe.',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.white.withOpacity(0.8),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildPrizeSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xff1E1E1E),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Prize Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          _buildPrizeRow('1st Prize', challengeDetails.firstPrizeLoyaltyPoints),
          const SizedBox(height: 10),
          _buildPrizeRow(
            '2nd Prize',
            challengeDetails.secondPrizeLoyaltyPoints,
          ),
          const SizedBox(height: 10),
          _buildPrizeRow('3rd Prize', challengeDetails.thirdPrizeLoyaltyPoints),
        ],
      ),
    );
  }

  Widget _buildPrizeRow(String title, int points) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        Row(
          children: [
            Text(
              points.toString(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 5),
            const Text(
              'Loyalty points',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        if (!challengeDetails.isAlreadyJoined &&
            challengeDetails.isWithinChallengeDate)
          JoinChallengeButton(
            onPressed: onJoinChallenge,
            isLoading: isJoinLoading,
          ),
        if (challengeDetails.isResultAdded) const SizedBox(height: 10),
        if (challengeDetails.isResultAdded)
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: onNavigateToPrizeOverview,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'Prize Overview',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
      ],
    );
  }
}

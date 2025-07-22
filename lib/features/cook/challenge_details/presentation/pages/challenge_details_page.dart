import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_constants.dart';
import '../controllers/challenge_details_controller.dart';
import '../widgets/challenge_details_content.dart';

class ChallengeDetailsPage extends StatefulWidget {
  final String challengeId;

  const ChallengeDetailsPage({super.key, required this.challengeId});

  @override
  State<ChallengeDetailsPage> createState() => _ChallengeDetailsPageState();
}

class _ChallengeDetailsPageState extends State<ChallengeDetailsPage> {
  late final ChallengeDetailsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      ChallengeDetailsController(
        getChallengeDetailsUseCase: Get.find(
          tag: 'challenge_details',
        ), // Use tag
        joinChallengeUseCase: Get.find(
          tag: 'challenge_details_join',
        ), // Use tag
      ),
      tag: 'challenge_details_${widget.challengeId}',
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getChallengeDetails(widget.challengeId);
    });
  }

  @override
  void dispose() {
    Get.delete<ChallengeDetailsController>(
      tag: 'challenge_details_${widget.challengeId}',
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: GetBuilder<ChallengeDetailsController>(
                tag: 'challenge_details_${widget.challengeId}',
                builder: (_) {
                  if (controller.isLoading) {
                    return _buildLoadingView();
                  }

                  if (controller.hasError) {
                    return _buildErrorView();
                  }

                  final challengeDetails = controller.challengeDetails;
                  if (challengeDetails != null) {
                    return ChallengeDetailsContent(
                      challengeDetails: challengeDetails,
                      onJoinChallenge: () =>
                          controller.joinChallenge(widget.challengeId),
                      isJoinLoading: controller.isJoinLoading,
                      onNavigateToPrizeOverview: () =>
                          context.push('/cook/prize-overview'),
                    );
                  }

                  return _buildEmptyView();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 24,
            ),
            padding: EdgeInsets.zero,
          ),
          const SizedBox(width: 8),
          const Text(
            'Challenge Details',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.amber),
          SizedBox(height: 16),
          Text(
            'Loading challenge details...',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 80),
            const SizedBox(height: 20),
            const Text(
              'Failed to load challenge details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.errorMessage,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => controller.retryLoading(widget.challengeId),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
    return const Center(
      child: Text(
        'No challenge details available',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}

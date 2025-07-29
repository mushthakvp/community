import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../core/router/helper_router_cook.dart';
import '../controllers/my_challenges_controller.dart';
import '../widgets/challenge_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/loading_state.dart';

class CookMyChallengesPage extends StatefulWidget {
  final bool fromMyChallenges;

  const CookMyChallengesPage({super.key, this.fromMyChallenges = false});

  @override
  State<CookMyChallengesPage> createState() => _CookMyChallengesPageState();
}

class _CookMyChallengesPageState extends State<CookMyChallengesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final MyChallengesController controller;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Initialize controller
    controller = Get.put(
      MyChallengesController(
        getMyChallengesUseCase: Get.find(tag: 'cook_my_challenges'),
      ),
      tag: 'cook_my_challenges',
    );

    // Add tab listener
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        final status = _tabController.index == 0 ? 'active' : 'completed';
        controller.resetPagination(status);
      }
    });

    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadChallenges(status: 'active');
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(child: Obx(() => _buildTabBarView())),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => _handleBackNavigation(),
          ),
          const SizedBox(width: 10),
          const Text(
            'My Challenges',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorColor: const Color(0xffF0B90A),
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: const Color(0xff525252),
        labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        tabs: const [
          Tab(text: 'Active', icon: Icon(Icons.play_circle_outline, size: 20)),
          Tab(
            text: 'Completed',
            icon: Icon(Icons.check_circle_outline, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBarView() {
    // Show loading state if loading and no data
    if (controller.isLoading &&
        controller.activeChallenges.isEmpty &&
        controller.completedChallenges.isEmpty) {
      return const MyChallengeLoadingState();
    }

    // Show error state
    if (controller.hasError) {
      return _buildErrorState();
    }

    return TabBarView(
      controller: _tabController,
      children: [
        _buildChallengeSection(
          challenges: controller.activeChallenges,
          status: 'active',
        ),
        _buildChallengeSection(
          challenges: controller.completedChallenges,
          status: 'completed',
        ),
      ],
    );
  }

  Widget _buildChallengeSection({
    required List challenges,
    required String status,
  }) {
    // Show empty state if no challenges and not loading
    if (challenges.isEmpty && !controller.isLoading) {
      return MyChallengeEmptyState(status: status);
    }

    return RefreshIndicator(
      onRefresh: () => _refreshChallenges(status),
      color: Colors.amber,
      backgroundColor: const Color(0xff1E1E1E),
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            controller.loadMoreChallenges(status: status);
          }
          return false;
        },
        child: ListView.separated(
          itemCount: challenges.length + (controller.isLoadingMore ? 1 : 0),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            if (index == challenges.length) {
              return _buildLoadMoreIndicator();
            }
            return MyChallengeCard(
              challenge: challenges[index],
              isActive: _tabController.index == 0,
              onTap: () => _handleChallengeCardTap(challenges[index], status),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadMoreIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            color: Color(0xffF0B90A),
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 80),
            const SizedBox(height: 20),
            const Text(
              "Oops! Something went wrong",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              controller.errorMessage.isNotEmpty
                  ? controller.errorMessage
                  : "Unable to load challenges. Please try again.",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => _retryLoading(),
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleBackNavigation() {
    if (widget.fromMyChallenges) {
      context.go('/cook');
    } else {
      context.pop();
    }
  }

  Future<void> _refreshChallenges(String status) async {
    controller.refreshChallenges(status);
  }

  void _retryLoading() {
    final status = _tabController.index == 0 ? 'active' : 'completed';
    controller.loadChallenges(status: status);
  }

  void _handleChallengeCardTap(dynamic challenge, String status) {
    if (status == 'active') {
      if (challenge.isActive) {
        _showRecipeDialog(challenge);
      } else {
        context.push('/cook/challenge-details?challengeId=${challenge.id}');
      }
    } else {
      context.push('/cook/challenge-details?challengeId=${challenge.id}');
    }
  }

  void _showRecipeDialog(dynamic challenge) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xff1E1E1E),
          title: const Text(
            'Add Recipe',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Would you like to add a recipe for "${challenge.title}"?',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                HelperRouterCook.navigateToRecipeTypeSelection(
                  context,
                  challenge.id,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
              ),
              child: const Text('Add Recipe'),
            ),
          ],
        );
      },
    );
  }
}

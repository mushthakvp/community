import 'package:fittor/fittor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_constants.dart';
import '../controllers/home_controller.dart';
import '../widgets/current_challenge_carousel.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/upcoming_challenges_list.dart';

class CookHomePage extends StatefulWidget {
  const CookHomePage({super.key});

  @override
  State<CookHomePage> createState() => _CookHomePageState();
}

class _CookHomePageState extends State<CookHomePage> {
  late final CookHomeController controller;

  @override
  void initState() {
    super.initState();

    controller = Get.put(
      CookHomeController(
        getCookingHomeUseCase: Get.find(),
        searchChallengesUseCase: Get.find(),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initializeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading) {
            return _buildLoadingView();
          }

          if (controller.isError) {
            return _buildErrorView();
          }

          return _buildHomeContent();
        }),
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
            'Loading challenges...',
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
              'Failed to load data',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.errorMessage.isNotEmpty
                  ? controller.errorMessage
                  : 'Something went wrong. Please try again.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                controller.retryLoading();
              },
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Visibility(
                    visible: controller.isSearching,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Column(
                          children: [
                            CircularProgressIndicator(color: Colors.amber),
                            SizedBox(height: 16),
                            Text(
                              'Searching...',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.noSearchResults,
                    child: _buildNoResultsView(),
                  ),
                ),
                Obx(() {
                  final cookingHome = controller.cookingHome;
                  if (cookingHome == null) {
                    return _buildEmptyState();
                  }
                  return Visibility(
                    visible: !controller.noSearchResults,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (cookingHome.currentChallenges.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          CurrentChallengeCarousel(
                            challenges: cookingHome.currentChallenges,
                            onPageChanged: controller.onPageChanged,
                            currentIndex: controller.currentIndex,
                          ),
                          const SizedBox(height: 38),
                        ],
                        if (cookingHome.upcomingChallenges.isNotEmpty) ...[
                          UpcomingChallengesList(
                            challenges: cookingHome.upcomingChallenges,
                            isLoadingMore: controller.isLoadingMore,
                            onLoadMore: controller.loadMoreUpcomingChallenges,
                            onViewAll: () =>
                                context.push('/cook/my-challenges'),
                          ),
                        ],
                        if (cookingHome.currentChallenges.isEmpty &&
                            cookingHome.upcomingChallenges.isEmpty &&
                            !controller.isSearching) ...[
                          _buildNoDataAvailable(),
                        ],
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _buildAppBar(),
        ),
        10.h,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Obx(
            () => CookSearchBarWidget(
              controller: controller.searchController,
              onClear: controller.clearChallenge,
              searchQuery: controller.searchQuery,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildAppBar() {
    return Row(
      children: [
        IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 24),
          padding: const EdgeInsets.all(0),
        ),
        const Text(
          'V-Cook',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const Spacer(),
        IconButton(
          onPressed: () => context.push('/cook/my-challenges'),
          icon: const Icon(
            Icons.article_outlined,
            color: Colors.white,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildNoResultsView() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, color: Colors.grey, size: 80),
            const SizedBox(height: 20),
            const Text(
              'No challenges found',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'We couldn\'t find any challenges matching "${controller.searchQuery}"',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.restaurant_menu, color: Colors.grey, size: 80),
            const SizedBox(height: 20),
            const Text(
              'No challenges available',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Check back later for new cooking challenges!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                controller.retryLoading();
              },
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Refresh'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoDataAvailable() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.info_outline, color: Colors.amber, size: 60),
            const SizedBox(height: 16),
            const Text(
              'No challenges available at the moment',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'New challenges will appear here soon!',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

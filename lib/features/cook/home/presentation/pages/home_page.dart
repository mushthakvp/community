import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_constants.dart';
import '../controllers/home_controller.dart';

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
    return const Center(child: CircularProgressIndicator(color: Colors.amber));
  }

  Widget _buildErrorView() {
    return Center(
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
            controller.errorMessage,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: controller.retryLoading,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
            ),
            child: const Text('Retry'),
          ),
        ],
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
                Obx(
                  () => Visibility(
                    visible: !controller.noSearchResults,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (controller
                                .cookingHome
                                ?.currentChallenges
                                .isNotEmpty ??
                            false) ...[
                          const SizedBox(height: 10),
                          CurrentChallengeCarousel(
                            challenges:
                                controller.cookingHome!.currentChallenges,
                            onPageChanged: controller.onPageChanged,
                            currentIndex: controller.currentIndex,
                          ),
                        ],
                        if (controller
                                .cookingHome
                                ?.upcomingChallenges
                                .isNotEmpty ??
                            false) ...[
                          const SizedBox(height: 38),
                          UpcomingChallengesList(
                            challenges:
                                controller.cookingHome!.upcomingChallenges,
                            isLoadingMore: controller.isLoadingMore,
                            onLoadMore: controller.loadMoreUpcomingChallenges,
                            onViewAll: () =>
                                context.push('/cook/my-challenges'),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
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
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _buildAppBar(),
        ),
        const SizedBox(height: 31),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CookSearchBarWidget(
            controller: controller.searchController,
            onClear: controller.clearChallenge,
            searchQuery: controller.searchQuery,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildAppBar() {
    return Row(
      children: [
        const Text(
          'Cooking',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Row(
          children: [
            IconButton(
              onPressed: () => _showProfileOptions(),
              icon: const Icon(Icons.logout, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 10),
            IconButton(
              onPressed: () => context.push('/cook/my-challenges'),
              icon: const Icon(
                Icons.article_outlined,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showProfileOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: AppConstants.black,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            border: Border.all(color: Colors.white24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Add logout logic here
                },
              ),
            ],
          ),
        );
      },
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
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_constants.dart';
import '../controllers/search_controller.dart';
import '../widgets/search_results_grid.dart';

class CookSearchPage extends StatefulWidget {
  const CookSearchPage({super.key});

  @override
  State<CookSearchPage> createState() => _CookSearchPageState();
}

class _CookSearchPageState extends State<CookSearchPage> {
  late final CookSearchController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      CookSearchController(searchChallengesUseCase: Get.find()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 10),
            _buildSearchBar(),
            const SizedBox(height: 10),
            Expanded(child: Obx(() => _buildSearchContent())),
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
            onPressed: () => context.pop(),
          ),
          const SizedBox(width: 10),
          const Text(
            'Search Challenge',
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

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: [
              const Color(0xffdadada).withOpacity(0.12),
              const Color(0xff999795).withOpacity(0.12),
            ],
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 20),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.white70, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: controller.searchTextController,
                onChanged: (value) {
                  if (value.trim().isNotEmpty) {
                    controller.searchChallenges(value);
                  } else {
                    controller.clearSearch();
                  }
                },
                onTap: controller.showSearchSuggestions,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search challenges, recipes',
                  hintStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            Obx(
              () => Visibility(
                visible: controller.searchTextController.text.isNotEmpty,
                child: GestureDetector(
                  onTap: controller.clearSearch,
                  child: Icon(
                    Icons.close,
                    color: Colors.white.withOpacity(0.6),
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchContent() {
    if (controller.showSuggestions && controller.recentSearches.isNotEmpty) {
      return _buildRecentSearches();
    }

    if (controller.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.amber),
      );
    }

    if (controller.isError) {
      return _buildErrorState();
    }

    if (controller.searchResults == null) {
      return _buildInitialState();
    }

    final results = controller.searchResults!;
    if (results.challenges.isEmpty) {
      return _buildNoResultsState();
    }

    return SearchResultsGrid(challenges: results.challenges);
  }

  Widget _buildRecentSearches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Searches',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: controller.clearRecentSearches,
                child: const Text(
                  'Clear All',
                  style: TextStyle(color: Colors.amber, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: controller.recentSearches.length,
            itemBuilder: (context, index) {
              final query = controller.recentSearches[index];
              return ListTile(
                leading: const Icon(Icons.history, color: Colors.grey),
                title: Text(query, style: const TextStyle(color: Colors.white)),
                onTap: () {
                  controller.selectRecentSearch(query);
                  controller.hideSuggestions();
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 80),
          const SizedBox(height: 20),
          const Text(
            'Search Error',
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
        ],
      ),
    );
  }

  Widget _buildInitialState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, color: Colors.grey, size: 80),
          SizedBox(height: 20),
          Text(
            'Search for challenges',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Enter keywords to find cooking challenges',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
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
          const SizedBox(height: 8),
          Text(
            'No results for "${controller.searchQuery}"',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

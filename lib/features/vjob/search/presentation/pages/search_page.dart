import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/loading/loading_widget.dart';
import '../providers/search_provider.dart';
import '../widgets/recent_searches_widget.dart';
import '../widgets/search_field_widget.dart';
import '../widgets/search_job_card_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _setupScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchProvider>().getRecentSearches();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _setupScrollController() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.8) {
        final provider = context.read<SearchProvider>();
        if (!provider.isLoadingMore &&
            provider.hasMoreData &&
            provider.isSearching) {
          provider.searchJobs(provider.searchController.text, isLoadMore: true);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: AppBar(
        backgroundColor: AppConstants.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppConstants.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const CommonTextWidget(
          text: 'Search',
          color: AppConstants.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: false,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(65),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SearchFieldWidget(),
          ),
        ),
      ),
      body: Consumer<SearchProvider>(
        builder: (context, provider, _) {
          if (!provider.isSearching) {
            return const RecentSearchesWidget();
          }

          if (provider.isLoading) {
            return const Center(
              child: LoadingWidget(message: 'Searching jobs...'),
            );
          }

          if (provider.status == SearchStatus.error) {
            return _buildErrorView(provider.errorMessage);
          }

          if (provider.isEmpty) {
            return _buildEmptyView();
          }

          return ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount:
                provider.searchResults.length +
                (provider.isLoadingMore ? 1 : 0),
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              if (index >= provider.searchResults.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: LoadingWidget(size: 30, showMessage: false),
                  ),
                );
              }

              final job = provider.searchResults[index];
              return SearchJobCardWidget(job: job);
            },
          );
        },
      ),
    );
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.withOpacity(0.7),
            ),
            const SizedBox(height: 16),
            CommonTextWidget(
              text: message,
              fontSize: 16,
              color: AppConstants.white.withOpacity(0.8),
              align: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final provider = context.read<SearchProvider>();
                if (provider.searchController.text.isNotEmpty) {
                  provider.searchJobs(provider.searchController.text);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.appPrimaryColor,
                foregroundColor: AppConstants.black,
              ),
              child: const CommonTextWidget(
                text: 'Retry',
                color: AppConstants.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppConstants.white.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            CommonTextWidget(
              text: 'No jobs found',
              fontSize: 18,
              color: AppConstants.white.withOpacity(0.8),
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 8),
            CommonTextWidget(
              text: 'Try adjusting your search terms',
              fontSize: 14,
              color: AppConstants.white.withOpacity(0.6),
              align: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livera/core/utils/result.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/utils/extensions.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/loading/loading_widget.dart';
import '../../domain/entities/my_post_entity.dart';
import '../providers/my_post_provider.dart';
import '../widgets/my_post_card_widget.dart';
import '../widgets/my_post_stats_widget.dart';
import '../widgets/search_bar_widget.dart';

class MyPostViewPage extends StatefulWidget {
  const MyPostViewPage({super.key});

  @override
  State<MyPostViewPage> createState() => _MyPostViewPageState();
}

class _MyPostViewPageState extends State<MyPostViewPage> {
  late MyPostProvider _provider;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<MyPostProvider>(context, listen: false);
    _scrollController = ScrollController();
    _setupScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
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
        if (!_provider.isSearching &&
            !_provider.isLoadingMore &&
            _provider.hasMoreData) {
          _provider.getMyPosts(isLoadMore: true);
        }
      }
    });
  }

  void _initializeData() {
    _provider.getMyPosts();
    _provider.getPostStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppConstants.black,
      elevation: 0,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: const Icon(Icons.arrow_back, color: AppConstants.white),
      ),
      title: const CommonTextWidget(
        text: 'My Posts',
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppConstants.white,
      ),
      centerTitle: false,
      actions: [
        IconButton(
          onPressed: () => _provider.refreshPosts(),
          icon: const Icon(Icons.refresh, color: AppConstants.white),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Consumer<MyPostProvider>(
      builder: (context, provider, _) {
        return Column(
          children: [
            _buildSearchBar(),
            _buildStatsSection(),
            Expanded(child: _buildPostsList()),
          ],
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Consumer<MyPostProvider>(
      builder: (context, provider, _) {
        return SearchBarWidget(
          controller: provider.searchController,
          onChanged: (query) => _handleSearch(query),
          onClear: () => provider.clearSearch(),
          isSearching: provider.isSearching,
        );
      },
    );
  }

  Widget _buildStatsSection() {
    return Consumer<MyPostProvider>(
      builder: (context, provider, _) {
        if (provider.postStats == null || provider.isSearching) {
          return const SizedBox.shrink();
        }

        return MyPostStatsWidget(
          stats: provider.postStats!,
          onTap: () => _handleStatsCardTap(),
        );
      },
    );
  }

  Widget _buildPostsList() {
    return Consumer<MyPostProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(
            child: LoadingWidget(message: 'Loading posts...'),
          );
        }

        if (provider.status == MyPostStatus.error) {
          return _buildErrorView(
            message: provider.errorMessage,
            onRetry: () => provider.getMyPosts(),
          );
        }

        if (provider.isEmpty) {
          return _buildEmptyView();
        }

        return _buildPostsListView();
      },
    );
  }

  Widget _buildPostsListView() {
    return Consumer<MyPostProvider>(
      builder: (context, provider, _) {
        return RefreshIndicator(
          onRefresh: () async => provider.refreshPosts(),
          color: AppConstants.appPrimaryColor,
          child: ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: provider.posts.length + (provider.isLoadingMore ? 1 : 0),
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              if (index >= provider.posts.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: LoadingWidget(size: 30, showMessage: false),
                  ),
                );
              }

              final post = provider.posts[index];
              return MyPostCardWidget(
                post: post,
                onTap: () => _handlePostTap(post, index),
                onLike: () => _handleLikePost(post.id, index),
                onDelete: () => _handleDeletePost(post.id, post.title),
                onEdit: () => _handleEditPost(post),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildErrorView({
    required String message,
    required VoidCallback onRetry,
  }) {
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
              color: Colors.white.withOpacity(0.8),
              align: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
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
    return Consumer<MyPostProvider>(
      builder: (context, provider, _) {
        final isSearchEmpty = provider.isSearching;

        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isSearchEmpty ? Icons.search_off : Icons.post_add,
                  size: 64,
                  color: Colors.white.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                CommonTextWidget(
                  text: isSearchEmpty
                      ? 'No posts found for "${provider.searchQuery}"'
                      : 'No posts yet',
                  fontSize: 18,
                  color: Colors.white.withOpacity(0.7),
                  align: TextAlign.center,
                ),
                const SizedBox(height: 8),
                CommonTextWidget(
                  text: isSearchEmpty
                      ? 'Try searching with different keywords'
                      : 'Create your first post to get started',
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.5),
                  align: TextAlign.center,
                ),
                if (!isSearchEmpty) ...[
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => _handleCreatePost(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.appPrimaryColor,
                      foregroundColor: AppConstants.black,
                    ),
                    child: const CommonTextWidget(
                      text: 'Create Post',
                      color: AppConstants.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => _handleCreatePost(),
      backgroundColor: AppConstants.appPrimaryColor,
      child: const Icon(Icons.add, color: AppConstants.black),
    );
  }

  void _handleSearch(String query) {
    if (query.isEmpty) {
      _provider.clearSearch();
    } else {
      _provider.searchPosts(query);
    }
  }

  void _handleStatsCardTap() {
    // Navigate to detailed stats page if needed
    // context.push('/vjob/post-stats');
  }

  void _handlePostTap(MyPostEntity post, int index) {
    _provider.setSelectedPostIndex(index);
    context.push('/vjob/post-detail/${post.id}');
  }

  Future<void> _handleLikePost(String postId, int index) async {
    final result = await _provider.likePost(postId, index);
    result.handle(onError: (error) => context.showErrorSnackBar(error));
  }

  Future<void> _handleDeletePost(String postId, String postTitle) async {
    final confirmed = await _showDeleteConfirmation(postTitle);
    if (confirmed) {
      final result = await _provider.deletePost(postId);
      result.handle(
        onSuccess: (_) =>
            context.showSuccessSnackBar('Post deleted successfully'),
        onError: (error) => context.showErrorSnackBar(error),
      );
    }
  }

  void _handleEditPost(MyPostEntity post) {
    context.push('/vjob/edit-post/${post.id}');
  }

  void _handleCreatePost() {
    context.push('/vjob/create-post');
  }

  Future<bool> _showDeleteConfirmation(String postTitle) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppConstants.black,
            title: const CommonTextWidget(
              text: 'Delete Post',
              color: AppConstants.white,
              fontWeight: FontWeight.w600,
            ),
            content: CommonTextWidget(
              text:
                  'Are you sure you want to delete "$postTitle"? This action cannot be undone.',
              color: AppConstants.white.withOpacity(0.8),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: CommonTextWidget(
                  text: 'Cancel',
                  color: AppConstants.white.withOpacity(0.7),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const CommonTextWidget(
                  text: 'Delete',
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ) ??
        false;
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livera/core/utils/extensions.dart';
import 'package:livera/core/utils/result.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/loading/loading_widget.dart';
import '../../../mypost_view/domain/entities/my_post_entity.dart'
    as user_entity;
import '../../../mypost_view/domain/entities/my_post_entity.dart';
import '../../domain/entities/home_job_entity.dart';
import '../../domain/entities/post_entity.dart';
import '../providers/jobs_provider.dart';
import '../providers/posts_provider.dart';
import 'widgets/job_card_widget.dart';
import 'widgets/post_card_widget.dart';
import 'widgets/vjob_home_app_bar.dart';

class VJobHomePage extends StatefulWidget {
  const VJobHomePage({super.key});

  @override
  State<VJobHomePage> createState() => _VJobHomePageState();
}

class _VJobHomePageState extends State<VJobHomePage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
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
        final postsProvider = context.read<PostsProvider>();
        final jobsProvider = context.read<JobsProvider>();

        if (postsProvider.isPostViewMode) {
          if (!postsProvider.isLoadingMore && postsProvider.hasMoreData) {
            postsProvider.getPosts(isLoadMore: true);
          }
        } else {
          if (!jobsProvider.isLoadingMore && jobsProvider.hasMoreData) {
            jobsProvider.getJobs(isLoadMore: true);
          }
        }
      }
    });
  }

  void _initializeData() {
    context.read<JobsProvider>().getJobs();
    context.read<PostsProvider>().getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: VJobHomeAppBar(
        onSearchTap: () => _handleSearchTap(),
        onToggleView: () => _handleToggleView(),
      ),
      body: Consumer<PostsProvider>(
        builder: (context, postsProvider, _) {
          return postsProvider.isPostViewMode
              ? _buildPostsView()
              : _buildJobsView();
        },
      ),
    );
  }

  Widget _buildJobsView() {
    return Consumer<JobsProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: LoadingWidget(message: 'Loading jobs...'));
        }

        if (provider.status == JobsStatus.error) {
          return _buildErrorView(
            message: provider.errorMessage,
            onRetry: () => provider.getJobs(),
          );
        }

        if (provider.isEmpty) {
          return _buildEmptyView('No jobs available');
        }

        return RefreshIndicator(
          onRefresh: () => provider.getJobs(),
          color: AppConstants.appPrimaryColor,
          child: ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: provider.jobs.length + (provider.isLoadingMore ? 1 : 0),
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              if (index >= provider.jobs.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: LoadingWidget(size: 30, showMessage: false),
                  ),
                );
              }

              final job = provider.jobs[index];
              return JobCardWidget(
                job: job,
                onTap: () => _handleJobTap(job, index),
                onSave: () => _handleSaveJob(job.id, index),
                onApply: () => _handleApplyJob(job.id, index),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPostsView() {
    return Consumer<PostsProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(
            child: LoadingWidget(message: 'Loading posts...'),
          );
        }

        if (provider.status == PostsStatus.error) {
          return _buildErrorView(
            message: provider.errorMessage,
            onRetry: () => provider.getPosts(),
          );
        }

        if (provider.isEmpty) {
          return _buildEmptyView('No posts available');
        }

        return RefreshIndicator(
          onRefresh: () => provider.getPosts(),
          color: AppConstants.appPrimaryColor,
          child: ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: provider.posts.length + (provider.isLoadingMore ? 1 : 0),
            separatorBuilder: (context, index) => const SizedBox(height: 20),
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
              return PostCardWidget(
                post: post,
                onTap: () => _handlePostTap(post, index),
                onLike: () => _handleLikePost(post.id, index),
              );
            },
          ),
        );
      },
    );
  }

  void _handlePostTap(PostEntity post, int index) {
    final data = MyPostEntity(
      id: post.id,
      title: post.title,
      description: post.description,
      createdAt: post.createdAt,
      updatedAt: post.updatedAt,
      likes: post.likes,
      isLiked: post.isLiked,
      likesCount: post.likesCount,
      image: post.image,
      user: user_entity.UserEntity(id: post.user.id, name: post.user.name),
    );
    context.read<PostsProvider>().setSelectedPostIndex(index);
    context.push(
      '/vjob/post-detail/${post.id}',
      extra: {'post': data, 'owner': false},
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

  Widget _buildEmptyView(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Colors.white.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            CommonTextWidget(
              text: message,
              fontSize: 16,
              color: Colors.white.withOpacity(0.7),
              align: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _handleSearchTap() {
    // Navigate to search page
    context.push('/vjob/search');
  }

  void _handleToggleView() {
    context.read<PostsProvider>().toggleViewMode();
  }

  void _handleJobTap(HomeJobEntity job, int index) {
    context.read<JobsProvider>().setSelectedJobIndex(index);
    context.push('/vjob/job-details/${job.id}');
  }

  Future<void> _handleSaveJob(String jobId, int index) async {
    final result = await context.read<JobsProvider>().saveJob(jobId, index);

    result.handle(
      onSuccess: (success) {
        if (success) {
          context.showSuccessSnackBar('Job saved successfully');
        }
      },
      onError: (error) {
        context.showErrorSnackBar(error);
      },
    );
  }

  Future<void> _handleApplyJob(String jobId, int index) async {
    // Navigate to job application page
    context.push('/vjob/apply/$jobId');
  }

  Future<void> _handleLikePost(String postId, int index) async {
    final result = await context.read<PostsProvider>().likePost(postId, index);

    result.handle(
      onError: (error) {
        context.showErrorSnackBar(error);
      },
    );
  }
}

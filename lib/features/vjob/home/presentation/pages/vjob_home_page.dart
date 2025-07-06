import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/app_bar.dart';
import '../../../../../core/widgets/loading/loading_widget.dart';
import '../providers/vjob_home_provider.dart';
import '../widgets/job_error_widget.dart';
import '../widgets/job_list.dart';
import '../widgets/post_list.dart';
import '../widgets/view_toggle_widget.dart';
import '../widgets/vjob_search_bar.dart';

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
      context.read<VJobHomeProvider>().initializeHome();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _setupScrollController() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        final provider = context.read<VJobHomeProvider>();
        if (!provider.isPostJob &&
            !provider.isLoadingMore &&
            provider.hasMoreJobs) {
          provider.loadMoreJobs();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: const CommonAppBar(title: 'Jobs', showBackButton: true),
      body: Consumer<VJobHomeProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading &&
              provider.jobs.isEmpty &&
              provider.posts.isEmpty) {
            return const Center(child: LoadingWidget());
          }

          if (provider.hasError &&
              provider.jobs.isEmpty &&
              provider.posts.isEmpty) {
            return JobErrorWidget(
              message: provider.errorMessage ?? 'Something went wrong',
              onRetry: () => provider.loadJobs(forceRefresh: true),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadJobs(forceRefresh: true),
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const VJobSearchBar(),
                      const SizedBox(height: 16),
                      const ViewToggleWidget(),
                      const SizedBox(height: 16),
                    ]),
                  ),
                ),
                provider.isPostJob ? const PostList() : const JobList(),
              ],
            ),
          );
        },
      ),
    );
  }
}

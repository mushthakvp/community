import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/constants/app_constants.dart';
import '../../../../../../core/utils/extensions.dart';
import '../../../../../../core/utils/result.dart';
import '../../../../../../core/widgets/common/text_widget.dart';
import '../../../../../../core/widgets/loading/loading_widget.dart';
import '../../domain/entities/my_job_entity.dart';
import '../providers/my_jobs_provider.dart';
import 'widgets/applied_jobs_tab.dart';
import 'widgets/saved_jobs_tab.dart';

class MyJobsPage extends StatefulWidget {
  const MyJobsPage({super.key});

  @override
  State<MyJobsPage> createState() => _MyJobsPageState();
}

class _MyJobsPageState extends State<MyJobsPage>
    with SingleTickerProviderStateMixin {
  late MyJobsProvider _provider;
  late TabController _tabController;
  final List<String> _tabLabels = ["Applied Jobs", "Saved Jobs"];

  @override
  void initState() {
    super.initState();
    _provider = context.read<MyJobsProvider>();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.getJobs(status: MyJobStatus.applied);
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
      appBar: _buildAppBar(),
      body: Consumer<MyJobsProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              _buildTabSelector(provider),
              Expanded(child: _buildContent(provider)),
            ],
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppConstants.black,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppConstants.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: false,
      title: CommonTextWidget(
        text: 'My Jobs',
        color: AppConstants.white,
        fontSize: 24,
        fontWeight: FontWeight.w700,
        fontFamily: GoogleFonts.urbanist().fontFamily,
      ),
    );
  }

  /// Build the tab selector
  Widget _buildTabSelector(MyJobsProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: FlutterToggleTab(
        width: 100,
        height: 60,
        borderRadius: 10,
        marginSelected: const EdgeInsets.all(5),
        selectedBackgroundColors: const [AppConstants.appPrimaryColor],
        unSelectedBackgroundColors: const [Color(0xff161616)],
        selectedIndex: provider.currentTabStatus == MyJobStatus.applied ? 0 : 1,
        selectedTextStyle: const TextStyle(
          color: AppConstants.black,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unSelectedTextStyle: TextStyle(
          color: AppConstants.white.withOpacity(0.6),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        dataTabs: _tabLabels.map((label) => DataTab(title: label)).toList(),
        selectedLabelIndex: (index) => _onTabChanged(index, provider),
      ),
    );
  }

  Widget _buildContent(MyJobsProvider provider) {
    if (provider.isFirstTimeLoading) {
      return const Center(child: LoadingWidget(message: 'Loading jobs...'));
    }

    if (provider.status == MyJobsStatus.error) {
      return _buildErrorView(provider);
    }

    if (provider.isEmpty) {
      return _buildEmptyView(provider);
    }

    return provider.currentTabStatus == MyJobStatus.applied
        ? AppliedJobsTab(
            jobs: provider.jobs,
            isLoadingMore: provider.isLoadingMore,
            hasMoreData: provider.hasMoreData,
            onLoadMore: () => provider.loadMore(),
            onJobTap: _handleJobTap,
            onRefresh: () => provider.refresh(),
          )
        : SavedJobsTab(
            jobs: provider.jobs,
            isLoadingMore: provider.isLoadingMore,
            hasMoreData: provider.hasMoreData,
            onLoadMore: () => provider.loadMore(),
            onJobTap: _handleJobTap,
            onUnsave: _handleUnsaveJob,
            onRefresh: () => provider.refresh(),
          );
  }

  /// Build error view
  Widget _buildErrorView(MyJobsProvider provider) {
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
              text: provider.errorMessage,
              fontSize: 16,
              color: AppConstants.white.withOpacity(0.8),
              align: TextAlign.center,
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => provider.refresh(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.appPrimaryColor,
                foregroundColor: AppConstants.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
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

  /// Build empty view
  Widget _buildEmptyView(MyJobsProvider provider) {
    final isApplied = provider.currentTabStatus == MyJobStatus.applied;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isApplied ? Icons.work_outline : Icons.bookmark_outline,
              size: 64,
              color: AppConstants.white.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            CommonTextWidget(
              text: isApplied ? 'No Applied Jobs' : 'No Saved Jobs',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppConstants.white.withOpacity(0.8),
            ),
            const SizedBox(height: 8),
            CommonTextWidget(
              text: isApplied
                  ? 'You haven\'t applied to any jobs yet.\nStart exploring and apply to your dream job!'
                  : 'You haven\'t saved any jobs yet.\nSave interesting jobs to view them later.',
              fontSize: 14,
              color: AppConstants.white.withOpacity(0.6),
              align: TextAlign.center,
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Navigate to job search/browse
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.appPrimaryColor,
                foregroundColor: AppConstants.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: CommonTextWidget(
                text: isApplied ? 'Browse Jobs' : 'Find Jobs',
                color: AppConstants.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Handle tab change
  void _onTabChanged(int index, MyJobsProvider provider) {
    final newStatus = index == 0 ? MyJobStatus.applied : MyJobStatus.saved;
    provider.setTabStatus(newStatus);
  }

  /// Handle job tap
  void _handleJobTap(MyJobEntity job) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigate to job: ${job.jobDetails.title}'),
        backgroundColor: AppConstants.appPrimaryColor,
      ),
    );
  }

  /// Handle unsave job
  Future<void> _handleUnsaveJob(MyJobEntity job, int index) async {
    final result = await _provider.removeJob(job.id, index);
    result.handle(
      onSuccess: (success) {
        if (success) {
          context.showSuccessSnackBar('Job removed successfully');
        }
      },
      onError: (error) {
        context.showErrorSnackBar(error);
      },
    );
  }
}

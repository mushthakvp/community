import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_constants.dart';
import '../../../../../../core/widgets/loading/loading_widget.dart';
import '../../../domain/entities/my_job_entity.dart';
import 'my_job_card_widget.dart';

/// Tab widget for displaying applied jobs
class AppliedJobsTab extends StatefulWidget {
  final List<MyJobEntity> jobs;
  final bool isLoadingMore;
  final bool hasMoreData;
  final VoidCallback onLoadMore;
  final Function(MyJobEntity) onJobTap;
  final VoidCallback onRefresh;

  const AppliedJobsTab({
    super.key,
    required this.jobs,
    required this.isLoadingMore,
    required this.hasMoreData,
    required this.onLoadMore,
    required this.onJobTap,
    required this.onRefresh,
  });

  @override
  State<AppliedJobsTab> createState() => _AppliedJobsTabState();
}

class _AppliedJobsTabState extends State<AppliedJobsTab> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _setupScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _setupScrollController() {
    _scrollController.addListener(() {
      // Trigger load more when reaching 80% of the scroll extent
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.8) {
        if (!widget.isLoadingMore && widget.hasMoreData) {
          widget.onLoadMore();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.jobs.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async => widget.onRefresh(),
      color: AppConstants.appPrimaryColor,
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: widget.jobs.length + (widget.isLoadingMore ? 1 : 0),
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          // Show loading indicator at the end
          if (index >= widget.jobs.length) {
            return _buildLoadingMore();
          }

          final job = widget.jobs[index];
          return AppliedJobCardWidget(
            job: job,
            onTap: () => widget.onJobTap(job),
          );
        },
      ),
    );
  }

  /// Build empty state widget
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.work_outline,
              size: 64,
              color: AppConstants.white.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No Applied Jobs',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppConstants.white.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You haven\'t applied to any jobs yet.\nStart exploring and apply to your dream job!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppConstants.white.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build loading more indicator
  Widget _buildLoadingMore() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Center(child: LoadingWidget(size: 30, showMessage: false)),
    );
  }
}

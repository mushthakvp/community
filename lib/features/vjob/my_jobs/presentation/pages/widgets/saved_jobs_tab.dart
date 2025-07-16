import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_constants.dart';
import '../../../../../../core/widgets/loading/loading_widget.dart';
import '../../../domain/entities/my_job_entity.dart';
import 'my_job_card_widget.dart';

/// Tab widget for displaying saved jobs
class SavedJobsTab extends StatefulWidget {
  final List<MyJobEntity> jobs;
  final bool isLoadingMore;
  final bool hasMoreData;
  final VoidCallback onLoadMore;
  final Function(MyJobEntity) onJobTap;
  final Function(MyJobEntity, int) onUnsave;
  final VoidCallback onRefresh;

  const SavedJobsTab({
    super.key,
    required this.jobs,
    required this.isLoadingMore,
    required this.hasMoreData,
    required this.onLoadMore,
    required this.onJobTap,
    required this.onUnsave,
    required this.onRefresh,
  });

  @override
  State<SavedJobsTab> createState() => _SavedJobsTabState();
}

class _SavedJobsTabState extends State<SavedJobsTab> {
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
          return _buildJobCard(job, index);
        },
      ),
    );
  }

  /// Build job card with unsave functionality
  Widget _buildJobCard(MyJobEntity job, int index) {
    return SavedJobCardWidget(
      job: job,
      onTap: () => widget.onJobTap(job),
      onUnsave: () => _showUnsaveConfirmation(job, index),
    );
  }

  /// Show confirmation dialog before unsaving
  void _showUnsaveConfirmation(MyJobEntity job, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xff1E1E1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Remove Saved Job',
            style: TextStyle(
              color: AppConstants.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Are you sure you want to remove "${job.jobDetails.title}" from your saved jobs?',
            style: TextStyle(color: AppConstants.white.withOpacity(0.8)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppConstants.white.withOpacity(0.7)),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onUnsave(job, index);
              },
              child: const Text(
                'Remove',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
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
              Icons.bookmark_outline,
              size: 64,
              color: AppConstants.white.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No Saved Jobs',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppConstants.white.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You haven\'t saved any jobs yet.\nSave interesting jobs to view them later.',
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

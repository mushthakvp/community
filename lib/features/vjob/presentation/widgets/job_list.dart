import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../providers/vjob_provider.dart';
import 'apply_job_dialog.dart';
import 'empty_jobs_widget.dart';
import 'job_card.dart';

class JobList extends StatefulWidget {
  const JobList({super.key});

  @override
  State<JobList> createState() => _JobListState();
}

class _JobListState extends State<JobList> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      context.read<VJobProvider>().loadMoreJobs();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VJobProvider>(
      builder: (context, provider, child) {
        if (provider.jobs.isEmpty) {
          return SliverToBoxAdapter(
            child: EmptyJobsWidget(
              message: provider.searchQuery.isNotEmpty
                  ? 'No jobs found for "${provider.searchQuery}"'
                  : 'No jobs available at the moment',
              onRefresh: () => provider.loadJobs(forceRefresh: true),
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index < provider.jobs.length) {
                  final job = provider.jobs[index];
                  return JobCard(
                    job: job,
                    onTap: () => _navigateToJobDetails(context, job.id),
                    onSave: () => provider.saveJob(job.id),
                    onApply: () => _showApplyDialog(context, job.id),
                  );
                } else if (provider.hasMoreData) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppConstants.appPrimaryColor,
                      ),
                    ),
                  );
                }
                return null;
              },
              childCount: provider.jobs.length + (provider.hasMoreData ? 1 : 0),
            ),
          ),
        );
      },
    );
  }

  void _navigateToJobDetails(BuildContext context, String jobId) {
    // Navigate to job details page
    // Navigator.pushNamed(context, '/job-details', arguments: jobId);
  }

  void _showApplyDialog(BuildContext context, String jobId) {
    showDialog(
      context: context,
      builder: (context) => ApplyJobDialog(jobId: jobId),
    );
  }
}

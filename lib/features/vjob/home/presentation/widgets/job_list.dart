import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/widgets/loading/loading_widget.dart';
import '../providers/vjob_home_provider.dart';
import 'empty_jobs_widget.dart';
import 'job_card.dart';

class JobList extends StatelessWidget {
  const JobList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<VJobHomeProvider>(
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

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index < provider.jobs.length) {
                final job = provider.jobs[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: JobCard(
                    job: job,
                    onSave: () => provider.saveJob(job.id, index),
                    onApply: (resume) =>
                        provider.applyJob(jobId: job.id, resume: resume),
                  ),
                );
              } else if (provider.isLoadingMore) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: LoadingWidget()),
                );
              }
              return null;
            },
            childCount: provider.jobs.length + (provider.isLoadingMore ? 1 : 0),
          ),
        );
      },
    );
  }
}

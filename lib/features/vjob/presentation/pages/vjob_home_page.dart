import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/app_bar.dart';
import '../../../../core/widgets/loading/loading_widget.dart';
import '../providers/vjob_provider.dart';
import '../widgets/job_error_widget.dart';
import '../widgets/job_filter_widgets.dart';
import '../widgets/job_list.dart';
import '../widgets/job_search_bar.dart';

class VJobHomePage extends StatefulWidget {
  const VJobHomePage({super.key});

  @override
  State<VJobHomePage> createState() => _VJobHomePageState();
}

class _VJobHomePageState extends State<VJobHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VJobProvider>().initializeJobs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: const CommonAppBar(title: 'Jobs', showBackButton: true),
      body: Consumer<VJobProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.jobs.isEmpty) {
            return const Center(child: LoadingWidget());
          }

          if (provider.hasError && provider.jobs.isEmpty) {
            return JobErrorWidget(
              message: provider.errorMessage ?? 'Something went wrong',
              onRetry: () => provider.loadJobs(forceRefresh: true),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.refreshJobs(),
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const JobSearchBar(),
                      const SizedBox(height: 16),
                      const JobFilterWidgets(),
                    ]),
                  ),
                ),
                const JobList(),
              ],
            ),
          );
        },
      ),
    );
  }
}

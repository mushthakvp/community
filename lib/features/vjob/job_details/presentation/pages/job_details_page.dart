import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:livera/core/utils/result.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/utils/extensions.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/loading/loading_widget.dart';
import '../providers/job_details_provider.dart';
import 'widgets/cv_upload_bottom_sheet.dart';
import 'widgets/job_details_tab_widget.dart';
import 'widgets/job_header_widget.dart';
import 'widgets/profile_insights_tab_widget.dart';
import 'widgets/sticky_tab_bar_delegate.dart';

class JobDetailsPage extends StatefulWidget {
  final String jobId;

  const JobDetailsPage({super.key, required this.jobId});

  @override
  State<JobDetailsPage> createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  final List<String> _tabLabels = ["Profile Insights", "Job Details"];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<JobDetailsProvider>().getJobDetails(widget.jobId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      body: Consumer<JobDetailsProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(
              child: LoadingWidget(message: 'Loading job details...'),
            );
          }

          if (provider.status == JobDetailsStatus.error) {
            return _buildErrorView(provider.errorMessage);
          }

          if (provider.jobDetails == null) {
            return _buildEmptyView();
          }

          return SafeArea(
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  _buildAppBar(),
                  SliverToBoxAdapter(
                    child: JobHeaderWidget(jobDetails: provider.jobDetails!),
                  ),
                  _buildStickyTabBar(provider),
                ];
              },
              body: _buildTabContent(provider),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: AppConstants.black,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppConstants.white),
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: false,
      title: const CommonTextWidget(
        text: 'Job Details',
        color: AppConstants.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      floating: true,
      pinned: true,
    );
  }

  Widget _buildStickyTabBar(JobDetailsProvider provider) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: StickyTabBarDelegate(
        FlutterToggleTab(
          width: 100,
          height: 60,
          borderRadius: 10,
          marginSelected: const EdgeInsets.all(5),
          selectedBackgroundColors: const [AppConstants.appPrimaryColor],
          unSelectedBackgroundColors: const [Color(0xff161616)],
          selectedIndex: provider.tabIndex,
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
          selectedLabelIndex: (index) {
            provider.setTabIndex(index);
          },
        ),
      ),
    );
  }

  Widget _buildTabContent(JobDetailsProvider provider) {
    return provider.tabIndex == 0
        ? ProfileInsightsTabWidget(jobDetails: provider.jobDetails!)
        : JobDetailsTabWidget(jobDetails: provider.jobDetails!);
  }

  Widget _buildFloatingActionButton() {
    return Consumer<JobDetailsProvider>(
      builder: (context, provider, _) {
        if (provider.jobDetails == null) return const SizedBox.shrink();

        return Container(
          height: 92,
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: const Color(0xff161616),
          child: provider.jobDetails!.isApplied
              ? _buildAppliedButton()
              : _buildActionButtons(provider),
        );
      },
    );
  }

  Widget _buildAppliedButton() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AppConstants.appPrimaryColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Center(
        child: CommonTextWidget(
          text: 'Applied',
          color: AppConstants.black,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildActionButtons(JobDetailsProvider provider) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _showApplyBottomSheet(),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: AppConstants.appPrimaryColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Center(
                child: CommonTextWidget(
                  text: 'Apply Now',
                  color: AppConstants.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        GestureDetector(
          onTap: () => _handleSaveJob(provider),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppConstants.black.withOpacity(0.3)),
            ),
            child: Icon(
              provider.jobDetails!.isSaved
                  ? Icons.bookmark
                  : Icons.bookmark_border,
              color: provider.jobDetails!.isSaved
                  ? AppConstants.appPrimaryColor
                  : AppConstants.white.withOpacity(0.7),
              size: 24,
            ),
          ),
        ),
      ],
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
                context.read<JobDetailsProvider>().getJobDetails(widget.jobId);
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
    return const Center(
      child: CommonTextWidget(
        text: 'Job details not found',
        fontSize: 16,
        color: AppConstants.white,
      ),
    );
  }

  void _showApplyBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xff161616),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      builder: (context) => const CVUploadBottomSheet(),
    );
  }

  Future<void> _handleSaveJob(JobDetailsProvider provider) async {
    final result = await provider.saveJob();
    if (mounted) {
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
  }
}

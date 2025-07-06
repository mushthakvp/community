import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livera/core/widgets/buttons/primary_button.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/utils/extensions.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/loading/loading_widget.dart';
import '../providers/create_job_provider.dart';
import '../widgets/job_details_tab.dart';
import '../widgets/job_form_tab.dart';

class CreateJobPage extends StatefulWidget {
  final String? jobId;

  const CreateJobPage({super.key, this.jobId});

  @override
  State<CreateJobPage> createState() => _CreateJobPageState();
}

class _CreateJobPageState extends State<CreateJobPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<CreateJobProvider>();
      provider.getJobTitles();

      if (widget.jobId != null) {
        provider.setEditMode(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: _buildAppBar(),
      body: Consumer<CreateJobProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(
              child: LoadingWidget(message: 'Loading job data...'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProgressIndicator(provider),
                const SizedBox(height: 24),
                _buildTitle(),
                const SizedBox(height: 8),
                _buildSubtitle(),
                const SizedBox(height: 32),
                _buildContent(provider),
                const SizedBox(height: 32),
                _buildActionButton(provider),
                const SizedBox(height: 16),
              ],
            ),
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
        onPressed: () => context.pop(),
      ),
      title: CommonTextWidget(
        text: widget.jobId != null ? 'Edit Job' : 'Create Job',
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppConstants.white,
      ),
      centerTitle: false,
    );
  }

  Widget _buildProgressIndicator(CreateJobProvider provider) {
    return SizedBox(
      height: 100,
      child: Row(
        children: [
          _buildProgressStep(
            isActive: provider.currentTabIndex == 0,
            isCompleted: provider.currentTabIndex > 0,
            title: 'Job Details',
            onTap: () => provider.setTabIndex(0),
          ),
          Expanded(
            child: Container(
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: provider.currentTabIndex > 0
                    ? AppConstants.appPrimaryColor
                    : AppConstants.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
          _buildProgressStep(
            isActive: provider.currentTabIndex == 1,
            isCompleted: false,
            title: 'Description',
            onTap: () => provider.setTabIndex(1),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStep({
    required bool isActive,
    required bool isCompleted,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted || isActive
                  ? AppConstants.appPrimaryColor
                  : const Color(0xff262626),
              border: Border.all(
                color: isActive
                    ? AppConstants.appPrimaryColor
                    : AppConstants.white.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: Icon(
              isCompleted ? Icons.check : Icons.circle,
              size: isCompleted ? 20 : 8,
              color: isCompleted || isActive
                  ? AppConstants.black
                  : AppConstants.white.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 8),
          CommonTextWidget(
            text: title,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: isActive
                ? AppConstants.white
                : AppConstants.white.withOpacity(0.6),
            align: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return const CommonTextWidget(
      text: 'Post Your Job Vacancy',
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: AppConstants.white,
      align: TextAlign.center,
    );
  }

  Widget _buildSubtitle() {
    return const CommonTextWidget(
      text:
          'Reach a wide audience of job seekers and find the ideal candidate for your team.',
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppConstants.white,
      align: TextAlign.center,
      maxLines: 2,
    );
  }

  Widget _buildContent(CreateJobProvider provider) {
    if (provider.status == CreateJobStatus.error) {
      return _buildErrorView(provider);
    }

    return provider.currentTabIndex == 0
        ? const JobFormTab()
        : const JobDetailsTab();
  }

  Widget _buildErrorView(CreateJobProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: CommonTextWidget(
              text: provider.errorMessage,
              fontSize: 14,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(CreateJobProvider provider) {
    return PrimaryButton(
      onPressed: provider.isCreating
          ? null
          : () => _handleButtonPress(provider),
      text: provider.currentTabIndex == 0
          ? 'Next'
          : _getSubmitButtonText(provider),
      isLoading: provider.isCreating,
      backgroundColor: AppConstants.appPrimaryColor,
      textColor: AppConstants.black,
      borderRadius: 12,
      height: 56,
    );
  }

  String _getSubmitButtonText(CreateJobProvider provider) {
    if (provider.isCreating) return 'Creating...';
    return provider.isEditMode ? 'Update Job' : 'Create Job';
  }

  Future<void> _handleButtonPress(CreateJobProvider provider) async {
    if (provider.currentTabIndex == 0) {
      provider.setTabIndex(1);
    } else {
      final success = await provider.createJob();
      if (success && mounted) {
        context.showSuccessSnackBar(
          provider.isEditMode
              ? 'Job updated successfully!'
              : 'Job created successfully!',
        );
        context.pop();
      } else if (mounted) {
        context.showErrorSnackBar(provider.errorMessage);
      }
    }
  }
}

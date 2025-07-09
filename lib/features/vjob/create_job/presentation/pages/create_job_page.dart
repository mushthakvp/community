import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livera/core/widgets/buttons/primary_button.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/utils/extensions.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/loading/loading_widget.dart';
import '../../../my_company/presentation/providers/my_company_provider.dart';
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
  bool _isCheckingCompany = true;
  bool _hasCompany = false;

  @override
  void initState() {
    super.initState();
    _checkCompanyAndInitialize();
  }

  Future<void> _checkCompanyAndInitialize() async {
    final companyProvider = context.read<MyCompanyProvider>();
    final jobProvider = context.read<CreateJobProvider>();

    try {
      // Check if user has a company
      await companyProvider.getMyCompany();

      if (companyProvider.company != null) {
        setState(() {
          _hasCompany = true;
          _isCheckingCompany = false;
        });

        // Set company ID in job provider
        jobProvider.setCompanyId(companyProvider.company!.id);

        // Initialize job titles and edit mode
        await jobProvider.getJobTitles();

        if (widget.jobId != null) {
          jobProvider.setEditMode(true);
        }
      } else {
        setState(() {
          _hasCompany = false;
          _isCheckingCompany = false;
        });
      }
    } catch (e) {
      setState(() {
        _hasCompany = false;
        _isCheckingCompany = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: _buildAppBar(),
      body: _buildBody(),
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

  Widget _buildBody() {
    if (_isCheckingCompany) {
      return const Center(
        child: LoadingWidget(message: 'Checking company status...'),
      );
    }

    if (!_hasCompany) {
      return _buildNoCompanyView();
    }

    return Consumer<CreateJobProvider>(
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
    );
  }

  Widget _buildNoCompanyView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppConstants.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.business_outlined,
                size: 64,
                color: AppConstants.white,
              ),
            ),
            const SizedBox(height: 24),
            const CommonTextWidget(
              text: 'Company Required',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppConstants.white,
              align: TextAlign.center,
            ),
            const SizedBox(height: 12),
            CommonTextWidget(
              text:
                  'You need to register a company first before creating job posts. Please register your company to continue.',
              fontSize: 16,
              color: AppConstants.white.withOpacity(0.6),
              align: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => context.pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.white.withOpacity(0.1),
                      foregroundColor: AppConstants.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const CommonTextWidget(
                      text: 'Cancel',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppConstants.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.push(RouteConstants.vjobCreateCompany);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.appPrimaryColor,
                      foregroundColor: AppConstants.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const CommonTextWidget(
                      text: 'Register Company',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppConstants.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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

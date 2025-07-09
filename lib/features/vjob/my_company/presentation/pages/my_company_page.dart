import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livera/core/utils/result.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/utils/extensions.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/loading/loading_widget.dart';
import '../../domain/entities/created_job_entity.dart';
import '../providers/my_company_provider.dart';
import '../widgets/company_details_widget.dart';
import '../widgets/created_jobs_list_widget.dart';
import '../widgets/job_status_filter_widget.dart';

class MyCompanyPage extends StatefulWidget {
  const MyCompanyPage({super.key});

  @override
  State<MyCompanyPage> createState() => _MyCompanyPageState();
}

class _MyCompanyPageState extends State<MyCompanyPage> {
  late ScrollController _scrollController;
  late MyCompanyProvider _provider;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _provider = context.read<MyCompanyProvider>();
    _setupScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.getMyCompany();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _setupScrollController() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.8) {
        if (!_provider.isJobsLoadingMore && _provider.hasMoreJobs) {
          _provider.getCreatedJobs(isLoadMore: true);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff1a1a1a), AppConstants.black],
          ),
        ),
        child: Consumer<MyCompanyProvider>(
          builder: (context, provider, _) {
            if (provider.companyStatus == MyCompanyStatus.loading) {
              return const Center(
                child: LoadingWidget(message: 'Loading company details...'),
              );
            }

            if (provider.companyStatus == MyCompanyStatus.empty) {
              return _buildEmptyCompanyView();
            }

            if (provider.companyStatus == MyCompanyStatus.error) {
              return _buildErrorView(
                message: provider.companyErrorMessage,
                onRetry: () => provider.getMyCompany(),
              );
            }

            return _buildCompanyView(provider);
          },
        ),
      ),
    );
  }

  Widget _buildCompanyView(MyCompanyProvider provider) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        _buildAppBar(provider),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              if (provider.company != null) ...[
                CompanyDetailsWidget(
                  company: provider.company!,
                  placeName: provider.placeName,
                  onEdit: () => _handleEditCompany(),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CommonTextWidget(
                      text: 'Created Posts',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.white,
                    ),
                    JobStatusFilterWidget(
                      selectedStatus: provider.selectedStatus,
                      statusList: provider.statusList,
                      onStatusChanged: (status) => provider.setStatus(status),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CreatedJobsListWidget(
                  jobs: provider.createdJobs,
                  status: provider.jobsStatus,
                  errorMessage: provider.jobsErrorMessage,
                  isLoadingMore: provider.isJobsLoadingMore,
                  onRetry: () => provider.getCreatedJobs(),
                  onJobTap: (job) => _handleJobTap(job),
                  onReapply: (jobId) => _handleReapplyJob(jobId),
                  onMarkClosed: (jobId) => _handleMarkJobClosed(jobId),
                ),
              ],
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(MyCompanyProvider provider) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      floating: true,
      pinned: true,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: const Icon(Icons.arrow_back, color: AppConstants.white),
      ),
      title: const CommonTextWidget(
        text: 'My Company',
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppConstants.white,
      ),
      actions: [
        if (provider.company != null)
          IconButton(
            onPressed: () => _handleEditCompany(),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xff161616),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.edit,
                color: AppConstants.white,
                size: 16,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyCompanyView() {
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
              text: 'No Companies Found',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppConstants.white,
              align: TextAlign.center,
            ),
            const SizedBox(height: 12),
            CommonTextWidget(
              text:
                  'No companies have been registered yet.\nPlease register your company to start posting jobs',
              fontSize: 16,
              color: AppConstants.white.withOpacity(0.6),
              align: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => _handleRegisterCompany(),
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
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView({
    required String message,
    required VoidCallback onRetry,
  }) {
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
              onPressed: onRetry,
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

  void _handleEditCompany() {
    context.push(RouteConstants.vjobCreateCompany);
  }

  void _handleRegisterCompany() {
    context.push(RouteConstants.vjobCreateCompany);
  }

  void _handleJobTap(CreatedJobEntity job) {
    context.push('/vjob/company-job-details/${job.id}');
  }

  Future<void> _handleReapplyJob(String jobId) async {
    final result = await _provider.reapplyJob(jobId);

    result.handle(
      onSuccess: (success) {
        if (success) {
          context.showSuccessSnackBar('Job reapplied successfully');
        }
      },
      onError: (error) {
        context.showErrorSnackBar(error);
      },
    );
  }

  Future<void> _handleMarkJobClosed(String jobId) async {
    final result = await _provider.markJobAsClosed(jobId);

    result.handle(
      onSuccess: (success) {
        if (success) {
          context.showSuccessSnackBar('Job marked as closed successfully');
        }
      },
      onError: (error) {
        context.showErrorSnackBar(error);
      },
    );
  }
}

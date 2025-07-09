import 'package:flutter/material.dart';
import 'package:livera/core/widgets/buttons/primary_button.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/utils/extensions.dart';
import '../../../../../core/utils/result.dart';
import '../../../../../core/widgets/common/app_bar.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/loading/loading_widget.dart';
import '../../domain/entities/company_job_entity.dart';
import '../providers/company_job_provider.dart';
import 'widgets/candidate_list_widget.dart';
import 'widgets/job_overview_widget.dart';
import 'widgets/rejected_job_widget.dart';

class CompanyJobDetailsPage extends StatefulWidget {
  final CompanyJobEntity? job; // Make this nullable
  final String? jobId; // Add jobId as backup

  const CompanyJobDetailsPage({
    super.key,
    this.job, // Remove required
    this.jobId,
  });

  @override
  State<CompanyJobDetailsPage> createState() => _CompanyJobDetailsPageState();
}

class _CompanyJobDetailsPageState extends State<CompanyJobDetailsPage> {
  late ScrollController _scrollController;
  CompanyJobEntity? _currentJob;
  bool _isLoadingJob = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _setupScrollController();
    _currentJob = widget.job;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_currentJob != null) {
        // Job data is available, initialize with it
        context.read<CompanyJobProvider>().initializeWithJob(_currentJob!);
      } else if (widget.jobId != null) {
        // No job data, need to fetch using jobId
        _fetchJobDetails();
      }
    });
  }

  Future<void> _fetchJobDetails() async {
    if (widget.jobId == null) return;

    setState(() {
      _isLoadingJob = true;
    });

    try {
      final provider = context.read<CompanyJobProvider>();
      final result = await provider.getJobDetails(widget.jobId!);

      result.handle(
        onSuccess: (job) {
          setState(() {
            _currentJob = job;
            _isLoadingJob = false;
          });
          provider.initializeWithJob(job);
        },
        onError: (error) {
          setState(() {
            _isLoadingJob = false;
          });
          if (mounted) {
            context.showErrorSnackBar(error);
            Navigator.of(context).pop();
          }
        },
      );
    } catch (e) {
      setState(() {
        _isLoadingJob = false;
      });
      if (mounted) {
        context.showErrorSnackBar('Failed to load job details');
        Navigator.of(context).pop();
      }
    }
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
        final provider = context.read<CompanyJobProvider>();
        if (!provider.isLoadingMore && provider.hasMoreCandidates) {
          provider.getCandidates(provider.currentJobId, isLoadMore: true);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingJob) {
      return Scaffold(
        backgroundColor: AppConstants.black,
        appBar: CommonAppBar(title: 'Job Details'),
        body: const Center(
          child: LoadingWidget(message: 'Loading job details...'),
        ),
      );
    }

    if (_currentJob == null) {
      return Scaffold(
        backgroundColor: AppConstants.black,
        appBar: CommonAppBar(title: 'Job Details'),
        body: const Center(
          child: CommonTextWidget(
            text: 'Job not found',
            fontSize: 16,
            color: AppConstants.white,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: CommonAppBar(
        title: 'Job Details',
        actions: [
          if (!_currentJob!.isRejected)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GestureDetector(
                onTap: _handleEditJob,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xff161616),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.edit,
                    color: AppConstants.white,
                    size: 20,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Consumer<CompanyJobProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildJobInfoCard(),
                const SizedBox(height: 20),
                if (_currentJob!.isRejected)
                  RejectedJobWidget(
                    job: _currentJob!,
                    onReapply: _handleReapplyJob,
                  )
                else ...[
                  JobOverviewWidget(job: _currentJob!),
                  const SizedBox(height: 20),
                  CandidateListWidget(
                    candidates: provider.candidates,
                    isLoading: provider.isLoading,
                    isLoadingMore: provider.isLoadingMore,
                    hasMoreData: provider.hasMoreCandidates,
                    onDownloadCV: _handleDownloadCV,
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildJobInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff161616),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _buildJobHeader()),
              if (!_currentJob!.isRejected) ...[
                const SizedBox(width: 16),
                _buildMarkAsClosedButton(),
              ],
            ],
          ),
          const SizedBox(height: 16),
          _buildJobDetails(),
          const SizedBox(height: 12),
          _buildJobFooter(),
        ],
      ),
    );
  }

  Widget _buildJobHeader() {
    return Row(
      children: [
        _buildCompanyImage(),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonTextWidget(
                text: _currentJob!.title,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppConstants.white,
                maxLines: 2,
              ),
              const SizedBox(height: 4),
              CommonTextWidget(
                text: '${_currentJob!.city}, ${_currentJob!.state}',
                fontSize: 14,
                color: AppConstants.white.withOpacity(0.7),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompanyImage() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: AppConstants.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        image: _currentJob!.company.image != null
            ? DecorationImage(
                image: NetworkImage(_currentJob!.company.image!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: _currentJob!.company.image == null
          ? Icon(
              Icons.business,
              color: AppConstants.white.withOpacity(0.5),
              size: 28,
            )
          : null,
    );
  }

  Widget _buildMarkAsClosedButton() {
    return PrimaryButton(
      text: 'Mark as Closed',
      onPressed: _handleMarkAsClosed,
      backgroundColor: Colors.transparent,
      textColor: AppConstants.appPrimaryColor,
      borderColor: AppConstants.appPrimaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      fontSize: 14,
    );
  }

  Widget _buildJobDetails() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _currentJob!.schedule
          .map((schedule) => _buildDetailChip(schedule))
          .toList(),
    );
  }

  Widget _buildDetailChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppConstants.appPrimaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppConstants.appPrimaryColor.withOpacity(0.3),
        ),
      ),
      child: CommonTextWidget(
        text: text,
        fontSize: 12,
        color: AppConstants.appPrimaryColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildJobFooter() {
    final timeAgo = timeago.format(_currentJob!.createdAt);

    return Row(
      children: [
        _buildFooterItem(icon: Icons.access_time, text: timeAgo),
        const SizedBox(width: 16),
        _buildFooterItem(
          icon: Icons.attach_money,
          text: '\$${_currentJob!.minimumSalary}',
        ),
      ],
    );
  }

  Widget _buildFooterItem({required IconData icon, required String text}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppConstants.white.withOpacity(0.6)),
        const SizedBox(width: 4),
        CommonTextWidget(
          text: text,
          fontSize: 12,
          color: AppConstants.white.withOpacity(0.6),
        ),
      ],
    );
  }

  void _handleEditJob() {
    Navigator.pushNamed(context, '/vjob/edit-job', arguments: _currentJob);
  }

  Future<void> _handleMarkAsClosed() async {
    final provider = context.read<CompanyJobProvider>();
    final result = await provider.markJobAsClosed(_currentJob!.id);

    result.handle(
      onSuccess: (success) {
        if (success) {
          context.showSuccessSnackBar('Job marked as closed successfully');
          Navigator.pop(context, true);
        }
      },
      onError: (error) {
        context.showErrorSnackBar(error);
      },
    );
  }

  Future<void> _handleReapplyJob() async {
    final provider = context.read<CompanyJobProvider>();
    final result = await provider.reapplyJob(_currentJob!.id);

    result.handle(
      onSuccess: (success) {
        if (success) {
          context.showSuccessSnackBar('Job reapplied successfully');
          setState(() {});
        }
      },
      onError: (error) {
        context.showErrorSnackBar(error);
      },
    );
  }

  void _handleDownloadCV(String candidateId) {
    context.showInfoSnackBar('Downloading CV...');
  }
}

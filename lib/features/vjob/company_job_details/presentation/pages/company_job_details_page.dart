import 'package:flutter/material.dart';
import 'package:livera/core/widgets/buttons/primary_button.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/utils/extensions.dart';
import '../../../../../core/utils/result.dart';
import '../../../../../core/widgets/common/app_bar.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../domain/entities/company_job_entity.dart';
import '../providers/company_job_provider.dart';
import 'widgets/candidate_list_widget.dart';
import 'widgets/job_overview_widget.dart';
import 'widgets/rejected_job_widget.dart';

class CompanyJobDetailsPage extends StatefulWidget {
  final CompanyJobEntity job;

  const CompanyJobDetailsPage({super.key, required this.job});

  @override
  State<CompanyJobDetailsPage> createState() => _CompanyJobDetailsPageState();
}

class _CompanyJobDetailsPageState extends State<CompanyJobDetailsPage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _setupScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CompanyJobProvider>().initializeWithJob(widget.job);
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
        final provider = context.read<CompanyJobProvider>();
        if (!provider.isLoadingMore && provider.hasMoreCandidates) {
          provider.getCandidates(provider.currentJobId, isLoadMore: true);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: CommonAppBar(
        title: 'Job Details',
        actions: [
          if (!widget.job.isRejected)
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
                if (widget.job.isRejected)
                  RejectedJobWidget(
                    job: widget.job,
                    onReapply: _handleReapplyJob,
                  )
                else ...[
                  JobOverviewWidget(job: widget.job),
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
              if (!widget.job.isRejected) ...[
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
                text: widget.job.title,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppConstants.white,
                maxLines: 2,
              ),
              const SizedBox(height: 4),
              CommonTextWidget(
                text: '${widget.job.city}, ${widget.job.state}',
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
        image: widget.job.company.image != null
            ? DecorationImage(
                image: NetworkImage(widget.job.company.image!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: widget.job.company.image == null
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
      children: widget.job.schedule
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
    final timeAgo = timeago.format(widget.job.createdAt);

    return Row(
      children: [
        _buildFooterItem(icon: Icons.access_time, text: timeAgo),
        const SizedBox(width: 16),
        _buildFooterItem(
          icon: Icons.attach_money,
          text: '\$${widget.job.minimumSalary}',
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
    // Navigate to edit job page
    // You can implement this based on your routing setup
    Navigator.pushNamed(context, '/vjob/edit-job', arguments: widget.job);
  }

  Future<void> _handleMarkAsClosed() async {
    final provider = context.read<CompanyJobProvider>();
    final result = await provider.markJobAsClosed(widget.job.id);

    result.handle(
      onSuccess: (success) {
        if (success) {
          context.showSuccessSnackBar('Job marked as closed successfully');
          Navigator.pop(context, true); // Return to previous screen
        }
      },
      onError: (error) {
        context.showErrorSnackBar(error);
      },
    );
  }

  Future<void> _handleReapplyJob() async {
    final provider = context.read<CompanyJobProvider>();
    final result = await provider.reapplyJob(widget.job.id);

    result.handle(
      onSuccess: (success) {
        if (success) {
          context.showSuccessSnackBar('Job reapplied successfully');
          // Refresh the page or update the UI
          setState(() {});
        }
      },
      onError: (error) {
        context.showErrorSnackBar(error);
      },
    );
  }

  void _handleDownloadCV(String candidateId) {
    // Implement CV download functionality
    // This could open a URL, save file, etc.
    context.showInfoSnackBar('Downloading CV...');
  }
}

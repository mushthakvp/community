import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/buttons/primary_button.dart';
import '../../../../../core/widgets/common/app_bar.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/loading/loading_widget.dart';
import '../../../domain/entities/idea_entity.dart';
import '../../providers/create_idea_provider.dart';
import '../../providers/vhub_provider.dart';

class IdeaDetailsPage extends StatefulWidget {
  final String ideaId;
  final VoidCallback? onEdit;

  const IdeaDetailsPage({super.key, required this.ideaId, this.onEdit});

  @override
  State<IdeaDetailsPage> createState() => _IdeaDetailsPageState();
}

class _IdeaDetailsPageState extends State<IdeaDetailsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VHubProvider>().loadIdeaDetails(widget.ideaId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: const CommonAppBar(title: 'Idea Details', showBackButton: true),
      body: Consumer<VHubProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.selectedIdea == null) {
            return const Center(child: LoadingWidget());
          }

          if (provider.hasError && provider.selectedIdea == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    CommonTextWidget(
                      text:
                          provider.errorMessage ??
                          'Failed to load idea details',
                      fontSize: 16,
                      color: AppConstants.white,
                      align: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      text: 'Retry',
                      onPressed: () => provider.loadIdeaDetails(widget.ideaId),
                      backgroundColor: AppConstants.appPrimaryColor,
                      textColor: AppConstants.black,
                    ),
                  ],
                ),
              ),
            );
          }

          final idea = provider.selectedIdea;
          if (idea == null) {
            return const Center(
              child: CommonTextWidget(
                text: 'Idea not found',
                fontSize: 16,
                color: AppConstants.white,
              ),
            );
          }

          return _buildIdeaDetails(idea);
        },
      ),
    );
  }

  Widget _buildIdeaDetails(IdeaEntity idea) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with status
                _buildHeader(idea),
                const SizedBox(height: 24),

                // Rejection reason (if rejected)
                if (idea.isRejected && idea.rejectReason != null) ...[
                  _buildRejectionSection(idea),
                  const SizedBox(height: 24),
                ],

                // Project details
                _buildSection('Project Name', idea.projectName, Icons.business),
                const SizedBox(height: 20),

                // Founders
                _buildFoundersSection(idea.founders),
                const SizedBox(height: 20),

                // Summary
                _buildSection(
                  'Summary of Idea',
                  idea.summaryOfIdea,
                  Icons.description,
                ),
                const SizedBox(height: 20),

                // Development Progress
                _buildSection(
                  'Development Progress',
                  idea.longOfDevelopmentProgress,
                  Icons.trending_up,
                ),
                const SizedBox(height: 20),

                // Help Needed
                _buildSection('Help Needed', idea.helpNeed, Icons.help_outline),
                const SizedBox(height: 20),

                // About Project
                _buildSection(
                  'About Project',
                  idea.aboutProject,
                  Icons.info_outline,
                ),
                const SizedBox(height: 20),

                // Reason for Project
                _buildSection(
                  'Why You?',
                  idea.reasonForDoingProject,
                  Icons.person,
                ),
                const SizedBox(height: 20),

                // Target Market
                _buildSection('Who Will Buy', idea.whoWillBuy, Icons.groups),
                const SizedBox(height: 20),

                // Connected Work
                _buildConnectionSection(idea),
                const SizedBox(height: 20),

                // Signatures
                _buildSignaturesSection(idea.foundersSignature),
                const SizedBox(height: 20),

                // Metadata
                _buildMetadataSection(idea),
              ],
            ),
          ),
        ),

        // Action buttons
        if (idea.isRejected) _buildActionButtons(idea),
      ],
    );
  }

  Widget _buildHeader(IdeaEntity idea) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getStatusColor(idea.currentStatus).withOpacity(0.2),
            _getStatusColor(idea.currentStatus).withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getStatusColor(idea.currentStatus).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getStatusColor(idea.currentStatus).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getStatusIcon(idea.currentStatus),
              color: _getStatusColor(idea.currentStatus),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonTextWidget(
                  text: idea.currentStatus.toUpperCase(),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _getStatusColor(idea.currentStatus),
                ),
                const SizedBox(height: 4),
                CommonTextWidget(
                  text: _getStatusDescription(idea.currentStatus),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppConstants.white.withOpacity(0.7),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRejectionSection(IdeaEntity idea) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 20),
              const SizedBox(width: 8),
              const CommonTextWidget(
                text: 'Rejection Reason',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 12),
          CommonTextWidget(
            text: idea.rejectReason ?? 'No reason provided',
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: AppConstants.white.withOpacity(0.9),
          ),
          if (idea.rejectCount > 0) ...[
            const SizedBox(height: 8),
            CommonTextWidget(
              text:
                  'Rejected ${idea.rejectCount} time${idea.rejectCount > 1 ? 's' : ''}',
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: Colors.red.withOpacity(0.8),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppConstants.appPrimaryColor, size: 20),
              const SizedBox(width: 8),
              CommonTextWidget(
                text: title,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppConstants.appPrimaryColor,
              ),
            ],
          ),
          const SizedBox(height: 12),
          CommonTextWidget(
            text: content,
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: AppConstants.white.withOpacity(0.9),
          ),
        ],
      ),
    );
  }

  Widget _buildFoundersSection(List<FounderEntity> founders) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.people,
                color: AppConstants.appPrimaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              CommonTextWidget(
                text: 'Founders (${founders.length})',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppConstants.appPrimaryColor,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...founders.map((founder) => _buildFounderCard(founder)),
        ],
      ),
    );
  }

  Widget _buildFounderCard(FounderEntity founder) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppConstants.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppConstants.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonTextWidget(
            text: founder.name,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppConstants.white,
          ),
          const SizedBox(height: 4),
          CommonTextWidget(
            text: founder.email,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppConstants.white.withOpacity(0.7),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              CommonTextWidget(
                text: founder.contact,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppConstants.white.withOpacity(0.7),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppConstants.appPrimaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: CommonTextWidget(
                  text: founder.affiliation,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: AppConstants.appPrimaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionSection(IdeaEntity idea) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.link,
                color: AppConstants.appPrimaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              const CommonTextWidget(
                text: 'Connected with Founders Work',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppConstants.appPrimaryColor,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                idea.isConnectedWithFoundersWork ? Icons.check : Icons.close,
                color: idea.isConnectedWithFoundersWork
                    ? Colors.green
                    : Colors.red,
                size: 16,
              ),
              const SizedBox(width: 8),
              CommonTextWidget(
                text: idea.isConnectedWithFoundersWork ? 'Yes' : 'No',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: idea.isConnectedWithFoundersWork
                    ? Colors.green
                    : Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSignaturesSection(List<FounderSignatureEntity> signatures) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.assignment,
                color: AppConstants.appPrimaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              CommonTextWidget(
                text: 'Signatures (${signatures.length})',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppConstants.appPrimaryColor,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...signatures.map((signature) => _buildSignatureCard(signature)),
        ],
      ),
    );
  }

  Widget _buildSignatureCard(FounderSignatureEntity signature) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppConstants.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppConstants.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: CommonTextWidget(
              text: signature.name,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppConstants.white,
            ),
          ),
          const CommonTextWidget(
            text: 'Signed',
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataSection(IdeaEntity idea) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info,
                color: AppConstants.appPrimaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              const CommonTextWidget(
                text: 'Timeline',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppConstants.appPrimaryColor,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTimelineItem('Created', idea.createdAt),
          _buildTimelineItem('Last Updated', idea.updatedAt),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String label, DateTime date) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CommonTextWidget(
            text: label,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppConstants.white.withOpacity(0.8),
          ),
          CommonTextWidget(
            text: DateFormat('dd MMM yyyy, HH:mm').format(date),
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppConstants.white.withOpacity(0.6),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(IdeaEntity idea) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppConstants.black.withOpacity(0.8), AppConstants.black],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            PrimaryButton(
              text: 'Edit & Resubmit',
              onPressed: () => _editIdea(idea),
              backgroundColor: AppConstants.appPrimaryColor,
              textColor: AppConstants.black,
              height: 48,
              prefix: const Icon(
                Icons.edit,
                color: AppConstants.black,
                size: 20,
              ),
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              text: 'Delete Idea',
              onPressed: () => _showDeleteDialog(idea),
              backgroundColor: Colors.transparent,
              borderColor: Colors.red,
              textColor: Colors.red,
              height: 48,
              prefix: const Icon(
                Icons.delete_outline,
                color: Colors.red,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'requested':
      default:
        return Colors.blue;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      case 'requested':
      default:
        return Icons.pending;
    }
  }

  String _getStatusDescription(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return 'Your idea has been approved';
      case 'rejected':
        return 'Your idea needs improvements';
      case 'requested':
      default:
        return 'Your idea is under review';
    }
  }

  void _editIdea(IdeaEntity idea) {
    // Set up the create idea provider with existing data for editing
    final createProvider = context.read<CreateIdeaProvider>();
    createProvider.setReapplyData(idea);

    // Navigate back and trigger edit callback
    Navigator.of(context).pop();
    widget.onEdit?.call();
  }

  void _showDeleteDialog(IdeaEntity idea) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.black,
        title: const CommonTextWidget(
          text: 'Delete Idea',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppConstants.white,
        ),
        content: const CommonTextWidget(
          text:
              'Are you sure you want to delete this idea? This action cannot be undone.',
          fontSize: 14,
          color: AppConstants.white,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const CommonTextWidget(
              text: 'Cancel',
              fontSize: 14,
              color: AppConstants.white,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<VHubProvider>().deleteIdea(idea.id).then((success) {
                if (success) {
                  Navigator.of(context).pop(); // Go back to ideas list
                }
              });
            },
            child: const CommonTextWidget(
              text: 'Delete',
              fontSize: 14,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

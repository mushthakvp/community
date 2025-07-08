import 'package:flutter/material.dart';
import 'package:livera/core/widgets/buttons/primary_button.dart';

import '../../../../../../core/constants/app_constants.dart';
import '../../../../../../core/widgets/common/text_widget.dart';
import '../../../../../../core/widgets/loading/loading_widget.dart';
import '../../../domain/entities/candidate_entity.dart';

class CandidateListWidget extends StatelessWidget {
  final List<CandidateEntity> candidates;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMoreData;
  final void Function(String candidateId) onDownloadCV;

  const CandidateListWidget({
    super.key,
    required this.candidates,
    required this.isLoading,
    required this.isLoadingMore,
    required this.hasMoreData,
    required this.onDownloadCV,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(),
        const SizedBox(height: 16),
        if (isLoading)
          const Center(child: LoadingWidget(message: 'Loading candidates...'))
        else if (candidates.isEmpty)
          _buildEmptyState()
        else
          _buildCandidatesList(),
      ],
    );
  }

  Widget _buildSectionHeader() {
    return CommonTextWidget(
      text: 'Applied Candidates',
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppConstants.white,
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xff161616),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.people_outline,
            size: 48,
            color: AppConstants.white.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          CommonTextWidget(
            text: 'No candidates yet',
            fontSize: 16,
            color: AppConstants.white.withOpacity(0.7),
            align: TextAlign.center,
          ),
          const SizedBox(height: 8),
          CommonTextWidget(
            text: 'When candidates apply for this job, they will appear here.',
            fontSize: 14,
            color: AppConstants.white.withOpacity(0.5),
            align: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildCandidatesList() {
    return Column(
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: candidates.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return _buildCandidateCard(candidates[index]);
          },
        ),
        if (isLoadingMore) ...[
          const SizedBox(height: 16),
          const Center(child: LoadingWidget(size: 30, showMessage: false)),
        ],
        if (!hasMoreData && candidates.isNotEmpty) ...[
          const SizedBox(height: 16),
          Center(
            child: CommonTextWidget(
              text: 'No more candidates',
              fontSize: 14,
              color: AppConstants.white.withOpacity(0.5),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCandidateCard(CandidateEntity candidate) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff161616),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          _buildCandidateAvatar(candidate.user),
          const SizedBox(width: 16),
          Expanded(child: _buildCandidateInfo(candidate)),
          const SizedBox(width: 16),
          _buildDownloadButton(candidate),
        ],
      ),
    );
  }

  Widget _buildCandidateAvatar(UserEntity user) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppConstants.appPrimaryColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: user.profileImage != null
            ? Image.network(
                user.profileImage!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildDefaultAvatar();
                },
              )
            : _buildDefaultAvatar(),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: AppConstants.appPrimaryColor.withOpacity(0.1),
      child: Icon(Icons.person, color: AppConstants.appPrimaryColor, size: 28),
    );
  }

  Widget _buildCandidateInfo(CandidateEntity candidate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonTextWidget(
          text: candidate.user.name,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppConstants.white,
          maxLines: 1,
        ),
        const SizedBox(height: 4),
        CommonTextWidget(
          text: 'Applied ${_getTimeAgo(candidate.createdAt)}',
          fontSize: 12,
          color: AppConstants.white.withOpacity(0.6),
        ),
        if (candidate.resume != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.attach_file,
                size: 14,
                color: AppConstants.appPrimaryColor,
              ),
              const SizedBox(width: 4),
              CommonTextWidget(
                text: 'Resume attached',
                fontSize: 12,
                color: AppConstants.appPrimaryColor,
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildDownloadButton(CandidateEntity candidate) {
    return PrimaryButton(
      text: 'Download CV',
      onPressed: candidate.resume != null
          ? () => onDownloadCV(candidate.id)
          : null,
      backgroundColor: candidate.resume != null
          ? AppConstants.appPrimaryColor
          : AppConstants.white.withOpacity(0.1),
      textColor: candidate.resume != null
          ? AppConstants.black
          : AppConstants.white.withOpacity(0.5),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      fontSize: 12,
      fontWeight: FontWeight.w500,
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}

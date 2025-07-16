import 'package:flutter/material.dart';
import 'package:livera/core/widgets/buttons/primary_button.dart';

import '../../../../../../core/constants/app_constants.dart';
import '../../../../../../core/widgets/common/text_widget.dart';
import '../../../domain/entities/company_job_entity.dart';

class RejectedJobWidget extends StatelessWidget {
  final CompanyJobEntity job;
  final VoidCallback onReapply;

  const RejectedJobWidget({
    super.key,
    required this.job,
    required this.onReapply,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildRejectionReasonCard(),
        const SizedBox(height: 24),
        _buildReapplyButton(),
      ],
    );
  }

  Widget _buildRejectionReasonCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xff161616),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.cancel_outlined, color: Colors.red, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CommonTextWidget(
                  text: 'Job Rejected',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CommonTextWidget(
            text: 'Rejection Reason',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppConstants.white,
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.withOpacity(0.2)),
            ),
            child: CommonTextWidget(
              text: job.rejectReason ?? 'No specific reason provided',
              fontSize: 14,
              color: AppConstants.white.withOpacity(0.8),
              maxLines: null,
            ),
          ),
          const SizedBox(height: 16),
          _buildRejectionInfo(),
        ],
      ),
    );
  }

  Widget _buildRejectionInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppConstants.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: AppConstants.white.withOpacity(0.6),
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: CommonTextWidget(
              text:
                  'You can reapply for this job after making necessary improvements',
              fontSize: 12,
              color: AppConstants.white.withOpacity(0.6),
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReapplyButton() {
    return SizedBox(
      width: double.infinity,
      child: PrimaryButton(
        text: 'Reapply for Job',
        onPressed: onReapply,
        backgroundColor: AppConstants.appPrimaryColor,
        textColor: AppConstants.black,
        padding: const EdgeInsets.symmetric(vertical: 16),
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

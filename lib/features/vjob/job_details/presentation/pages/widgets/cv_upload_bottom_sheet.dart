import 'package:flutter/material.dart';
import 'package:livera/core/utils/result.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/constants/app_constants.dart';
import '../../../../../../core/utils/extensions.dart';
import '../../../../../../core/widgets/common/text_widget.dart';
import '../../providers/job_details_provider.dart';

class CVUploadBottomSheet extends StatelessWidget {
  const CVUploadBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xff161616),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Consumer<JobDetailsProvider>(
        builder: (context, provider, _) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CommonTextWidget(
                text: 'Add your CV',
                color: AppConstants.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 24),
              Divider(color: AppConstants.white.withOpacity(0.2)),
              const SizedBox(height: 30),
              _buildFileUploadSection(provider),
              const SizedBox(height: 30),
              _buildApplyButton(context, provider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFileUploadSection(JobDetailsProvider provider) {
    return provider.hasResumeSelected
        ? _buildSelectedFile(provider)
        : _buildUploadArea(provider);
  }

  Widget _buildUploadArea(JobDetailsProvider provider) {
    return GestureDetector(
      onTap: () => provider.pickResume(),
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: AppConstants.white.withOpacity(0.1)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_upload_outlined,
              color: AppConstants.white,
              size: 32,
            ),
            SizedBox(height: 12),
            CommonTextWidget(
              text: 'Upload your CV',
              color: AppConstants.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 4),
            CommonTextWidget(
              text: 'PDF files only',
              color: AppConstants.white,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedFile(JobDetailsProvider provider) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppConstants.appPrimaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.picture_as_pdf,
            color: AppConstants.black,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonTextWidget(
                text: provider.resumeName,
                color: AppConstants.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                maxLines: 2,
              ),
              const SizedBox(height: 4),
              const CommonTextWidget(
                text: 'Ready to upload',
                color: AppConstants.appPrimaryColor,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () => provider.removeResume(),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.delete_outline,
              color: Colors.red,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildApplyButton(BuildContext context, JobDetailsProvider provider) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: provider.hasResumeSelected && !provider.isApplyLoading
            ? () => _handleApply(context, provider)
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.appPrimaryColor,
          foregroundColor: AppConstants.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: provider.isApplyLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: AppConstants.black,
                  strokeWidth: 2,
                ),
              )
            : const CommonTextWidget(
                text: 'Apply Now',
                color: AppConstants.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
      ),
    );
  }

  Future<void> _handleApply(
    BuildContext context,
    JobDetailsProvider provider,
  ) async {
    final result = await provider.applyJob();

    if (context.mounted) {
      result.handle(
        onSuccess: (applyResult) {
          Navigator.pop(context);
          context.showSuccessSnackBar(
            applyResult.message.isNotEmpty
                ? applyResult.message
                : 'Application submitted successfully',
          );
        },
        onError: (error) {
          context.showErrorSnackBar(error);
        },
      );
    }
  }
}

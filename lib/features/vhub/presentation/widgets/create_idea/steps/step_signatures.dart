import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/constants/app_constants.dart';
import '../../../../../../core/widgets/common/text_widget.dart';
import '../../../../../../core/widgets/inputs/text_field.dart';
import '../../../providers/create_idea_provider.dart';

class StepSignatures extends StatelessWidget {
  const StepSignatures({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateIdeaProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CommonTextWidget(
                text: 'Final Step',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppConstants.appPrimaryColor,
              ),

              const SizedBox(height: 16),

              // Connection Question
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppConstants.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppConstants.white.withOpacity(0.1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CommonTextWidget(
                      text:
                          'Is this idea connected with, or in the same field as, the work or research of the founders?',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppConstants.white,
                    ),
                    const SizedBox(height: 8),
                    CommonTextWidget(
                      text:
                          '(If it is, we will just need to check some more details with you before we start)',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppConstants.white.withOpacity(0.7),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildChoiceButton(
                          'Yes',
                          provider.isConnectedWithFoundersWork == true,
                          () => provider.setConnectedWithFoundersWork(true),
                        ),
                        const SizedBox(width: 12),
                        _buildChoiceButton(
                          'No',
                          provider.isConnectedWithFoundersWork == false,
                          () => provider.setConnectedWithFoundersWork(false),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Signatures Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CommonTextWidget(
                    text: 'Founder Signatures',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.white,
                  ),
                  GestureDetector(
                    onTap: provider.addSignature,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppConstants.appPrimaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: AppConstants.black,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Signatures List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.signatureControllers.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final signature = provider.signatureControllers[index];
                  return _buildSignatureCard(
                    context,
                    signature,
                    index,
                    provider,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChoiceButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppConstants.appPrimaryColor.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppConstants.appPrimaryColor
                : AppConstants.white.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? AppConstants.appPrimaryColor
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? AppConstants.appPrimaryColor
                      : AppConstants.white.withOpacity(0.5),
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 10, color: AppConstants.black)
                  : null,
            ),
            const SizedBox(width: 8),
            CommonTextWidget(
              text: text,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected
                  ? AppConstants.appPrimaryColor
                  : AppConstants.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignatureCard(
    BuildContext context,
    SignatureController signature,
    int index,
    CreateIdeaProvider provider,
  ) {
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
          // Header
          Row(
            children: [
              CommonTextWidget(
                text: 'Signature ${index + 1}',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppConstants.appPrimaryColor,
              ),
              const Spacer(),
              if (provider.signatureControllers.length > 1)
                GestureDetector(
                  onTap: () => provider.removeSignature(index),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(Icons.close, color: Colors.red, size: 16),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Name Field
          const CommonTextWidget(
            text: 'Founder Name',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppConstants.white,
          ),
          const SizedBox(height: 6),
          CommonTextField(
            controller: signature.nameController,
            hintText: 'Enter founder name',
            textCapitalization: TextCapitalization.words,
          ),

          const SizedBox(height: 12),

          // Document Upload
          const CommonTextWidget(
            text: 'Signed Document (PDF)',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppConstants.white,
          ),
          const SizedBox(height: 6),

          GestureDetector(
            onTap: () => provider.uploadDocument(index),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppConstants.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppConstants.white.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  if (signature.documentUrl != null &&
                      signature.documentUrl!.isNotEmpty) ...[
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 24,
                    ),
                    const SizedBox(height: 8),
                    const CommonTextWidget(
                      text: 'Document Uploaded',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 4),
                    CommonTextWidget(
                      text: 'Tap to replace document',
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: AppConstants.white.withOpacity(0.6),
                    ),
                  ] else ...[
                    if (provider.isUploading) ...[
                      const CircularProgressIndicator(
                        color: AppConstants.appPrimaryColor,
                        strokeWidth: 2,
                      ),
                      const SizedBox(height: 8),
                      const CommonTextWidget(
                        text: 'Uploading...',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppConstants.white,
                      ),
                    ] else ...[
                      const Icon(
                        Icons.upload_file,
                        color: AppConstants.appPrimaryColor,
                        size: 24,
                      ),
                      const SizedBox(height: 8),
                      const CommonTextWidget(
                        text: 'Tap to upload PDF document',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppConstants.white,
                      ),
                      const SizedBox(height: 4),
                      CommonTextWidget(
                        text: 'Only PDF files are allowed',
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: AppConstants.white.withOpacity(0.6),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

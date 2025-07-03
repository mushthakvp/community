import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../providers/edit_ad_provider.dart';

class EditAdSaveButtonWidget extends StatelessWidget {
  const EditAdSaveButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EditAdProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            if (provider.isUploading) ...[
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppConstants.appPrimaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppConstants.appPrimaryColor.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        value: provider.uploadProgress,
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppConstants.appPrimaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonTextWidget(
                            text: "Saving changes...",
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppConstants.appPrimaryColor,
                          ),
                          const SizedBox(height: 4),
                          CommonTextWidget(
                            text:
                                "${(provider.uploadProgress * 100).toInt()}% complete",
                            fontSize: 12,
                            color: AppConstants.white.withOpacity(0.6),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: provider.isUploading
                    ? null
                    : () => _handleSave(context, provider),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.appPrimaryColor,
                  disabledBackgroundColor: AppConstants.appPrimaryColor
                      .withOpacity(0.5),
                  foregroundColor: AppConstants.black,
                  disabledForegroundColor: AppConstants.black.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: provider.isUploading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppConstants.black.withOpacity(0.7),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const CommonTextWidget(
                            text: "Saving...",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppConstants.black,
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.save,
                            size: 20,
                            color: AppConstants.black,
                          ),
                          const SizedBox(width: 8),
                          const CommonTextWidget(
                            text: "Save Changes",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppConstants.black,
                          ),
                        ],
                      ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleSave(BuildContext context, EditAdProvider provider) async {
    provider.clearError();
    if (!provider.formKey.currentState!.validate()) {
      return;
    }
    if (provider.totalImagesCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one image'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const CommonTextWidget(
          text: 'Save Changes?',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppConstants.white,
        ),
        content: const CommonTextWidget(
          text: 'Are you sure you want to save these changes to your ad?',
          fontSize: 14,
          color: AppConstants.white,
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const CommonTextWidget(
              text: 'Cancel',
              fontSize: 14,
              color: AppConstants.white,
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.appPrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const CommonTextWidget(
              text: 'Save',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppConstants.black,
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await provider.saveChanges();
      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ad updated successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.pop();
      } else if (!success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage ?? 'Failed to update ad'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}

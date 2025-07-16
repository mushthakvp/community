import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/services/cloudinary_service.dart';
import '../../../../../core/widgets/buttons/primary_button.dart';
import '../../../domain/repositories/vhub_repository.dart';
import '../../providers/create_idea_provider.dart';
import '../../providers/vhub_provider.dart';

class CreateIdeaNavigation extends StatelessWidget {
  final VoidCallback? onNavigateToHome;

  const CreateIdeaNavigation({super.key, this.onNavigateToHome});

  @override
  Widget build(BuildContext context) {
    return Consumer2<CreateIdeaProvider, VHubProvider>(
      builder: (context, createProvider, vhubProvider, child) {
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
            child: Row(
              children: [
                // Back Button
                if (createProvider.currentStep > 0)
                  Expanded(
                    child: PrimaryButton(
                      text: 'Previous',
                      onPressed: vhubProvider.isCreating
                          ? null
                          : createProvider.previousStep,
                      backgroundColor: Colors.transparent,
                      borderColor: AppConstants.white.withOpacity(0.3),
                      textColor: AppConstants.white,
                      height: 48,
                    ),
                  )
                else
                  const Spacer(),

                const SizedBox(width: 16),

                // Next/Submit Button
                Expanded(
                  flex: 2,
                  child: PrimaryButton(
                    text:
                        createProvider.currentStep ==
                            createProvider.totalSteps - 1
                        ? 'Submit Idea'
                        : 'Next',
                    onPressed: _getNextAction(
                      context,
                      createProvider,
                      vhubProvider,
                    ),
                    backgroundColor: AppConstants.appPrimaryColor,
                    textColor: AppConstants.black,
                    height: 48,
                    isLoading: vhubProvider.isCreating,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  VoidCallback? _getNextAction(
    BuildContext context,
    CreateIdeaProvider createProvider,
    VHubProvider vhubProvider,
  ) {
    if (vhubProvider.isCreating) return null;

    return () async {
      try {
        // Validate current step
        if (!createProvider.validateStep(createProvider.currentStep)) {
          _showErrorMessage(
            context,
            'Please fill in all required fields correctly.',
          );
          return;
        }

        if (createProvider.currentStep == createProvider.totalSteps - 1) {
          // Submit the idea
          await _submitIdea(context, createProvider, vhubProvider);
        } else {
          // Move to next step
          createProvider.nextStep();
        }
      } catch (e) {
        _showErrorMessage(
          context,
          'An unexpected error occurred. Please try again.',
        );
      }
    };
  }

  Future<void> _submitIdea(
    BuildContext context,
    CreateIdeaProvider createProvider,
    VHubProvider vhubProvider,
  ) async {
    try {
      // Show loading dialog
      _showLoadingDialog(context);

      // Upload signatures to Cloudinary first
      final updatedParams = await _uploadSignaturesToCloudinary(createProvider);

      if (updatedParams == null) {
        // Hide loading dialog
        if (context.mounted) {
          Navigator.of(context).pop();
        }
        _showErrorMessage(
          context,
          'Failed to upload signature documents. Please try again.',
        );
        return;
      }

      // Submit the idea with uploaded signature URLs
      final success = await vhubProvider.createIdea(updatedParams);

      // Hide loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      if (success) {
        // Success - reset form and show success message
        createProvider.reset();

        if (context.mounted) {
          await _showSuccessDialog(context);
          // Navigate back to home using the callback
          onNavigateToHome?.call();
        }
      } else {
        // Show error from provider
        if (context.mounted) {
          _showErrorMessage(
            context,
            vhubProvider.errorMessage ??
                'Failed to submit idea. Please try again.',
          );
        }
      }
    } catch (e) {
      debugPrint('Error in _submitIdea: $e');
      // Hide loading dialog if still showing
      if (context.mounted) {
        Navigator.of(context).pop();
        _showErrorMessage(
          context,
          'An unexpected error occurred. Please try again.',
        );
      }
    }
  }

  Future<CreateIdeaParams?> _uploadSignaturesToCloudinary(
    CreateIdeaProvider createProvider,
  ) async {
    try {
      final params = createProvider.buildCreateIdeaParams();
      final List<SignatureParams> updatedSignatures = [];

      for (final signature in params.foundersSignature) {
        String signatureUrl = signature.signature;

        // Check if the signature is a local file path (needs to be uploaded)
        if (signature.signature.isNotEmpty &&
            !signature.signature.startsWith('http')) {
          final file = File(signature.signature);
          if (await file.exists()) {
            final uploadedUrl = await CloudinaryService.uploadSingleImage(
              file: file,
              folder: 'vhub_signatures',
            );

            if (uploadedUrl != null) {
              signatureUrl = uploadedUrl;
            } else {
              throw Exception(
                'Failed to upload signature for ${signature.name}',
              );
            }
          }
        }

        updatedSignatures.add(
          SignatureParams(name: signature.name, signature: signatureUrl),
        );
      }

      return CreateIdeaParams(
        projectName: params.projectName,
        founders: params.founders,
        summaryOfIdea: params.summaryOfIdea,
        longOfDevelopmentProgress: params.longOfDevelopmentProgress,
        helpNeed: params.helpNeed,
        aboutProject: params.aboutProject,
        reasonForDoingProject: params.reasonForDoingProject,
        whoWillBuy: params.whoWillBuy,
        isConnectedWithFoundersWork: params.isConnectedWithFoundersWork,
        foundersSignature: updatedSignatures,
      );
    } catch (e) {
      debugPrint('Error uploading signatures: $e');
      return null;
    }
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: Dialog(
          backgroundColor: AppConstants.black,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: AppConstants.appPrimaryColor),
                const SizedBox(width: 16),
                const Text(
                  'Submitting your idea...',
                  style: TextStyle(color: AppConstants.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showSuccessDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: AppConstants.black,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 48,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Success!',
                style: TextStyle(
                  color: AppConstants.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your idea has been submitted successfully. You will be notified once it\'s reviewed.',
                style: TextStyle(color: AppConstants.white, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                text: 'Go to Home',
                onPressed: () {
                  Navigator.of(context).pop();
                },
                backgroundColor: AppConstants.appPrimaryColor,
                textColor: AppConstants.black,
                height: 48,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}

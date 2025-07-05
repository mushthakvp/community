import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/buttons/primary_button.dart';
import '../../providers/create_idea_provider.dart';
import '../../providers/vhub_provider.dart';

class CreateIdeaNavigation extends StatelessWidget {
  const CreateIdeaNavigation({super.key});

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

      // Build parameters
      final params = createProvider.buildCreateIdeaParams();

      // Submit the idea
      final success = await vhubProvider.createIdea(params);

      // Hide loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      if (success) {
        // Success - reset form and show success message
        createProvider.reset();

        if (context.mounted) {
          _showSuccessDialog(context);
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

  void _showSuccessDialog(BuildContext context) {
    showDialog(
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
                text: 'Done',
                onPressed: () {
                  Navigator.of(context).pop();
                  // Optionally navigate back to ideas list
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

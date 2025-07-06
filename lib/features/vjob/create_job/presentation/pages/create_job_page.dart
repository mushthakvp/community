import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/buttons/primary_button.dart';
import '../../../../../core/widgets/common/app_bar.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/loading/loading_widget.dart';
import '../providers/create_job_provider.dart';
import '../widgets/create_job_form.dart';
import '../widgets/job_form_stepper.dart';

class CreateJobPage extends StatefulWidget {
  const CreateJobPage({super.key});

  @override
  State<CreateJobPage> createState() => _CreateJobPageState();
}

class _CreateJobPageState extends State<CreateJobPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CreateJobProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: CommonAppBar(
        title: context.watch<CreateJobProvider>().isUpdate
            ? 'Update Job'
            : 'Create Job',
        showBackButton: true,
        onBackPressed: () => _showDiscardDialog(),
      ),
      body: Consumer<CreateJobProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: LoadingWidget());
          }

          return Column(
            children: [
              // Job Form Stepper
              const JobFormStepper(),

              // Form Content
              const Expanded(child: CreateJobForm()),

              // Submit Button
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  border: Border(
                    top: BorderSide(color: AppConstants.white.withOpacity(0.1)),
                  ),
                ),
                child: SafeArea(
                  child: PrimaryButton(
                    text: provider.currentStep == 0
                        ? 'Next'
                        : (provider.isUpdate ? 'Update Job' : 'Create Job'),
                    onPressed: provider.isLoading
                        ? null
                        : () {
                            if (provider.currentStep == 0) {
                              provider.nextStep();
                            } else {
                              provider.submitJob();
                            }
                          },
                    backgroundColor: AppConstants.appPrimaryColor,
                    textColor: AppConstants.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 50,
                    isLoading: provider.isLoading,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showDiscardDialog() {
    final provider = context.read<CreateJobProvider>();

    // Check if form has any content
    final hasContent =
        provider.selectedCompanyId.isNotEmpty ||
        provider.titleController.text.trim().isNotEmpty ||
        provider.descriptionController.text.trim().isNotEmpty ||
        provider.selectedPositions.isNotEmpty ||
        provider.skills.isNotEmpty;

    if (!hasContent) {
      Navigator.pop(context);
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const CommonTextWidget(
          text: 'Discard Changes?',
          color: AppConstants.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        content: const CommonTextWidget(
          text:
              'Are you sure you want to discard your changes? This action cannot be undone.',
          color: AppConstants.white,
          fontSize: 14,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const CommonTextWidget(
              text: 'Cancel',
              color: AppConstants.appPrimaryColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              provider.clearForm();
              Navigator.pop(context); // Close page
            },
            child: const CommonTextWidget(
              text: 'Discard',
              color: Colors.red,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../../../../core/widgets/inputs/text_field.dart';
import '../providers/vjob_provider.dart';

class ApplyJobDialog extends StatefulWidget {
  final String jobId;

  const ApplyJobDialog({super.key, required this.jobId});

  @override
  State<ApplyJobDialog> createState() => _ApplyJobDialogState();
}

class _ApplyJobDialogState extends State<ApplyJobDialog> {
  final TextEditingController _resumeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _resumeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppConstants.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildResumeField(),
              const SizedBox(height: 24),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Icon(Icons.work_outline, color: AppConstants.appPrimaryColor, size: 32),
        const SizedBox(height: 12),
        const CommonTextWidget(
          text: 'Apply for Job',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppConstants.white,
          align: TextAlign.center,
        ),
        const SizedBox(height: 8),
        CommonTextWidget(
          text: 'Upload your resume to apply for this position',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppConstants.white.withOpacity(0.7),
          align: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildResumeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonTextWidget(
          text: 'Resume URL (Optional)',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppConstants.white,
        ),
        const SizedBox(height: 8),
        CommonTextField(
          controller: _resumeController,
          hintText: 'https://liveraapp.com/resume.pdf',
          keyboardType: TextInputType.url,
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              final uri = Uri.tryParse(value);
              if (uri == null || !uri.hasAbsolutePath) {
                return 'Please enter a valid URL';
              }
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: PrimaryButton(
            text: 'Cancel',
            onPressed: () => Navigator.of(context).pop(),
            backgroundColor: Colors.transparent,
            borderColor: AppConstants.white.withOpacity(0.3),
            textColor: AppConstants.white,
            height: 48,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: PrimaryButton(
            text: _isSubmitting ? 'Applying...' : 'Apply',
            onPressed: _isSubmitting ? null : _handleApply,
            backgroundColor: AppConstants.appPrimaryColor,
            textColor: AppConstants.black,
            height: 48,
            isLoading: _isSubmitting,
          ),
        ),
      ],
    );
  }

  void _handleApply() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final resumeUrl = _resumeController.text.trim();
      await context.read<VJobProvider>().applyForJob(
        widget.jobId,
        resumeUrl.isNotEmpty ? resumeUrl : null,
      );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Application submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit application: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}

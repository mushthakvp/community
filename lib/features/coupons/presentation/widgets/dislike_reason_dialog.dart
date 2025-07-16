// lib/features/coupons/presentation/widgets/dislike_reason_dialog.dart
import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../../../../core/widgets/inputs/text_field.dart';

class DislikeReasonDialog extends StatefulWidget {
  final Function(String reason) onSubmit;

  const DislikeReasonDialog({super.key, required this.onSubmit});

  @override
  State<DislikeReasonDialog> createState() => _DislikeReasonDialogState();
}

class _DislikeReasonDialogState extends State<DislikeReasonDialog> {
  final TextEditingController _reasonController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  final List<String> _predefinedReasons = [
    'Coupon doesn\'t work',
    'Misleading description',
    'Expired coupon',
    'Website not accessible',
    'Poor discount value',
    'Other',
  ];

  String? _selectedReason;

  @override
  void dispose() {
    _reasonController.dispose();
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
              _buildReasonOptions(),
              const SizedBox(height: 16),
              _buildCustomReasonField(),
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
        Icon(
          Icons.thumb_down_outlined,
          color: Colors.red.withOpacity(0.8),
          size: 32,
        ),
        const SizedBox(height: 12),
        const CommonTextWidget(
          text: 'Why don\'t you like this coupon?',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppConstants.white,
          align: TextAlign.center,
        ),
        const SizedBox(height: 8),
        CommonTextWidget(
          text: 'Your feedback helps us improve our service',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppConstants.white.withOpacity(0.7),
          align: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildReasonOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonTextWidget(
          text: 'Select a reason:',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppConstants.white,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _predefinedReasons.map((reason) {
            final isSelected = _selectedReason == reason;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedReason = reason;
                  if (reason != 'Other') {
                    _reasonController.text = reason;
                  } else {
                    _reasonController.clear();
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppConstants.appPrimaryColor.withOpacity(0.2)
                      : AppConstants.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppConstants.appPrimaryColor
                        : AppConstants.white.withOpacity(0.3),
                  ),
                ),
                child: CommonTextWidget(
                  text: reason,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? AppConstants.appPrimaryColor
                      : AppConstants.white,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCustomReasonField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonTextWidget(
          text: _selectedReason == 'Other'
              ? 'Please specify:'
              : 'Additional comments (optional):',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppConstants.white,
        ),
        const SizedBox(height: 8),
        CommonTextField(
          controller: _reasonController,
          hintText: 'Tell us more about your experience...',
          maxLines: 3,
          minLines: 2,
          validator: (value) {
            if (_selectedReason == 'Other' &&
                (value == null || value.trim().isEmpty)) {
              return 'Please provide a reason';
            }
            if (_selectedReason == null &&
                (value == null || value.trim().isEmpty)) {
              return 'Please select a reason or provide your own';
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
            text: _isSubmitting ? 'Submitting...' : 'Submit',
            onPressed: _isSubmitting ? null : _handleSubmit,
            backgroundColor: AppConstants.appPrimaryColor,
            textColor: AppConstants.black,
            height: 48,
            isLoading: _isSubmitting,
          ),
        ),
      ],
    );
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final reason = _reasonController.text.trim();
      widget.onSubmit(reason);

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      // Handle error if needed
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}

// lib/features/coupons/presentation/widgets/dislike_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/common_button.dart';
import '../../../../core/widgets/common_text_form_field.dart';
import '../../../../core/widgets/common_text_widget.dart';

class DislikeBottomSheet extends StatefulWidget {
  final Function(String reason) onDislike;

  const DislikeBottomSheet({super.key, required this.onDislike});

  @override
  State<DislikeBottomSheet> createState() => _DislikeBottomSheetState();
}

class _DislikeBottomSheetState extends State<DislikeBottomSheet> {
  final TextEditingController _reasonController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        height: Responsive.height * 40,
        decoration: const BoxDecoration(
          color: AppConstants.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildReasonField(),
              const Spacer(),
              _buildSubmitButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: AppConstants.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 16),
        const CommonTextWidget(
          text: 'Tell us why you dislike this coupon',
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

  Widget _buildReasonField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonTextWidget(
          text: 'Reason *',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppConstants.white,
        ),
        const SizedBox(height: 8),
        CommonTextFormField(
          controller: _reasonController,
          borderSide: BorderSide(color: AppConstants.white.withOpacity(0.3)),
          bgColor: AppConstants.transparent,
          keyboardType: TextInputType.multiline,
          maxLines: 4,
          minLines: 3,
          hintText: 'Please tell us what went wrong...',
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please provide a reason for disliking this coupon';
            }
            if (value.trim().length < 10) {
              return 'Please provide a more detailed reason (at least 10 characters)';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return CommonButton(
      text: _isSubmitting ? 'Submitting...' : 'Submit Feedback',
      onTap: _isSubmitting ? () {} : _handleSubmit,
      bgColor: AppConstants.appPrimaryColor,
      borderColor: AppConstants.appPrimaryColor,
      textColor: AppConstants.black,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      borderRadius: BorderRadius.circular(12),
      height: 50,
    );
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simulate network delay
      widget.onDislike(_reasonController.text.trim());

      if (mounted) {
        context.pop();
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

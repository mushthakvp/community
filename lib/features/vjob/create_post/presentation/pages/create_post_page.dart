import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/buttons/primary_button.dart';
import '../../../../../core/widgets/common/app_bar.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/loading/loading_widget.dart';
import '../providers/create_post_provider.dart';
import '../widgets/create_post_form.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  @override
  void initState() {
    super.initState();
    // Listen to provider state changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<CreatePostProvider>();

      // Show success/error messages
      if (provider.successMessage != null) {
        _showSuccessSnackBar(provider.successMessage!);
      }
      if (provider.errorMessage != null) {
        _showErrorSnackBar(provider.errorMessage!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: CommonAppBar(
        title: context.watch<CreatePostProvider>().isUpdate
            ? 'Update Post'
            : 'Create Post',
        showBackButton: true,
        onBackPressed: () {
          _showDiscardDialog();
        },
      ),
      body: Consumer<CreatePostProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              const SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: CreatePostForm(),
              ),
              if (provider.isLoading)
                Container(
                  color: Colors.black54,
                  child: const Center(child: LoadingWidget()),
                ),
            ],
          );
        },
      ),
      bottomNavigationBar: Consumer<CreatePostProvider>(
        builder: (context, provider, child) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              border: Border(
                top: BorderSide(color: AppConstants.white.withOpacity(0.1)),
              ),
            ),
            child: SafeArea(
              child: PrimaryButton(
                text: provider.isUpdate ? 'Update Post' : 'Create Post',
                onPressed: provider.isLoading
                    ? null
                    : () => provider.createOrUpdatePost(),
                backgroundColor: AppConstants.appPrimaryColor,
                textColor: AppConstants.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 50,
                isLoading: provider.isLoading,
              ),
            ),
          );
        },
      ),
    );
  }

  void _showDiscardDialog() {
    final provider = context.read<CreatePostProvider>();

    // Check if form has any content
    final hasContent =
        provider.titleController.text.trim().isNotEmpty ||
        provider.descriptionController.text.trim().isNotEmpty ||
        provider.hasImage;

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

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/loading/loading_widget.dart';
import '../providers/edit_ad_provider.dart';
import '../widgets/edit_ad_form_widget.dart';
import '../widgets/edit_ad_image_picker_widget.dart';
import '../widgets/edit_ad_location_widget.dart';
import '../widgets/edit_ad_save_button_widget.dart';

class EditAdPage extends StatefulWidget {
  final String adId;

  const EditAdPage({super.key, required this.adId});

  @override
  State<EditAdPage> createState() => _EditAdPageState();
}

class _EditAdPageState extends State<EditAdPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EditAdProvider>().loadAdDetails(widget.adId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppConstants.black, Color(0xFF0A0A0A)],
          ),
        ),
        child: SafeArea(
          child: Consumer<EditAdProvider>(
            builder: (context, provider, child) {
              return Column(
                children: [
                  _buildAppBar(context, provider),
                  Expanded(child: _buildContent(context, provider)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, EditAdProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.black,
        border: Border(
          bottom: BorderSide(
            color: AppConstants.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => _handleBackPress(context, provider),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppConstants.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: CommonTextWidget(
              text: "Edit Ad",
              color: AppConstants.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (provider.isUploading)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppConstants.appPrimaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppConstants.appPrimaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CommonTextWidget(
                    text: "${(provider.uploadProgress * 100).toInt()}%",
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.appPrimaryColor,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, EditAdProvider provider) {
    if (provider.isLoading) {
      return const Center(
        child: LoadingWidget(message: 'Loading ad details...', size: 48),
      );
    }

    if (provider.hasError && provider.advertisement == null) {
      return _buildErrorState(context, provider);
    }

    if (provider.advertisement == null) {
      return _buildEmptyState(context);
    }

    return Form(
      key: provider.formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // Header Text
            const CommonTextWidget(
              text: "Update your listing details",
              color: AppConstants.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 24),

            // Image Picker
            const EditAdImagePickerWidget(),
            const SizedBox(height: 24),

            // Form Fields
            const EditAdFormWidget(),
            const SizedBox(height: 24),

            // Location Widget
            const EditAdLocationWidget(),
            const SizedBox(height: 32),

            // Save Button
            const EditAdSaveButtonWidget(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, EditAdProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                Icons.error_outline,
                size: 40,
                color: Colors.red.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            const CommonTextWidget(
              text: 'Failed to load ad details',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppConstants.white,
            ),
            const SizedBox(height: 8),
            CommonTextWidget(
              text: provider.errorMessage ?? 'Something went wrong',
              fontSize: 14,
              color: AppConstants.white.withOpacity(0.7),
              align: TextAlign.center,
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => provider.loadAdDetails(widget.adId),
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.appPrimaryColor,
                foregroundColor: AppConstants.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppConstants.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                Icons.inventory_2_outlined,
                size: 40,
                color: AppConstants.white.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 24),
            const CommonTextWidget(
              text: 'Ad not found',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppConstants.white,
            ),
            const SizedBox(height: 8),
            CommonTextWidget(
              text: 'The ad you\'re trying to edit could not be found.',
              fontSize: 14,
              color: AppConstants.white.withOpacity(0.7),
              align: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back, size: 18),
              label: const Text('Go Back'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.appPrimaryColor,
                foregroundColor: AppConstants.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleBackPress(BuildContext context, EditAdProvider provider) {
    if (provider.isUploading) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF2A2A2A),
          title: const CommonTextWidget(
            text: 'Cancel Upload?',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppConstants.white,
          ),
          content: const CommonTextWidget(
            text:
                'Your changes are being saved. Are you sure you want to cancel?',
            fontSize: 14,
            color: AppConstants.white,
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const CommonTextWidget(
                text: 'Stay',
                fontSize: 14,
                color: AppConstants.appPrimaryColor,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.pop();
              },
              child: const CommonTextWidget(
                text: 'Cancel',
                fontSize: 14,
                color: Colors.red,
              ),
            ),
          ],
        ),
      );
    } else {
      context.pop();
    }
  }
}

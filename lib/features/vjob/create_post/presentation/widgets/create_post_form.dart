import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/inputs/text_field.dart';
import '../providers/create_post_provider.dart';
import 'image_picker_widget.dart';
import 'image_preview_widget.dart';

class CreatePostForm extends StatelessWidget {
  const CreatePostForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CreatePostProvider>(
      builder: (context, provider, child) {
        return Form(
          key: provider.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const CommonTextWidget(
                text: 'Share your thoughts',
                color: AppConstants.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
              const SizedBox(height: 8),
              CommonTextWidget(
                text: provider.isUpdate
                    ? 'Update your post with new information'
                    : 'Create a new post to share with the community',
                color: AppConstants.white.withOpacity(0.7),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(height: 32),

              // Title Field
              const CommonTextWidget(
                text: 'Post Title',
                color: AppConstants.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(height: 8),
              CommonTextField(
                controller: provider.titleController,
                hintText: 'Enter an engaging title for your post',
                validator: provider.validateTitle,
                prefixIcon: const Icon(Icons.title, color: AppConstants.white),
                maxLength: 100,
              ),
              const SizedBox(height: 24),

              // Description Field
              const CommonTextWidget(
                text: 'Description',
                color: AppConstants.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(height: 8),
              CommonTextField(
                controller: provider.descriptionController,
                hintText: 'Write a detailed description...',
                validator: provider.validateDescription,
                maxLines: 6,
                minLines: 4,
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(bottom: 80),
                  child: Icon(Icons.description, color: AppConstants.white),
                ),
                maxLength: 1000,
              ),
              const SizedBox(height: 24),

              // Image Section
              const CommonTextWidget(
                text: 'Image or Document',
                color: AppConstants.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(height: 8),
              CommonTextWidget(
                text: 'Add an image (JPG, PNG) or PDF document to your post',
                color: AppConstants.white.withOpacity(0.6),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(height: 16),

              // Image Preview or Picker
              if (provider.hasImage)
                ImagePreviewWidget(
                  imagePath: provider.selectedImagePath,
                  imageUrl: provider.uploadedImageUrl,
                  isPdf: provider.isPdf,
                  onRemove: provider.removeSelectedImage,
                  onReplace: () => provider.showImagePickerOptions(context),
                )
              else
                ImagePickerWidget(
                  onTap: () => provider.showImagePickerOptions(context),
                ),

              const SizedBox(height: 32),

              // Tips Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppConstants.appPrimaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppConstants.appPrimaryColor.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: AppConstants.appPrimaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const CommonTextWidget(
                          text: 'Tips for a great post',
                          color: AppConstants.appPrimaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildTip('• Use a clear and descriptive title'),
                    _buildTip(
                      '• Provide detailed information in the description',
                    ),
                    _buildTip('• Add relevant images or documents'),
                    _buildTip('• Keep your content professional and engaging'),
                  ],
                ),
              ),

              const SizedBox(height: 100), // Space for bottom button
            ],
          ),
        );
      },
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: CommonTextWidget(
        text: text,
        color: AppConstants.appPrimaryColor.withOpacity(0.8),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

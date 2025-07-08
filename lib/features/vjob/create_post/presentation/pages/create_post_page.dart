import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livera/core/utils/result.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/utils/extensions.dart';
import '../../../../../core/widgets/buttons/primary_button.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/inputs/text_field.dart';
import '../../../../../core/widgets/loading/loading_overlay.dart';
import '../providers/create_post_provider.dart';
import '../widgets/image_picker_widget.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  late CreatePostProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<CreatePostProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _provider.clearUpdateMode();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppConstants.black,
      elevation: 0,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: const Icon(Icons.arrow_back, color: AppConstants.white),
      ),
      title: Consumer<CreatePostProvider>(
        builder: (context, provider, _) {
          return CommonTextWidget(
            text: provider.isUpdateMode ? 'Edit Post' : 'Create Post',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppConstants.white,
          );
        },
      ),
      centerTitle: false,
    );
  }

  Widget _buildBody() {
    return Consumer<CreatePostProvider>(
      builder: (context, provider, _) {
        return LoadingOverlay(
          isLoading: provider.isLoading,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: provider.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleField(),
                  const SizedBox(height: 16),
                  _buildDescriptionField(),
                  const SizedBox(height: 16),
                  _buildImagePicker(),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitleField() {
    return Consumer<CreatePostProvider>(
      builder: (context, provider, _) {
        return CommonTextField(
          controller: provider.titleController,
          hintText: 'Post Title',
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          prefixIcon: const Icon(Icons.title, color: AppConstants.white),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a title';
            }
            if (value.trim().length < 3) {
              return 'Title must be at least 3 characters';
            }
            return null;
          },
          onChanged: (value) {},
        );
      },
    );
  }

  Widget _buildDescriptionField() {
    return Consumer<CreatePostProvider>(
      builder: (context, provider, _) {
        return CommonTextField(
          controller: provider.descriptionController,
          hintText: 'Description',
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          maxLines: 20,
          minLines: 4,
          prefixIcon: const Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Icon(Icons.description, color: AppConstants.white),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a description';
            }
            if (value.trim().length < 10) {
              return 'Description must be at least 10 characters';
            }
            return null;
          },
          onChanged: (value) {
            // Auto-save draft or validate on change
          },
        );
      },
    );
  }

  Widget _buildImagePicker() {
    return Consumer<CreatePostProvider>(
      builder: (context, provider, _) {
        return ImagePickerWidget(
          imageUrl: provider.uploadedImageUrl,
          isPdf: provider.isPdf,
          isUploading: provider.isImageUploading,
          onImagePick: () => _handleImagePick(),
          onImageRemove: () => _handleImageRemove(),
        );
      },
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppConstants.black,
        border: Border(
          top: BorderSide(color: AppConstants.white.withOpacity(0.1)),
        ),
      ),
      child: SafeArea(
        child: Consumer<CreatePostProvider>(
          builder: (context, provider, _) {
            return PrimaryButton(
              text: provider.isUpdateMode ? 'Update Post' : 'Create Post',
              isLoading: provider.isLoading,
              onPressed: provider.isLoading ? null : _handleSubmit,
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleImagePick() async {
    final result = await _provider.pickImage();
    result.handle(onError: (error) => context.showErrorSnackBar(error));
  }

  void _handleImageRemove() {
    _provider.removeImage();
  }

  Future<void> _handleSubmit() async {
    if (!_provider.formKey.currentState!.validate()) {
      return;
    }

    final result = _provider.isUpdateMode
        ? await _provider.updatePost()
        : await _provider.createPost();

    result.handle(
      onSuccess: (_) {
        context.showSuccessSnackBar(
          _provider.isUpdateMode
              ? 'Post updated successfully!'
              : 'Post created successfully!',
        );
        context.pop();
      },
      onError: (error) => context.showErrorSnackBar(error),
    );
  }
}

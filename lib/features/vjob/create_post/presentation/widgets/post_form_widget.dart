import 'package:flutter/material.dart';
import 'package:livera/core/widgets/inputs/text_field.dart';

import '../../../../../core/constants/app_constants.dart';

class PostFormWidget extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final GlobalKey<FormState> formKey;
  final Function(String)? onTitleChanged;
  final Function(String)? onDescriptionChanged;

  const PostFormWidget({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.formKey,
    this.onTitleChanged,
    this.onDescriptionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonTextField(
            controller: titleController,
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
            onChanged: onTitleChanged,
          ),
          const SizedBox(height: 16),
          CommonTextField(
            controller: descriptionController,
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
            onChanged: onDescriptionChanged,
          ),
        ],
      ),
    );
  }
}

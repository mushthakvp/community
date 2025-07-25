import 'package:flutter/material.dart';

import '../controllers/add_video_recipe_controller.dart';

class FormSection extends StatelessWidget {
  final AddVideoRecipeController controller;

  const FormSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTitleField(),
        const SizedBox(height: 20),
        _buildDescriptionField(),
        const SizedBox(height: 18),
        _buildCookingTimeField(),
      ],
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: controller.titleController,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: 'Title',
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.6),
          fontSize: 14,
        ),
        filled: true,
        fillColor: const Color(0xff0F0F0F),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 15,
        ),
      ),
      textInputAction: TextInputAction.next,
    );
  }

  Widget _buildDescriptionField() {
    return Container(
      height: 113,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xff0F0F0F),
      ),
      child: TextFormField(
        controller: controller.descriptionController,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        keyboardType: TextInputType.multiline,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Description',
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 14,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildCookingTimeField() {
    return TextFormField(
      controller: controller.cookingTimeController,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: 'Cooking time (e.g., 30 min)',
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.6),
          fontSize: 14,
        ),
        filled: true,
        fillColor: const Color(0xff0F0F0F),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 15,
        ),
      ),
      textInputAction: TextInputAction.next,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../domain/entities/ingredient.dart';
import '../../domain/entities/recipe.dart';
import '../controllers/recipe_draft_controller.dart';
import '../widgets/common/recipe_app_bar.dart';
import '../widgets/common/recipe_button.dart';
import '../widgets/common/recipe_text_field.dart';
import '../widgets/text_recipe/ingredient_list.dart';

class TextRecipePage extends StatefulWidget {
  const TextRecipePage({super.key});

  @override
  State<TextRecipePage> createState() => _TextRecipePageState();
}

class _TextRecipePageState extends State<TextRecipePage> {
  late RecipeDraftController draftController;
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    draftController = Get.find<RecipeDraftController>();
    titleController = TextEditingController();
    descriptionController = TextEditingController();

    // Initialize with draft data
    _initializeControllers();
  }

  void _initializeControllers() {
    final draft = draftController.draft;
    titleController.text = draft.title ?? '';
    descriptionController.text = draft.description ?? '';

    // Set recipe type if not already set
    if (draft.type != RecipeType.text) {
      draftController.updateType(RecipeType.text);
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const RecipeAppBar(title: 'Text recipe', showBackButton: true),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitleField(),
                      const SizedBox(height: 20),
                      _buildDescriptionField(),
                      const SizedBox(height: 34),
                      _buildIngredientsSection(),
                    ],
                  ),
                ),
              ),
              _buildFooterButtons(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return RecipeTextField(
      controller: titleController,
      hintText: 'Title',
      onChanged: (value) => draftController.updateTitle(value),
    );
  }

  Widget _buildDescriptionField() {
    return RecipeTextField(
      controller: descriptionController,
      hintText: 'Description',
      maxLines: 5,
      onChanged: (value) => draftController.updateDescription(value),
    );
  }

  Widget _buildIngredientsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Add Ingredients',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 34),
        Obx(
          () => IngredientList(
            ingredients: draftController.draft.ingredients,
            onAddIngredient: _onAddIngredient,
            onUpdateIngredient: _onUpdateIngredient,
            onRemoveIngredient: _onRemoveIngredient,
          ),
        ),
      ],
    );
  }

  Widget _buildFooterButtons() {
    return Obx(() {
      final canProceed = draftController.draft.canProceedToSteps;

      return Row(
        children: [
          Expanded(
            child: RecipeButton(
              text: 'Cancel',
              onPressed: () => context.pop(),
              backgroundColor: const Color(0xff222426),
              textColor: Colors.white,
              borderColor: Colors.transparent,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RecipeButton(
              text: 'Next',
              onPressed: canProceed ? _onNextPressed : null,
              backgroundColor: canProceed ? Colors.amber : Colors.grey,
              borderColor: canProceed ? Colors.amber : Colors.grey,
            ),
          ),
        ],
      );
    });
  }

  void _onAddIngredient(Ingredient ingredient) {
    draftController.addIngredient(ingredient);
  }

  void _onUpdateIngredient(int index, Ingredient ingredient) {
    draftController.updateIngredient(index, ingredient);
  }

  void _onRemoveIngredient(int index) {
    draftController.removeIngredient(index);
  }

  void _onNextPressed() {
    if (_validateForm()) {
      context.push('/cook/recipe/steps');
    }
  }

  bool _validateForm() {
    if (titleController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter recipe title',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (descriptionController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter recipe description',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (draftController.draft.ingredients.isEmpty) {
      Get.snackbar(
        'Error',
        'Please add at least one ingredient',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }
}

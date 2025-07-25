import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entities/ingredient.dart';

class AddTextRecipeController extends GetxController {
  // Form controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  // Reactive lists
  final RxList<Ingredient> _ingredients = <Ingredient>[].obs;
  final RxList<Map<String, dynamic>> _ingredientSections =
      <Map<String, dynamic>>[].obs;

  // Available units
  final List<String> units = [
    'grams',
    'kg',
    'ml',
    'liters',
    'cups',
    'tablespoons',
    'teaspoons',
    'pieces',
    'pinch',
  ];

  // Getters
  List<Ingredient> get ingredients => _ingredients;
  List<Map<String, dynamic>> get ingredientSections => _ingredientSections;
  bool get hasIngredients => _ingredients.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    _addInitialIngredientSection();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    _disposeIngredientControllers();
    super.onClose();
  }

  void _addInitialIngredientSection() {
    if (_ingredientSections.isEmpty) {
      addIngredientSection();
    }
  }

  void addIngredientSection() {
    _ingredientSections.add({
      'name': TextEditingController(),
      'amount': TextEditingController(),
      'isEditing': true.obs,
      'unit': units.first.obs,
    });
    _ingredientSections.refresh();
  }

  bool saveIngredient(int index) {
    if (index >= _ingredientSections.length) return false;

    final section = _ingredientSections[index];
    final nameController = section['name'] as TextEditingController;
    final amountController = section['amount'] as TextEditingController;
    final unitObs = section['unit'] as RxString;
    final isEditingObs = section['isEditing'] as RxBool;

    // Validation
    if (!_validateIngredientInput(nameController.text, amountController.text)) {
      return false;
    }

    // Create ingredient
    final ingredient = Ingredient(
      name: nameController.text.trim(),
      amount: amountController.text.trim(),
      unit: unitObs.value,
    );

    // Add to ingredients list
    _ingredients.add(ingredient);
    isEditingObs.value = false;

    return true;
  }

  bool _validateIngredientInput(String name, String amount) {
    if (name.trim().isEmpty) {
      _showError('Please enter ingredient name');
      return false;
    }

    if (amount.trim().isEmpty) {
      _showError('Please enter ingredient amount');
      return false;
    }

    return true;
  }

  void editIngredientSection(int index) {
    if (index >= _ingredientSections.length) return;

    // Reset all sections to not editing
    for (var section in _ingredientSections) {
      (section['isEditing'] as RxBool).value = false;
    }

    // Enable editing for selected section
    final section = _ingredientSections[index];
    (section['isEditing'] as RxBool).value = true;
  }

  void deleteIngredientSection(int index) {
    if (_ingredientSections.length <= 1) {
      _showError(
        'This is the last ingredient section. You can edit it if needed.',
      );
      return;
    }

    if (index >= _ingredientSections.length) return;

    final section = _ingredientSections[index];

    // Dispose controllers
    (section['name'] as TextEditingController).dispose();
    (section['amount'] as TextEditingController).dispose();

    _ingredientSections.removeAt(index);
  }

  bool validateForm() {
    if (titleController.text.trim().isEmpty) {
      _showError('Please enter recipe title');
      return false;
    }

    if (descriptionController.text.trim().isEmpty) {
      _showError('Please enter recipe description');
      return false;
    }

    if (_ingredients.isEmpty) {
      _showError('Please add at least one ingredient');
      return false;
    }

    return true;
  }

  List<Map<String, String>> getIngredientsForBackend() {
    return _ingredients
        .map(
          (ingredient) => {
            'name': ingredient.name,
            'amount': ingredient.amount,
            'unit': ingredient.unit,
          },
        )
        .toList();
  }

  void clearAll() {
    titleController.clear();
    descriptionController.clear();
    _ingredients.clear();
    _disposeIngredientControllers();
    _ingredientSections.clear();
    _addInitialIngredientSection();
  }

  void _disposeIngredientControllers() {
    for (var section in _ingredientSections) {
      (section['name'] as TextEditingController).dispose();
      (section['amount'] as TextEditingController).dispose();
    }
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}

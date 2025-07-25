import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entities/recipe_submission.dart';
import '../../domain/usecases/submit_recipe_usecase.dart';

class PreviewController extends GetxController {
  final SubmitRecipeUseCase submitRecipeUseCase;

  PreviewController({required this.submitRecipeUseCase});

  // State
  final _selectedTabIndex = 0.obs;
  final _isLoading = true.obs;
  final _isSubmitting = false.obs;
  final _hasError = false.obs;
  final _errorMessage = ''.obs;

  // Getters
  int get selectedTabIndex => _selectedTabIndex.value;
  bool get isLoading => _isLoading.value;
  bool get isSubmitting => _isSubmitting.value;
  bool get hasError => _hasError.value;
  String get errorMessage => _errorMessage.value;

  @override
  void onInit() {
    super.onInit();
    _initializePreview();
  }

  void _initializePreview() {
    Future.delayed(const Duration(seconds: 1), () {
      _isLoading.value = false;
    });
  }

  void changeTab(int index) {
    _selectedTabIndex.value = index;
  }

  Future<void> submitRecipe({
    required String challengeId,
    required String title,
    required String description,
    required String recipeType,
    List<Map<String, dynamic>>? ingredients,
    List<Map<String, dynamic>>? steps,
    String? cookingTime,
    String? image,
    String? video,
  }) async {
    if (_isSubmitting.value) return;

    try {
      _isSubmitting.value = true;
      _hasError.value = false;
      _errorMessage.value = '';

      final submission = RecipeSubmission(
        challengeId: challengeId,
        title: title,
        description: description,
        recipeType: recipeType,
        ingredients: ingredients,
        steps: steps,
        cookingTime: cookingTime,
        image: image,
        video: video,
      );

      final params = SubmitRecipeParams(submission: submission);
      final result = await submitRecipeUseCase(params);

      result.fold(
        (failure) {
          _hasError.value = true;
          _errorMessage.value = failure.message;
          _showErrorSnackbar(failure.message);
        },
        (success) {
          _showSuccessSnackbar();
          // Navigate back or to success page
          Get.back();
        },
      );
    } catch (e) {
      _hasError.value = true;
      _errorMessage.value = 'An unexpected error occurred';
      _showErrorSnackbar('An unexpected error occurred');
    } finally {
      _isSubmitting.value = false;
    }
  }

  void _showSuccessSnackbar() {
    Get.snackbar(
      'Success',
      'Recipe submitted successfully!',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  void retrySubmission() {
    _hasError.value = false;
    _errorMessage.value = '';
  }

  void resetState() {
    _selectedTabIndex.value = 0;
    _isLoading.value = true;
    _isSubmitting.value = false;
    _hasError.value = false;
    _errorMessage.value = '';
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entities/recipe_draft.dart';
import '../../domain/usecases/submit_recipe_usecase.dart';

class RecipeSubmissionController extends GetxController {
  final SubmitRecipeUseCase submitRecipeUseCase;

  RecipeSubmissionController({required this.submitRecipeUseCase});

  final RxBool _isSubmitting = false.obs;
  final RxString _submissionError = ''.obs;

  bool get isSubmitting => _isSubmitting.value;
  String get submissionError => _submissionError.value;
  bool get hasSubmissionError => _submissionError.value.isNotEmpty;

  Future<bool> submitRecipe({
    required String challengeId,
    required RecipeDraft draft,
  }) async {
    if (!draft.canSubmit) {
      _submissionError.value =
          'Recipe is incomplete. Please fill all required fields.';
      return false;
    }

    _isSubmitting.value = true;
    _submissionError.value = '';

    final result = await submitRecipeUseCase(
      SubmitRecipeParams(challengeId: challengeId, recipeDraft: draft),
    );

    bool success = false;
    result.fold(
      (failure) {
        _submissionError.value = failure.message;
        Get.snackbar(
          'Error',
          'Failed to submit recipe: ${failure.message}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
      (recipe) {
        success = true;
        Get.snackbar(
          'Success',
          'Recipe submitted successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      },
    );

    _isSubmitting.value = false;
    return success;
  }

  void clearError() {
    _submissionError.value = '';
  }
}

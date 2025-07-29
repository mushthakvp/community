import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../domain/entities/ingredient.dart';
import '../../domain/entities/recipe.dart';
import '../../domain/entities/recipe_draft.dart';
import '../../domain/entities/recipe_step.dart';
import '../../domain/usecases/recipe_draft_usecase.dart';

class RecipeDraftController extends GetxController {
  final SaveRecipeDraftUseCase saveRecipeDraftUseCase;
  final LoadRecipeDraftUseCase loadRecipeDraftUseCase;
  final ClearRecipeDraftUseCase clearRecipeDraftUseCase;

  RecipeDraftController({
    required this.saveRecipeDraftUseCase,
    required this.loadRecipeDraftUseCase,
    required this.clearRecipeDraftUseCase,
  });

  final Rx<RecipeDraft> _draft = const RecipeDraft().obs;
  final RxBool _isLoading = false.obs;

  RecipeDraft get draft => _draft.value;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    loadDraft();
  }

  Future<void> loadDraft() async {
    _isLoading.value = true;

    final result = await loadRecipeDraftUseCase(NoParams());
    result.fold(
      (failure) => debugPrint('Failed to load draft: ${failure.message}'),
      (draft) {
        if (draft != null) {
          _draft.value = draft;
        }
      },
    );

    _isLoading.value = false;
  }

  Future<void> saveDraft() async {
    final result = await saveRecipeDraftUseCase(
      SaveDraftParams(draft: _draft.value),
    );
    result.fold(
      (failure) => debugPrint('Failed to save draft: ${failure.message}'),
      (_) => debugPrint('Draft saved successfully'),
    );
  }

  Future<void> clearDraft() async {
    final result = await clearRecipeDraftUseCase(NoParams());
    result.fold(
      (failure) => debugPrint('Failed to clear draft: ${failure.message}'),
      (_) {
        _draft.value = const RecipeDraft();
        debugPrint('Draft cleared successfully');
      },
    );
  }

  void updateTitle(String title) {
    _draft.value = _draft.value.copyWith(title: title);
    saveDraft();
  }

  void updateDescription(String description) {
    _draft.value = _draft.value.copyWith(description: description);
    saveDraft();
  }

  void updateType(RecipeType type) {
    _draft.value = _draft.value.copyWith(type: type);
    saveDraft();
  }

  void updateCookingTime(String cookingTime) {
    _draft.value = _draft.value.copyWith(cookingTime: cookingTime);
    saveDraft();
  }

  void updateDishImageUrl(String imageUrl) {
    _draft.value = _draft.value.copyWith(dishImageUrl: imageUrl);
    saveDraft();
  }

  void updateVideoUrl(String videoUrl) {
    _draft.value = _draft.value.copyWith(videoUrl: videoUrl);
    saveDraft();
  }

  void addIngredient(Ingredient ingredient) {
    final updatedIngredients = List<Ingredient>.from(_draft.value.ingredients)
      ..add(ingredient);
    _draft.value = _draft.value.copyWith(ingredients: updatedIngredients);
    saveDraft();
  }

  void updateIngredient(int index, Ingredient ingredient) {
    final updatedIngredients = List<Ingredient>.from(_draft.value.ingredients);
    if (index >= 0 && index < updatedIngredients.length) {
      updatedIngredients[index] = ingredient;
      _draft.value = _draft.value.copyWith(ingredients: updatedIngredients);
      saveDraft();
    }
  }

  void removeIngredient(int index) {
    final updatedIngredients = List<Ingredient>.from(_draft.value.ingredients);
    if (index >= 0 && index < updatedIngredients.length) {
      updatedIngredients.removeAt(index);
      _draft.value = _draft.value.copyWith(ingredients: updatedIngredients);
      saveDraft();
    }
  }

  void addStep(RecipeStep step) {
    final updatedSteps = List<RecipeStep>.from(_draft.value.steps)..add(step);
    _draft.value = _draft.value.copyWith(steps: updatedSteps);
    saveDraft();
  }

  void updateStep(int index, RecipeStep step) {
    final updatedSteps = List<RecipeStep>.from(_draft.value.steps);
    if (index >= 0 && index < updatedSteps.length) {
      updatedSteps[index] = step;
      _draft.value = _draft.value.copyWith(steps: updatedSteps);
      saveDraft();
    }
  }

  void removeStep(int index) {
    final updatedSteps = List<RecipeStep>.from(_draft.value.steps);
    if (index >= 0 && index < updatedSteps.length) {
      updatedSteps.removeAt(index);
      _draft.value = _draft.value.copyWith(steps: updatedSteps);
      saveDraft();
    }
  }

  void reset() {
    _draft.value = const RecipeDraft();
    clearDraft();
  }
}

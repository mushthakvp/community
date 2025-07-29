import '../../core/constants/recipe_constants.dart';
import '../../recipe_management/domain/entities/recipe.dart';
import '../../recipe_management/domain/entities/recipe_draft.dart';

class RecipeValidator {
  static String? validateTitle(String title) {
    if (title.trim().isEmpty) {
      return RecipeConstants.titleRequiredError;
    }
    if (title.length < RecipeConstants.minTitleLength) {
      return 'Title must be at least ${RecipeConstants.minTitleLength} characters';
    }
    if (title.length > RecipeConstants.maxTitleLength) {
      return 'Title must not exceed ${RecipeConstants.maxTitleLength} characters';
    }
    return null;
  }

  static String? validateDescription(String description) {
    if (description.trim().isEmpty) {
      return RecipeConstants.descriptionRequiredError;
    }
    if (description.length < RecipeConstants.minDescriptionLength) {
      return 'Description must be at least ${RecipeConstants.minDescriptionLength} characters';
    }
    if (description.length > RecipeConstants.maxDescriptionLength) {
      return 'Description must not exceed ${RecipeConstants.maxDescriptionLength} characters';
    }
    return null;
  }

  static String? validateStepTitle(String title) {
    if (title.trim().isEmpty) {
      return 'Step title is required';
    }
    if (title.length < RecipeConstants.minStepTitleLength) {
      return 'Step title must be at least ${RecipeConstants.minStepTitleLength} characters';
    }
    if (title.length > RecipeConstants.maxStepTitleLength) {
      return 'Step title must not exceed ${RecipeConstants.maxStepTitleLength} characters';
    }
    return null;
  }

  static String? validateStepDescription(String description) {
    if (description.trim().isEmpty) {
      return 'Step description is required';
    }
    if (description.length < RecipeConstants.minStepDescriptionLength) {
      return 'Step description must be at least ${RecipeConstants.minStepDescriptionLength} characters';
    }
    if (description.length > RecipeConstants.maxStepDescriptionLength) {
      return 'Step description must not exceed ${RecipeConstants.maxStepDescriptionLength} characters';
    }
    return null;
  }

  static String? validateIngredientName(String name) {
    if (name.trim().isEmpty) {
      return 'Ingredient name is required';
    }
    return null;
  }

  static String? validateIngredientAmount(String amount) {
    if (amount.trim().isEmpty) {
      return 'Ingredient amount is required';
    }
    return null;
  }

  static List<String> validateRecipeDraft(RecipeDraft draft) {
    final errors = <String>[];

    // Title validation
    final titleError = validateTitle(draft.title ?? '');
    if (titleError != null) errors.add(titleError);

    // Description validation
    final descriptionError = validateDescription(draft.description ?? '');
    if (descriptionError != null) errors.add(descriptionError);

    // Ingredients validation
    if (draft.ingredients.isEmpty) {
      errors.add(RecipeConstants.ingredientsRequiredError);
    }

    // Steps validation for text recipes
    if (draft.type == RecipeType.text && draft.steps.isEmpty) {
      errors.add(RecipeConstants.stepsRequiredError);
    }

    // Video recipe specific validation
    if (draft.type == RecipeType.video) {
      if (draft.videoUrl?.isEmpty ?? true) {
        errors.add(RecipeConstants.videoRequiredError);
      }
      if (draft.dishImageUrl?.isEmpty ?? true) {
        errors.add(RecipeConstants.imageRequiredError);
      }
    }

    return errors;
  }

  static bool isRecipeDraftComplete(RecipeDraft draft) {
    return validateRecipeDraft(draft).isEmpty;
  }
}

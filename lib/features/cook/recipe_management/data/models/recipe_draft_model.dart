import '../../domain/entities/recipe.dart';
import '../../domain/entities/recipe_draft.dart';
import 'ingredient_model.dart';
import 'recipe_step_model.dart';

class RecipeDraftModel extends RecipeDraft {
  const RecipeDraftModel({
    super.title,
    super.description,
    super.type,
    super.cookingTime,
    super.dishImageUrl,
    super.videoUrl,
    super.ingredients,
    super.steps,
  });

  factory RecipeDraftModel.fromJson(Map<String, dynamic> json) {
    return RecipeDraftModel(
      title: json['title'],
      description: json['description'],
      type: json['type'] != null
          ? (json['type'] == 'video' ? RecipeType.video : RecipeType.text)
          : null,
      cookingTime: json['cookingTime'],
      dishImageUrl: json['dishImageUrl'],
      videoUrl: json['videoUrl'],
      ingredients: (json['ingredients'] as List? ?? [])
          .map((e) => IngredientModel.fromJson(e))
          .toList(),
      steps: (json['steps'] as List? ?? [])
          .map((e) => RecipeStepModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'type': type?.name,
      'cookingTime': cookingTime,
      'dishImageUrl': dishImageUrl,
      'videoUrl': videoUrl,
      'ingredients': ingredients
          .map((e) => IngredientModel.fromEntity(e).toJson())
          .toList(),
      'steps': steps
          .map((e) => RecipeStepModel.fromEntity(e).toJson())
          .toList(),
    };
  }

  factory RecipeDraftModel.fromEntity(RecipeDraft draft) {
    return RecipeDraftModel(
      title: draft.title,
      description: draft.description,
      type: draft.type,
      cookingTime: draft.cookingTime,
      dishImageUrl: draft.dishImageUrl,
      videoUrl: draft.videoUrl,
      ingredients: draft.ingredients,
      steps: draft.steps,
    );
  }
}

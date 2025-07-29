import '../../domain/entities/recipe.dart';
import 'ingredient_model.dart';
import 'recipe_step_model.dart';

class RecipeModel extends Recipe {
  const RecipeModel({
    required super.id,
    required super.title,
    required super.description,
    required super.type,
    super.cookingTime,
    super.dishImageUrl,
    super.videoUrl,
    required super.ingredients,
    required super.steps,
    required super.createdAt,
    required super.updatedAt,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['_id'] ?? '',
      title: json['recipeTitle'] ?? json['title'] ?? '',
      description: json['description'] ?? '',
      type: _parseRecipeType(json['recipeType']),
      cookingTime: json['cookingTime'],
      dishImageUrl: json['dishPicture'],
      videoUrl: json['video'],
      ingredients: (json['ingredients'] as List? ?? [])
          .map((e) => IngredientModel.fromJson(e))
          .toList(),
      steps: (json['steps'] as List? ?? [])
          .map((e) => RecipeStepModel.fromJson(e))
          .toList(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'recipeTitle': title,
      'description': description,
      'recipeType': type == RecipeType.video ? 'videoRecipe' : 'textRecipe',
      'cookingTime': cookingTime,
      'dishPicture': dishImageUrl,
      'video': videoUrl,
      'ingredients': ingredients
          .map((e) => IngredientModel.fromEntity(e).toJson())
          .toList(),
      'steps': steps
          .map((e) => RecipeStepModel.fromEntity(e).toJson())
          .toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  static RecipeType _parseRecipeType(String? type) {
    switch (type?.toLowerCase()) {
      case 'videorecipe':
      case 'video':
        return RecipeType.video;
      case 'textrecipe':
      case 'text':
      default:
        return RecipeType.text;
    }
  }

  factory RecipeModel.fromEntity(Recipe recipe) {
    return RecipeModel(
      id: recipe.id,
      title: recipe.title,
      description: recipe.description,
      type: recipe.type,
      cookingTime: recipe.cookingTime,
      dishImageUrl: recipe.dishImageUrl,
      videoUrl: recipe.videoUrl,
      ingredients: recipe.ingredients,
      steps: recipe.steps,
      createdAt: recipe.createdAt,
      updatedAt: recipe.updatedAt,
    );
  }
}

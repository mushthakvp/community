import 'package:equatable/equatable.dart';

import 'ingredient.dart';
import 'recipe.dart';
import 'recipe_step.dart';

class RecipeDraft extends Equatable {
  final String? title;
  final String? description;
  final RecipeType? type;
  final String? cookingTime;
  final String? dishImageUrl;
  final String? videoUrl;
  final List<Ingredient> ingredients;
  final List<RecipeStep> steps;

  const RecipeDraft({
    this.title,
    this.description,
    this.type,
    this.cookingTime,
    this.dishImageUrl,
    this.videoUrl,
    this.ingredients = const [],
    this.steps = const [],
  });

  RecipeDraft copyWith({
    String? title,
    String? description,
    RecipeType? type,
    String? cookingTime,
    String? dishImageUrl,
    String? videoUrl,
    List<Ingredient>? ingredients,
    List<RecipeStep>? steps,
  }) {
    return RecipeDraft(
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      cookingTime: cookingTime ?? this.cookingTime,
      dishImageUrl: dishImageUrl ?? this.dishImageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
    );
  }

  bool get canProceedToSteps =>
      title?.isNotEmpty == true &&
      description?.isNotEmpty == true &&
      ingredients.isNotEmpty;

  bool get canSubmit =>
      canProceedToSteps &&
      steps.isNotEmpty &&
      ((type == RecipeType.video && videoUrl?.isNotEmpty == true) ||
          type == RecipeType.text);

  @override
  List<Object?> get props => [
    title,
    description,
    type,
    cookingTime,
    dishImageUrl,
    videoUrl,
    ingredients,
    steps,
  ];
}

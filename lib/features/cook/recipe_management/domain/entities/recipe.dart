import 'package:equatable/equatable.dart';

import 'ingredient.dart';
import 'recipe_step.dart';

enum RecipeType { text, video }

class Recipe extends Equatable {
  final String id;
  final String title;
  final String description;
  final RecipeType type;
  final String? cookingTime;
  final String? dishImageUrl;
  final String? videoUrl;
  final List<Ingredient> ingredients;
  final List<RecipeStep> steps;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.cookingTime,
    this.dishImageUrl,
    this.videoUrl,
    required this.ingredients,
    required this.steps,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isComplete =>
      title.isNotEmpty &&
      description.isNotEmpty &&
      ingredients.isNotEmpty &&
      steps.isNotEmpty;

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    type,
    cookingTime,
    dishImageUrl,
    videoUrl,
    ingredients,
    steps,
    createdAt,
    updatedAt,
  ];
}

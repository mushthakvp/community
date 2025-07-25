import 'package:equatable/equatable.dart';

class RecipeSubmission extends Equatable {
  final String challengeId;
  final String title;
  final String description;
  final String recipeType;
  final List<Map<String, dynamic>>? ingredients;
  final List<Map<String, dynamic>>? steps;
  final String? cookingTime;
  final String? image;
  final String? video;

  const RecipeSubmission({
    required this.challengeId,
    required this.title,
    required this.description,
    required this.recipeType,
    this.ingredients,
    this.steps,
    this.cookingTime,
    this.image,
    this.video,
  });

  bool get isTextRecipe => recipeType == 'text';
  bool get isVideoRecipe => recipeType == 'video';

  @override
  List<Object?> get props => [
    challengeId,
    title,
    description,
    recipeType,
    ingredients,
    steps,
    cookingTime,
    image,
    video,
  ];
}

import '../../domain/entities/recipe_submission.dart';

class RecipeSubmissionModel extends RecipeSubmission {
  const RecipeSubmissionModel({
    required super.challengeId,
    required super.title,
    required super.description,
    required super.recipeType,
    super.ingredients,
    super.steps,
    super.cookingTime,
    super.image,
    super.video,
  });

  factory RecipeSubmissionModel.fromJson(Map<String, dynamic> json) {
    return RecipeSubmissionModel(
      challengeId: json['challengeId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      recipeType: json['recipeType'] ?? 'text',
      ingredients: json['ingredients'] != null
          ? List<Map<String, dynamic>>.from(json['ingredients'])
          : null,
      steps: json['steps'] != null
          ? List<Map<String, dynamic>>.from(json['steps'])
          : null,
      cookingTime: json['cookingTime'],
      image: json['image'],
      video: json['video'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'challengeId': challengeId,
      'title': title,
      'description': description,
      'recipeType': recipeType,
      if (ingredients != null) 'ingredients': ingredients,
      if (steps != null) 'steps': steps,
      if (cookingTime != null) 'cookingTime': cookingTime,
      if (image != null) 'image': image,
      if (video != null) 'video': video,
    };
  }

  factory RecipeSubmissionModel.fromEntity(RecipeSubmission submission) {
    return RecipeSubmissionModel(
      challengeId: submission.challengeId,
      title: submission.title,
      description: submission.description,
      recipeType: submission.recipeType,
      ingredients: submission.ingredients,
      steps: submission.steps,
      cookingTime: submission.cookingTime,
      image: submission.image,
      video: submission.video,
    );
  }
}

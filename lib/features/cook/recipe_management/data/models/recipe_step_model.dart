import '../../domain/entities/recipe_step.dart';

class RecipeStepModel extends RecipeStep {
  const RecipeStepModel({
    required super.id,
    required super.title,
    required super.description,
    super.imageUrl,
    required super.order,
  });

  factory RecipeStepModel.fromJson(Map<String, dynamic> json) {
    return RecipeStepModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image'],
      order: json['order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'image': imageUrl,
      'order': order,
    };
  }

  factory RecipeStepModel.fromEntity(RecipeStep step) {
    return RecipeStepModel(
      id: step.id,
      title: step.title,
      description: step.description,
      imageUrl: step.imageUrl,
      order: step.order,
    );
  }
}

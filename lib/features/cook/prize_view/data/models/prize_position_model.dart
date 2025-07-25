import '../../domain/entities/prize_position.dart';
import 'prize_ingredient_model.dart';
import 'prize_step_model.dart';
import 'prize_user_model.dart';

class PrizePositionModel extends PrizePosition {
  const PrizePositionModel({
    required super.id,
    super.user,
    required super.challengeId,
    required super.title,
    super.recipeTitle,
    super.description,
    super.cookingTime,
    super.dishPicture,
    super.endDate,
    required super.isEnteredCompleteData,
    required super.isResultAdded,
    super.position,
    super.ingredients = const [],
    super.steps = const [],
    super.createdAt,
    super.updatedAt,
    super.recipeType,
    super.video,
  });

  factory PrizePositionModel.fromJson(Map<String, dynamic> json) {
    return PrizePositionModel(
      id: json['_id'] ?? '',
      user: json['user'] != null ? PrizeUserModel.fromJson(json['user']) : null,
      challengeId: json['challengeId'] ?? '',
      title: json['title'] ?? '',
      recipeTitle: json['recipeTitle'],
      description: json['description'],
      cookingTime: json['cookingTime'],
      dishPicture: json['dishPicture'],
      endDate: json['endData'] != null ? DateTime.parse(json['endData']) : null,
      isEnteredCompleteData: json['isEnteredCompleteData'] ?? false,
      isResultAdded: json['isResultAdded'] ?? false,
      position: json['position'],
      ingredients: json['ingredients'] != null
          ? (json['ingredients'] as List)
                .map((x) => PrizeIngredientModel.fromJson(x))
                .toList()
          : [],
      steps: json['steps'] != null
          ? (json['steps'] as List)
                .map((x) => PrizeStepModel.fromJson(x))
                .toList()
          : [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      recipeType: json['recipeType'],
      video: json['video'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user != null ? PrizeUserModel.fromEntity(user!).toJson() : null,
      'challengeId': challengeId,
      'title': title,
      'recipeTitle': recipeTitle,
      'description': description,
      'cookingTime': cookingTime,
      'dishPicture': dishPicture,
      'endData': endDate?.toIso8601String(),
      'isEnteredCompleteData': isEnteredCompleteData,
      'isResultAdded': isResultAdded,
      'position': position,
      'ingredients': ingredients
          .map((x) => PrizeIngredientModel.fromEntity(x).toJson())
          .toList(),
      'steps': steps.map((x) => PrizeStepModel.fromEntity(x).toJson()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'recipeType': recipeType,
      'video': video,
    };
  }

  factory PrizePositionModel.fromEntity(PrizePosition position) {
    return PrizePositionModel(
      id: position.id,
      user: position.user,
      challengeId: position.challengeId,
      title: position.title,
      recipeTitle: position.recipeTitle,
      description: position.description,
      cookingTime: position.cookingTime,
      dishPicture: position.dishPicture,
      endDate: position.endDate,
      isEnteredCompleteData: position.isEnteredCompleteData,
      isResultAdded: position.isResultAdded,
      position: position.position,
      ingredients: position.ingredients,
      steps: position.steps,
      createdAt: position.createdAt,
      updatedAt: position.updatedAt,
      recipeType: position.recipeType,
      video: position.video,
    );
  }
}

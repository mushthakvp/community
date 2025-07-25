import 'package:equatable/equatable.dart';

import 'prize_ingredient.dart';
import 'prize_step.dart';
import 'prize_user.dart';

class PrizePosition extends Equatable {
  final String id;
  final PrizeUser? user;
  final String challengeId;
  final String title;
  final String? recipeTitle;
  final String? description;
  final int? cookingTime;
  final String? dishPicture;
  final DateTime? endDate;
  final bool isEnteredCompleteData;
  final bool isResultAdded;
  final int? position;
  final List<PrizeIngredient> ingredients;
  final List<PrizeStep> steps;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? recipeType;
  final String? video;

  const PrizePosition({
    required this.id,
    this.user,
    required this.challengeId,
    required this.title,
    this.recipeTitle,
    this.description,
    this.cookingTime,
    this.dishPicture,
    this.endDate,
    required this.isEnteredCompleteData,
    required this.isResultAdded,
    this.position,
    this.ingredients = const [],
    this.steps = const [],
    this.createdAt,
    this.updatedAt,
    this.recipeType,
    this.video,
  });

  bool get isWinner => position != null && position! <= 3;
  bool get isFirstPlace => position == 1;
  String get positionSuffix {
    if (position == null) return '';
    switch (position) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  @override
  List<Object?> get props => [
    id,
    user,
    challengeId,
    title,
    recipeTitle,
    description,
    cookingTime,
    dishPicture,
    endDate,
    isEnteredCompleteData,
    isResultAdded,
    position,
    ingredients,
    steps,
    createdAt,
    updatedAt,
    recipeType,
    video,
  ];
}

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/recipe.dart';
import '../entities/recipe_draft.dart';
import '../repositories/recipe_repository.dart';

class SubmitRecipeUseCase implements UseCase<Recipe, SubmitRecipeParams> {
  final RecipeRepository repository;

  SubmitRecipeUseCase(this.repository);

  @override
  Future<Either<Failure, Recipe>> call(SubmitRecipeParams params) async {
    return await repository.submitRecipe(
      challengeId: params.challengeId,
      recipeDraft: params.recipeDraft,
    );
  }
}

class SubmitRecipeParams extends Equatable {
  final String challengeId;
  final RecipeDraft recipeDraft;

  const SubmitRecipeParams({
    required this.challengeId,
    required this.recipeDraft,
  });

  @override
  List<Object> get props => [challengeId, recipeDraft];
}

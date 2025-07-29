import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/recipe.dart';
import '../entities/recipe_draft.dart';

abstract class RecipeRepository {
  Future<Either<Failure, Recipe>> submitRecipe({
    required String challengeId,
    required RecipeDraft recipeDraft,
  });

  Future<Either<Failure, String>> uploadImage(String imagePath);
  Future<Either<Failure, String>> uploadVideo(String videoPath);

  Future<Either<Failure, void>> saveDraft(RecipeDraft draft);
  Future<Either<Failure, RecipeDraft?>> loadDraft();
  Future<Either<Failure, void>> clearDraft();
}

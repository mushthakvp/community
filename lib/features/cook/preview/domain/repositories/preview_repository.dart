import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/recipe_submission.dart';

abstract class PreviewRepository {
  Future<Either<Failure, bool>> submitRecipe(RecipeSubmission submission);
}

import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/recipe_submission.dart';
import '../../domain/repositories/preview_repository.dart';
import '../datasources/preview_remote_data_source.dart';
import '../models/recipe_submission_model.dart';

class PreviewRepositoryImpl implements PreviewRepository {
  final PreviewRemoteDataSource remoteDataSource;

  PreviewRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, bool>> submitRecipe(
    RecipeSubmission submission,
  ) async {
    try {
      final model = RecipeSubmissionModel.fromEntity(submission);
      final recipeData = model.toJson();

      final result = submission.isTextRecipe
          ? await remoteDataSource.submitTextRecipe(
              challengeId: submission.challengeId,
              recipeData: recipeData,
            )
          : await remoteDataSource.submitVideoRecipe(
              challengeId: submission.challengeId,
              recipeData: recipeData,
            );

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}

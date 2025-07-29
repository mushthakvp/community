import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/recipe.dart';
import '../../domain/entities/recipe_draft.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../datasources/recipe_local_data_source.dart';
import '../datasources/recipe_remote_data_source.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeRemoteDataSource remoteDataSource;
  final RecipeLocalDataSource localDataSource;

  RecipeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, Recipe>> submitRecipe({
    required String challengeId,
    required RecipeDraft recipeDraft,
  }) async {
    try {
      final recipe = await remoteDataSource.submitRecipe(
        challengeId: challengeId,
        recipeDraft: recipeDraft,
      );
      await localDataSource.clearDraft();
      return Right(recipe);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadImage(String imagePath) async {
    return Left(UnknownFailure(message: 'Use MediaRepository instead'));
  }

  @override
  Future<Either<Failure, String>> uploadVideo(String videoPath) async {
    return Left(UnknownFailure(message: 'Use MediaRepository instead'));
  }

  @override
  Future<Either<Failure, void>> saveDraft(RecipeDraft draft) async {
    try {
      await localDataSource.saveDraft(draft);
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RecipeDraft?>> loadDraft() async {
    try {
      final draft = await localDataSource.loadDraft();
      return Right(draft);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearDraft() async {
    try {
      await localDataSource.clearDraft();
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}

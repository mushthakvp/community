import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/recipe_submission.dart';
import '../repositories/preview_repository.dart';

class SubmitRecipeUseCase implements UseCase<bool, SubmitRecipeParams> {
  final PreviewRepository repository;

  SubmitRecipeUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(SubmitRecipeParams params) async {
    return await repository.submitRecipe(params.submission);
  }
}

class SubmitRecipeParams extends Equatable {
  final RecipeSubmission submission;

  const SubmitRecipeParams({required this.submission});

  @override
  List<Object> get props => [submission];
}

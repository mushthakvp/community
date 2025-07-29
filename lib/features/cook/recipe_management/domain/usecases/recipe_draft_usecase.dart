import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/recipe_draft.dart';
import '../repositories/recipe_repository.dart';

class SaveRecipeDraftUseCase implements UseCase<void, SaveDraftParams> {
  final RecipeRepository repository;

  SaveRecipeDraftUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SaveDraftParams params) async {
    return await repository.saveDraft(params.draft);
  }
}

class SaveDraftParams extends Equatable {
  final RecipeDraft draft;

  const SaveDraftParams({required this.draft});

  @override
  List<Object> get props => [draft];
}

class LoadRecipeDraftUseCase implements UseCase<RecipeDraft?, NoParams> {
  final RecipeRepository repository;

  LoadRecipeDraftUseCase(this.repository);

  @override
  Future<Either<Failure, RecipeDraft?>> call(NoParams params) async {
    return await repository.loadDraft();
  }
}

class ClearRecipeDraftUseCase implements UseCase<void, NoParams> {
  final RecipeRepository repository;

  ClearRecipeDraftUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.clearDraft();
  }
}

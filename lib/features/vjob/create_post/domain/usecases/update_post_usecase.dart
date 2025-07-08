import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/create_post_entity.dart';
import '../repositories/create_post_repository.dart';

class UpdatePostUseCase implements UseCase<CreatePostEntity, UpdatePostParams> {
  final CreatePostRepository repository;

  UpdatePostUseCase(this.repository);

  @override
  Future<Either<Failure, CreatePostEntity>> call(
    UpdatePostParams params,
  ) async {
    return await repository.updatePost(params.request);
  }
}

class UpdatePostParams extends Equatable {
  final UpdatePostRequest request;

  const UpdatePostParams({required this.request});

  @override
  List<Object> get props => [request];
}

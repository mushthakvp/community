import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/create_post_entity.dart';
import '../repositories/create_post_repository.dart';

class CreatePostUseCase implements UseCase<CreatePostEntity, CreatePostParams> {
  final CreatePostRepository repository;

  CreatePostUseCase(this.repository);

  @override
  Future<Either<Failure, CreatePostEntity>> call(
    CreatePostParams params,
  ) async {
    return await repository.createPost(params.request);
  }
}

class CreatePostParams extends Equatable {
  final CreatePostRequest request;

  const CreatePostParams({required this.request});

  @override
  List<Object> get props => [request];
}

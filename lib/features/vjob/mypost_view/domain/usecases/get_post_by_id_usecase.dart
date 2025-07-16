import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/my_post_entity.dart';
import '../repositories/my_post_repository.dart';

class GetPostByIdUseCase implements UseCase<MyPostEntity, GetPostByIdParams> {
  final MyPostRepository repository;

  GetPostByIdUseCase(this.repository);

  @override
  Future<Either<Failure, MyPostEntity>> call(GetPostByIdParams params) async {
    return await repository.getPostById(params.postId);
  }
}

class GetPostByIdParams extends Equatable {
  final String postId;

  const GetPostByIdParams({required this.postId});

  @override
  List<Object> get props => [postId];
}

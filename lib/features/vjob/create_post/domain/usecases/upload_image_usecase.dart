import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/create_post_repository.dart';

class UploadImageUseCase implements UseCase<String, UploadImageParams> {
  final CreatePostRepository repository;

  UploadImageUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(UploadImageParams params) async {
    return await repository.uploadImage(params.imagePath);
  }
}

class UploadImageParams extends Equatable {
  final String imagePath;

  const UploadImageParams({required this.imagePath});

  @override
  List<Object> get props => [imagePath];
}

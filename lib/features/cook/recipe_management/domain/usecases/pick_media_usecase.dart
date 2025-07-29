import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/media_repository.dart';

class PickImageUseCase implements UseCase<File?, NoParams> {
  final MediaRepository repository;

  PickImageUseCase(this.repository);

  @override
  Future<Either<Failure, File?>> call(NoParams params) async {
    return await repository.pickImageFromGallery();
  }
}

class PickVideoUseCase implements UseCase<File?, NoParams> {
  final MediaRepository repository;

  PickVideoUseCase(this.repository);

  @override
  Future<Either<Failure, File?>> call(NoParams params) async {
    return await repository.pickVideoFromGallery();
  }
}

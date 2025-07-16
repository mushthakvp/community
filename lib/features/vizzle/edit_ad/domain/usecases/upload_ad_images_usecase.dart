import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/edit_ad_repository.dart';

class UploadAdImagesUseCase
    implements UseCase<List<String>, UploadAdImagesParams> {
  final EditAdRepository repository;

  UploadAdImagesUseCase(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(
    UploadAdImagesParams params,
  ) async {
    return await repository.uploadImages(params.imagePaths);
  }
}

class UploadAdImagesParams extends Equatable {
  final List<String> imagePaths;

  const UploadAdImagesParams({required this.imagePaths});

  @override
  List<Object> get props => [imagePaths];
}

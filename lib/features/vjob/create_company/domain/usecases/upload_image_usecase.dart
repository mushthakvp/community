import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/create_company_repository.dart';

class UploadImageUseCase implements UseCase<String, UploadImageParams> {
  final CreateCompanyRepository repository;

  UploadImageUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(UploadImageParams params) async {
    return await repository.uploadImage(params.filePath);
  }
}

class UploadImageParams extends Equatable {
  final String filePath;

  const UploadImageParams({required this.filePath});

  @override
  List<Object> get props => [filePath];
}

import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/community_repository.dart';

class UploadProfileImage implements UseCase<String, UploadProfileImageParams> {
  final CommunityRepository repository;

  UploadProfileImage(this.repository);

  @override
  Future<Either<Failure, String>> call(UploadProfileImageParams params) async {
    return await repository.uploadProfileImage(params.imagePath);
  }
}

class UploadProfileImageParams {
  final String imagePath;

  UploadProfileImageParams({required this.imagePath});
}

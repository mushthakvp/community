import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/chat_repository.dart';

class UploadMedia implements UseCase<String, UploadMediaParams> {
  final ChatRepository repository;

  UploadMedia(this.repository);

  @override
  Future<Either<Failure, String>> call(UploadMediaParams params) async {
    return await repository.uploadMedia(params.filePath);
  }
}

class UploadMediaParams {
  final String filePath;

  UploadMediaParams({required this.filePath});
}

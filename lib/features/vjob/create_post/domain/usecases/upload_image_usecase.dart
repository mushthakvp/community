import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../repositories/create_post_repository.dart';

class UploadImageUseCase {
  final CreatePostRepository repository;

  UploadImageUseCase(this.repository);

  Future<Either<Failure, String>> call(String filePath) async {
    if (filePath.trim().isEmpty) {
      return const Left(ValidationFailure(message: 'File path is required'));
    }

    // Validate file extension
    final allowedExtensions = ['.jpg', '.jpeg', '.png', '.pdf'];
    final fileExtension = filePath.toLowerCase().split('.').last;

    if (!allowedExtensions.any((ext) => ext.contains(fileExtension))) {
      return const Left(
        ValidationFailure(
          message: 'Only JPG, JPEG, PNG, and PDF files are allowed',
        ),
      );
    }

    return await repository.uploadImage(filePath.trim());
  }
}

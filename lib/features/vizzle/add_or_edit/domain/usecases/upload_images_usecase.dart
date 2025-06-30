import 'dart:io';

import '../../../../../core/utils/result.dart';
import '../repositories/add_edit_repository.dart';

class UploadImagesUseCase {
  final AddEditRepository repository;

  UploadImagesUseCase(this.repository);

  Future<Result<List<String>>> call(List<File> images) async {
    return await repository.uploadImages(images);
  }
}

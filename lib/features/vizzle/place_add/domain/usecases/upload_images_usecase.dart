import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/place_add_repository.dart';

class UploadImagesUseCase implements UseCase<List<String>, List<XFile>> {
  final PlaceAddRepository repository;

  UploadImagesUseCase(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(List<XFile> params) async {
    return await repository.uploadImages(params);
  }
}

import '../../../../../core/utils/result.dart';
import '../../data/models/ad_creation_model.dart';
import '../repositories/add_edit_repository.dart';

class CreateAdUseCase {
  final AddEditRepository repository;

  CreateAdUseCase(this.repository);

  Future<Result<String>> call(AdCreationModel adModel) async {
    return await repository.createAd(adModel);
  }
}

import '../../../../../core/utils/result.dart';
import '../../data/models/ad_creation_model.dart';
import '../repositories/add_edit_repository.dart';

class UpdateAdUseCase {
  final AddEditRepository repository;

  UpdateAdUseCase(this.repository);

  Future<Result<String>> call(String adId, AdCreationModel adModel) async {
    return await repository.updateAd(adId, adModel);
  }
}

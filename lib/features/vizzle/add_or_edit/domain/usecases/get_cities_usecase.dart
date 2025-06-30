import '../../../../../core/utils/result.dart';
import '../../data/models/cities_response_model.dart';
import '../repositories/add_edit_repository.dart';

class GetCitiesUseCase {
  final AddEditRepository repository;

  GetCitiesUseCase(this.repository);

  Future<Result<CitiesResponseModel>> call() async {
    return await repository.getCitiesAndCategories();
  }
}

import 'package:get/get.dart';

import '../../preview/data/datasources/preview_remote_data_source.dart';
import '../../preview/data/repositories/preview_repository_impl.dart';
import '../../preview/domain/repositories/preview_repository.dart';
import '../../preview/domain/usecases/submit_recipe_usecase.dart';

class PreviewInjection {
  static void init() {
    // Data sources
    Get.lazyPut<PreviewRemoteDataSource>(
      () => PreviewRemoteDataSourceImpl(apiClient: Get.find()),
      tag: 'preview',
    );

    // Repositories
    Get.lazyPut<PreviewRepository>(
      () => PreviewRepositoryImpl(
        remoteDataSource: Get.find<PreviewRemoteDataSource>(tag: 'preview'),
      ),
      tag: 'preview',
    );

    // Use cases
    Get.lazyPut<SubmitRecipeUseCase>(
      () => SubmitRecipeUseCase(Get.find<PreviewRepository>(tag: 'preview')),
      tag: 'preview',
    );
  }
}

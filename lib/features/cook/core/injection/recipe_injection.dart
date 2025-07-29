import 'package:get/get.dart';

import '../../recipe_management/data/datasources/media_remote_data_source.dart';
import '../../recipe_management/data/datasources/recipe_local_data_source.dart';
import '../../recipe_management/data/datasources/recipe_remote_data_source.dart';
import '../../recipe_management/data/repositories/media_repository_impl.dart';
import '../../recipe_management/data/repositories/recipe_repository_impl.dart';
import '../../recipe_management/domain/repositories/media_repository.dart';
import '../../recipe_management/domain/repositories/recipe_repository.dart';
import '../../recipe_management/domain/usecases/pick_media_usecase.dart';
import '../../recipe_management/domain/usecases/recipe_draft_usecase.dart';
import '../../recipe_management/domain/usecases/submit_recipe_usecase.dart';
import '../../recipe_management/domain/usecases/upload_media_usecase.dart';
import '../../recipe_management/presentation/controllers/media_upload_controller.dart';
import '../../recipe_management/presentation/controllers/recipe_draft_controller.dart';
import '../../recipe_management/presentation/controllers/recipe_submission_controller.dart';
import '../../recipe_management/presentation/controllers/recipe_type_controller.dart';

class RecipeInjection {
  static void init() {
    _initDataSources();
    _initRepositories();
    _initUseCases();
    _initControllers();
  }

  static void _initDataSources() {
    // Remote data sources
    Get.lazyPut<RecipeRemoteDataSource>(
      () => RecipeRemoteDataSourceImpl(apiClient: Get.find()),
      tag: 'recipe_remote',
    );

    Get.lazyPut<MediaRemoteDataSource>(
      () => MediaRemoteDataSourceImpl(),
      tag: 'media_remote',
    );

    // Local data sources
    Get.lazyPut<RecipeLocalDataSource>(
      () => RecipeLocalDataSourceImpl(),
      tag: 'recipe_local',
    );
  }

  static void _initRepositories() {
    Get.lazyPut<RecipeRepository>(
      () => RecipeRepositoryImpl(
        remoteDataSource: Get.find<RecipeRemoteDataSource>(
          tag: 'recipe_remote',
        ),
        localDataSource: Get.find<RecipeLocalDataSource>(tag: 'recipe_local'),
      ),
      tag: 'recipe_repository',
    );

    Get.lazyPut<MediaRepository>(
      () => MediaRepositoryImpl(
        remoteDataSource: Get.find<MediaRemoteDataSource>(tag: 'media_remote'),
      ),
      tag: 'media_repository',
    );
  }

  static void _initUseCases() {
    // Recipe use cases
    Get.lazyPut<SubmitRecipeUseCase>(
      () => SubmitRecipeUseCase(
        Get.find<RecipeRepository>(tag: 'recipe_repository'),
      ),
      tag: 'submit_recipe',
    );

    Get.lazyPut<SaveRecipeDraftUseCase>(
      () => SaveRecipeDraftUseCase(
        Get.find<RecipeRepository>(tag: 'recipe_repository'),
      ),
      tag: 'save_draft',
    );

    Get.lazyPut<LoadRecipeDraftUseCase>(
      () => LoadRecipeDraftUseCase(
        Get.find<RecipeRepository>(tag: 'recipe_repository'),
      ),
      tag: 'load_draft',
    );

    Get.lazyPut<ClearRecipeDraftUseCase>(
      () => ClearRecipeDraftUseCase(
        Get.find<RecipeRepository>(tag: 'recipe_repository'),
      ),
      tag: 'clear_draft',
    );

    // Media use cases
    Get.lazyPut<PickImageUseCase>(
      () =>
          PickImageUseCase(Get.find<MediaRepository>(tag: 'media_repository')),
      tag: 'pick_image',
    );

    Get.lazyPut<PickVideoUseCase>(
      () =>
          PickVideoUseCase(Get.find<MediaRepository>(tag: 'media_repository')),
      tag: 'pick_video',
    );

    Get.lazyPut<UploadImageUseCase>(
      () => UploadImageUseCase(
        Get.find<MediaRepository>(tag: 'media_repository'),
      ),
      tag: 'upload_image',
    );

    Get.lazyPut<UploadVideoUseCase>(
      () => UploadVideoUseCase(
        Get.find<MediaRepository>(tag: 'media_repository'),
      ),
      tag: 'upload_video',
    );
  }

  static void _initControllers() {
    // Recipe draft controller - singleton as it maintains state across screens
    Get.put<RecipeDraftController>(
      RecipeDraftController(
        saveRecipeDraftUseCase: Get.find<SaveRecipeDraftUseCase>(
          tag: 'save_draft',
        ),
        loadRecipeDraftUseCase: Get.find<LoadRecipeDraftUseCase>(
          tag: 'load_draft',
        ),
        clearRecipeDraftUseCase: Get.find<ClearRecipeDraftUseCase>(
          tag: 'clear_draft',
        ),
      ),
      permanent: true,
    );

    // Media upload controller - singleton for consistent upload state
    Get.put<MediaUploadController>(
      MediaUploadController(
        pickImageUseCase: Get.find<PickImageUseCase>(tag: 'pick_image'),
        pickVideoUseCase: Get.find<PickVideoUseCase>(tag: 'pick_video'),
        uploadImageUseCase: Get.find<UploadImageUseCase>(tag: 'upload_image'),
        uploadVideoUseCase: Get.find<UploadVideoUseCase>(tag: 'upload_video'),
      ),
      permanent: true,
    );

    // Recipe submission controller - singleton for submission state
    Get.put<RecipeSubmissionController>(
      RecipeSubmissionController(
        submitRecipeUseCase: Get.find<SubmitRecipeUseCase>(
          tag: 'submit_recipe',
        ),
      ),
      permanent: true,
    );

    // Recipe type controller - can be recreated per selection
    Get.lazyPut<RecipeTypeController>(() => RecipeTypeController());
  }

  static void dispose() {
    // Clean up controllers when feature is no longer needed
    if (Get.isRegistered<RecipeDraftController>()) {
      Get.delete<RecipeDraftController>();
    }
    if (Get.isRegistered<MediaUploadController>()) {
      Get.delete<MediaUploadController>();
    }
    if (Get.isRegistered<RecipeSubmissionController>()) {
      Get.delete<RecipeSubmissionController>();
    }
    if (Get.isRegistered<RecipeTypeController>()) {
      Get.delete<RecipeTypeController>();
    }
  }
}

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../core/network/network_info.dart';
import '../../home/data/datasources/home_remote_data_source.dart';
import '../../home/data/repositories/home_repository_impl.dart';
import '../../home/domain/repositories/home_repository.dart';
import '../../home/domain/usecases/get_cooking_home_usecase.dart';
import '../../home/domain/usecases/search_challenges_usecase.dart';
import '../../my_challenges/data/datasources/my_challenges_remote_data_source.dart';
import '../../my_challenges/data/repositories/my_challenges_repository_impl.dart';
import '../../my_challenges/domain/repositories/my_challenges_repository.dart';
import '../../my_challenges/domain/usecases/get_my_challenges_usecase.dart';
import '../../my_challenges/domain/usecases/join_challenge_usecase.dart';
import '../../search/data/datasources/search_local_data_source.dart';
import '../../search/data/datasources/search_remote_data_source.dart';
import '../../search/data/repositories/search_repository_impl.dart';
import '../../search/domain/repositories/search_repository.dart';
import '../../search/domain/usecases/search_challenges_usecase.dart' as search;
import '../network/cook_api_client.dart';
import 'challenge_details_injection.dart';

class CookInjection {
  static void init() {
    _initCore();
    _initDataSources();
    _initRepositories();
    _initUseCases();
    ChallengeDetailsInjection.init();
  }

  static void _initCore() {
    if (!Get.isRegistered<http.Client>()) {
      Get.lazyPut<http.Client>(() => http.Client());
    }
    Get.lazyPut<CookApiClient>(
      () => CookApiClient(
        client: Get.find<http.Client>(),
        networkInfo: Get.find<NetworkInfo>(),
      ),
    );
  }

  static void _initDataSources() {
    Get.lazyPut<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(apiClient: Get.find<CookApiClient>()),
    );
    Get.lazyPut<MyChallengesRemoteDataSource>(
      () => MyChallengesRemoteDataSourceImpl(
        apiClient: Get.find<CookApiClient>(),
      ),
    );
    Get.lazyPut<SearchLocalDataSource>(() => SearchLocalDataSourceImpl());
    Get.lazyPut<SearchRemoteDataSource>(
      () => SearchRemoteDataSourceImpl(apiClient: Get.find<CookApiClient>()),
    );
  }

  static void _initRepositories() {
    Get.lazyPut<HomeRepository>(
      () => HomeRepositoryImpl(
        remoteDataSource: Get.find<HomeRemoteDataSource>(),
      ),
    );
    Get.lazyPut<MyChallengesRepository>(
      () => MyChallengesRepositoryImpl(
        remoteDataSource: Get.find<MyChallengesRemoteDataSource>(),
      ),
    );
    Get.lazyPut<SearchRepository>(
      () => SearchRepositoryImpl(
        remoteDataSource: Get.find<SearchRemoteDataSource>(),
        localDataSource: Get.find<SearchLocalDataSource>(),
      ),
    );
  }

  static void _initUseCases() {
    Get.lazyPut<GetCookingHomeUseCase>(
      () => GetCookingHomeUseCase(Get.find<HomeRepository>()),
    );
    Get.lazyPut<SearchChallengesUseCase>(
      () => SearchChallengesUseCase(Get.find<HomeRepository>()),
    );
    Get.lazyPut<GetMyChallengesUseCase>(
      () => GetMyChallengesUseCase(Get.find<MyChallengesRepository>()),
      tag: 'cook_my_challenges',
    );
    Get.lazyPut<JoinChallengeUseCase>(
      () => JoinChallengeUseCase(Get.find<MyChallengesRepository>()),
      tag: 'my_challenges_join',
    );
    Get.lazyPut<search.SearchChallengesUseCase>(
      () => search.SearchChallengesUseCase(Get.find<SearchRepository>()),
    );
  }
}

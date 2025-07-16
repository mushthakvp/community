import 'package:get/get.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/network_info.dart';
import '../../home/data/datasources/home_local_datasource.dart';
import '../../home/data/datasources/home_remote_datasource.dart';
import '../../home/data/repositories/home_repository_impl.dart';
import '../../home/domain/repositories/home_repository.dart';
import '../../home/domain/usecases/get_home_data.dart';
import '../../home/domain/usecases/get_location.dart';
import '../../home/presentation/controllers/home_controller.dart';
import '../../navigation/data/repositories/navigation_repository_impl.dart';
import '../../navigation/domain/repositories/navigation_repository.dart';
import '../../navigation/presentation/controllers/bottom_nav_controller.dart';

class VCartInjection {
  static void init() {
    Get.lazyPut<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
    );
    Get.lazyPut<HomeLocalDataSource>(() => HomeLocalDataSourceImpl());
    Get.lazyPut<HomeRepository>(
      () => HomeRepositoryImpl(
        remoteDataSource: Get.find<HomeRemoteDataSource>(),
        localDataSource: Get.find<HomeLocalDataSource>(),
        networkInfo: Get.find<NetworkInfo>(),
      ),
    );
    Get.lazyPut<NavigationRepository>(() => NavigationRepositoryImpl());
    Get.lazyPut(() => GetHomeData(Get.find<HomeRepository>()));
    Get.lazyPut(() => GetLocation(Get.find<HomeRepository>()));
    Get.lazyPut(
      () => VCartHomeController(
        getHomeDataUseCase: Get.find<GetHomeData>(),
        getLocationUseCase: Get.find<GetLocation>(),
      ),
    );
    Get.lazyPut(
      () => VCartBottomNavController(
        repository: Get.find<NavigationRepository>(),
      ),
    );
  }

  static void dispose() {
    Get.delete<VCartHomeController>();
    Get.delete<VCartBottomNavController>();
    Get.delete<GetHomeData>();
    Get.delete<GetLocation>();
    Get.delete<HomeRepository>();
    Get.delete<NavigationRepository>();
    Get.delete<HomeRemoteDataSource>();
    Get.delete<HomeLocalDataSource>();
  }
}

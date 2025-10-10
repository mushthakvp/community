import 'package:get/get.dart';

import '../network/cook_api_client.dart';
import '../../prize_view/data/datasources/prize_overview_remote_data_source.dart';
import '../../prize_view/data/repositories/prize_overview_repository_impl.dart';
import '../../prize_view/domain/repositories/prize_overview_repository.dart';
import '../../prize_view/domain/usecases/get_prize_overview_usecase.dart';

class PrizeViewInjection {
  static void init() {
    // Data sources
    Get.lazyPut<PrizeOverviewRemoteDataSource>(
      () => PrizeOverviewRemoteDataSourceImpl(apiClient: Get.find<CookApiClient>()),
      tag: 'prize_overview',
    );

    // Repositories
    Get.lazyPut<PrizeOverviewRepository>(
      () => PrizeOverviewRepositoryImpl(
        remoteDataSource: Get.find<PrizeOverviewRemoteDataSource>(
          tag: 'prize_overview',
        ),
      ),
      tag: 'prize_overview',
    );

    // Use cases
    Get.lazyPut<GetPrizeOverviewUseCase>(
      () => GetPrizeOverviewUseCase(
        Get.find<PrizeOverviewRepository>(tag: 'prize_overview'),
      ),
      tag: 'prize_overview',
    );
  }
}

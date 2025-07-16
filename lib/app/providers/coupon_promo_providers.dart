import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../core/network/api_client.dart';
import '../../features/coupons/data/repositories/coupon_repository_impl.dart';
import '../../features/coupons/presentation/providers/coupon_provider.dart';
import '../../features/promos/data/datasources/promos_remote_datasource.dart';
import '../../features/promos/data/repositories/promos_repository_impl.dart';
import '../../features/promos/domain/usecases/add_reward_points_usecase.dart';
import '../../features/promos/domain/usecases/get_promos_usecase.dart';
import '../../features/promos/domain/usecases/launch_url_usecase.dart';
import '../../features/promos/presentation/providers/promos_provider.dart';

/// Coupon and promotion feature providers
class CouponPromoProviders {
  static List<SingleChildWidget> get providers => [
    // ========================================
    // COUPON PROVIDERS
    // ========================================

    // Coupon Provider
    ChangeNotifierProvider<CouponProvider>(
      create: (context) => CouponProvider(
        repository: CouponRepositoryImpl(apiClient: context.read<ApiClient>()),
      ),
    ),

    // ========================================
    // PROMO PROVIDERS
    // ========================================

    // Promos Data Sources
    ProxyProvider<ApiClient, PromosRemoteDataSource>(
      update: (_, apiClient, __) =>
          PromosRemoteDataSourceImpl(client: apiClient),
    ),

    // Promos Repository
    ProxyProvider<PromosRemoteDataSource, PromosRepositoryImpl>(
      update: (_, remoteDataSource, __) =>
          PromosRepositoryImpl(remoteDataSource: remoteDataSource),
    ),

    // Promos Use Cases
    ProxyProvider<PromosRepositoryImpl, GetPromosUseCase>(
      update: (_, repository, __) => GetPromosUseCase(repository),
    ),
    ProxyProvider<PromosRepositoryImpl, AddRewardPointsUseCase>(
      update: (_, repository, __) => AddRewardPointsUseCase(repository),
    ),
    Provider<LaunchUrlUseCase>(create: (_) => LaunchUrlUseCase()),

    // Promos Provider
    ChangeNotifierProxyProvider3<
      GetPromosUseCase,
      AddRewardPointsUseCase,
      LaunchUrlUseCase,
      PromosProvider
    >(
      create: (context) => PromosProvider(
        getPromosUseCase: context.read<GetPromosUseCase>(),
        addRewardPointsUseCase: context.read<AddRewardPointsUseCase>(),
        launchUrlUseCase: context.read<LaunchUrlUseCase>(),
      ),
      update:
          (
            _,
            getPromosUseCase,
            addRewardPointsUseCase,
            launchUrlUseCase,
            previous,
          ) =>
              previous ??
              PromosProvider(
                getPromosUseCase: getPromosUseCase,
                addRewardPointsUseCase: addRewardPointsUseCase,
                launchUrlUseCase: launchUrlUseCase,
              ),
    ),
  ];
}

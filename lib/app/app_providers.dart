// lib/app/app_providers.dart - Updated with NetworkInfo
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../core/network/network_info.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/coupons/data/repositories/coupon_repository_impl.dart';
import '../features/coupons/presentation/providers/coupon_provider.dart';
import '../features/home/data/repositories/home_repository_impl.dart';
import '../features/home/domain/usecases/get_notifications_usecase.dart';
import '../features/home/domain/usecases/get_user_details_usecase.dart';
import '../features/home/presentation/providers/home_provider.dart';
import '../features/promos/data/datasources/promos_remote_datasource.dart';
import '../features/promos/data/repositories/promos_repository_impl.dart';
import '../features/promos/domain/usecases/add_reward_points_usecase.dart';
import '../features/promos/domain/usecases/get_promos_usecase.dart';
import '../features/promos/domain/usecases/launch_url_usecase.dart';
import '../features/promos/presentation/providers/promos_provider.dart';

class AppProviders {
  static List<SingleChildWidget> providers = [
    // Connectivity Provider
    Provider<Connectivity>(create: (_) => Connectivity()),

    // Network Info Provider
    ProxyProvider<Connectivity, NetworkInfo>(
      update: (_, connectivity, __) => NetworkInfoImpl(connectivity),
    ),

    // Core API Client Provider (with NetworkInfo)
    ProxyProvider<NetworkInfo, ApiClient>(
      update: (_, networkInfo, __) =>
          ApiClient(baseUrl: ApiConstants.baseUrl, networkInfo: networkInfo),
      dispose: (_, apiClient) => apiClient.dispose(),
    ),

    // Auth Provider
    ChangeNotifierProvider<AuthProvider>(
      create: (context) {
        return AuthProvider(
          repository: AuthRepositoryImpl(apiClient: context.read<ApiClient>()),
        );
      },
    ),

    // Home Repository Provider
    ProxyProvider<ApiClient, HomeRepositoryImpl>(
      update: (_, apiClient, __) => HomeRepositoryImpl(apiClient: apiClient),
    ),

    // Home Use Cases Providers
    ProxyProvider<HomeRepositoryImpl, GetUserDetailsUseCase>(
      update: (_, repository, __) => GetUserDetailsUseCase(repository),
    ),
    ProxyProvider<HomeRepositoryImpl, GetNotificationsUseCase>(
      update: (_, repository, __) => GetNotificationsUseCase(repository),
    ),

    // Home Provider
    ChangeNotifierProxyProvider2<
      GetUserDetailsUseCase,
      GetNotificationsUseCase,
      HomeProvider
    >(
      create: (context) => HomeProvider(
        getUserDetailsUseCase: context.read<GetUserDetailsUseCase>(),
      ),
      update: (_, getUserDetailsUseCase, getNotificationsUseCase, previous) =>
          previous ??
          HomeProvider(getUserDetailsUseCase: getUserDetailsUseCase),
    ),

    // Coupon Provider
    ChangeNotifierProvider<CouponProvider>(
      create: (context) => CouponProvider(
        repository: CouponRepositoryImpl(apiClient: context.read<ApiClient>()),
      ),
    ),

    // Promos Provider
    ChangeNotifierProvider<PromosProvider>(
      create: (context) {
        final apiClient = context.read<ApiClient>();
        final remoteDataSource = PromosRemoteDataSourceImpl(client: apiClient);
        final repository = PromosRepositoryImpl(
          remoteDataSource: remoteDataSource,
        );
        final getPromosUseCase = GetPromosUseCase(repository);
        final addRewardPointsUseCase = AddRewardPointsUseCase(repository);
        final launchUrlUseCase = LaunchUrlUseCase();
        return PromosProvider(
          getPromosUseCase: getPromosUseCase,
          addRewardPointsUseCase: addRewardPointsUseCase,
          launchUrlUseCase: launchUrlUseCase,
        );
      },
    ),
  ];
}

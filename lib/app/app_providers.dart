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
import '../features/redemption/data/datasources/redemption_local_datasource.dart';
import '../features/redemption/data/datasources/redemption_remote_datasource.dart';
import '../features/redemption/data/repositories/redemption_repository_impl.dart';
import '../features/redemption/domain/usecases/get_user_redemption_details_usecase.dart';
import '../features/redemption/domain/usecases/get_wallet_transactions_usecase.dart';
import '../features/redemption/domain/usecases/initiate_tier_upgrade_usecase.dart';
import '../features/redemption/domain/usecases/initiate_wallet_recharge_usecase.dart';
import '../features/redemption/domain/usecases/verify_payment_usecase.dart';
import '../features/redemption/presentation/providers/redemption_provider.dart';
import '../features/redemption/presentation/providers/wallet_recharge_provider.dart';

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

    // Redemption Data Sources
    ProxyProvider<ApiClient, RedemptionRemoteDataSource>(
      update: (_, apiClient, __) =>
          RedemptionRemoteDataSourceImpl(client: apiClient),
    ),

    Provider<RedemptionLocalDataSource>(
      create: (_) => RedemptionLocalDataSourceImpl(),
    ),

    // Redemption Repository
    ProxyProvider2<
      RedemptionRemoteDataSource,
      RedemptionLocalDataSource,
      RedemptionRepositoryImpl
    >(
      update: (_, remoteDataSource, localDataSource, __) =>
          RedemptionRepositoryImpl(
            remoteDataSource: remoteDataSource,
            localDataSource: localDataSource,
          ),
    ),

    // Redemption Use Cases
    ProxyProvider<RedemptionRepositoryImpl, GetWalletTransactionsUseCase>(
      update: (_, repository, __) => GetWalletTransactionsUseCase(repository),
    ),

    ProxyProvider<RedemptionRepositoryImpl, GetUserRedemptionDetailsUseCase>(
      update: (_, repository, __) =>
          GetUserRedemptionDetailsUseCase(repository),
    ),

    ProxyProvider<RedemptionRepositoryImpl, InitiateWalletRechargeUseCase>(
      update: (_, repository, __) => InitiateWalletRechargeUseCase(repository),
    ),

    ProxyProvider<RedemptionRepositoryImpl, InitiateTierUpgradeUseCase>(
      update: (_, repository, __) => InitiateTierUpgradeUseCase(repository),
    ),

    ProxyProvider<RedemptionRepositoryImpl, VerifyPaymentUseCase>(
      update: (_, repository, __) => VerifyPaymentUseCase(repository),
    ),

    // Redemption Provider
    ChangeNotifierProxyProvider2<
      GetWalletTransactionsUseCase,
      GetUserRedemptionDetailsUseCase,
      RedemptionProvider
    >(
      create: (context) => RedemptionProvider(
        getWalletTransactionsUseCase: context
            .read<GetWalletTransactionsUseCase>(),
        getUserRedemptionDetailsUseCase: context
            .read<GetUserRedemptionDetailsUseCase>(),
      ),
      update:
          (
            _,
            getWalletTransactionsUseCase,
            getUserRedemptionDetailsUseCase,
            previous,
          ) =>
              previous ??
              RedemptionProvider(
                getWalletTransactionsUseCase: getWalletTransactionsUseCase,
                getUserRedemptionDetailsUseCase:
                    getUserRedemptionDetailsUseCase,
              ),
    ),

    // FIXED: Wallet Recharge Provider - Removed resetState from create
    ChangeNotifierProxyProvider3<
      InitiateWalletRechargeUseCase,
      InitiateTierUpgradeUseCase,
      VerifyPaymentUseCase,
      WalletRechargeProvider
    >(
      create: (context) {
        final provider = WalletRechargeProvider(
          initiateWalletRechargeUseCase: context
              .read<InitiateWalletRechargeUseCase>(),
          initiateTierUpgradeUseCase: context
              .read<InitiateTierUpgradeUseCase>(),
          verifyPaymentUseCase: context.read<VerifyPaymentUseCase>(),
        );
        // Initialize Razorpay safely without calling resetState
        provider.initializeRazorpay();
        return provider;
      },
      update:
          (
            _,
            initiateWalletRechargeUseCase,
            initiateTierUpgradeUseCase,
            verifyPaymentUseCase,
            previous,
          ) =>
              previous ??
              WalletRechargeProvider(
                initiateWalletRechargeUseCase: initiateWalletRechargeUseCase,
                initiateTierUpgradeUseCase: initiateTierUpgradeUseCase,
                verifyPaymentUseCase: verifyPaymentUseCase,
              ),
    ),
  ];
}

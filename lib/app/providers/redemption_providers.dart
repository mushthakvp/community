import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../core/network/api_client.dart';
import '../../features/redemption/data/datasources/redemption_local_datasource.dart';
import '../../features/redemption/data/datasources/redemption_remote_datasource.dart';
import '../../features/redemption/data/repositories/redemption_repository_impl.dart';
import '../../features/redemption/domain/usecases/get_user_redemption_details_usecase.dart';
import '../../features/redemption/domain/usecases/get_wallet_transactions_usecase.dart';
import '../../features/redemption/domain/usecases/initiate_tier_upgrade_usecase.dart';
import '../../features/redemption/domain/usecases/initiate_wallet_recharge_usecase.dart';
import '../../features/redemption/domain/usecases/verify_payment_usecase.dart';
import '../../features/redemption/presentation/providers/redemption_provider.dart';
import '../../features/redemption/presentation/providers/wallet_recharge_provider.dart';

/// Redemption and wallet management providers
class RedemptionProviders {
  static List<SingleChildWidget> get providers => [
    // ========================================
    // REDEMPTION PROVIDERS
    // ========================================

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

    // Wallet Recharge Provider
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

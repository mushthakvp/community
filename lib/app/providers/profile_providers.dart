import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../core/network/api_client.dart';
import '../../features/profile/data/datasources/profile_local_datasource.dart';
import '../../features/profile/data/datasources/profile_remote_datasource.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/usecases/change_password_usecase.dart';
import '../../features/profile/domain/usecases/claim_loyalty_points_usecase.dart';
import '../../features/profile/domain/usecases/get_loyalty_card_usecase.dart';
import '../../features/profile/domain/usecases/get_point_transactions_usecase.dart';
import '../../features/profile/domain/usecases/get_profile_usecase.dart';
import '../../features/profile/domain/usecases/update_profile_usecase.dart';
import '../../features/profile/presentation/providers/profile_provider.dart';

class ProfileProviders {
  static List<SingleChildWidget> get providers => [
    // ========================================
    // PROFILE PROVIDERS
    // ========================================

    // Profile Data Sources
    ProxyProvider<ApiClient, ProfileRemoteDataSource>(
      update: (_, apiClient, __) =>
          ProfileRemoteDataSourceImpl(client: apiClient),
    ),
    Provider<ProfileLocalDataSource>(
      create: (_) => ProfileLocalDataSourceImpl(),
    ),

    // Profile Repository
    ProxyProvider2<
      ProfileRemoteDataSource,
      ProfileLocalDataSource,
      ProfileRepositoryImpl
    >(
      update: (_, remoteDataSource, localDataSource, __) =>
          ProfileRepositoryImpl(
            remoteDataSource: remoteDataSource,
            localDataSource: localDataSource,
          ),
    ),

    // Profile Use Cases
    ProxyProvider<ProfileRepositoryImpl, GetProfileUseCase>(
      update: (_, repository, __) => GetProfileUseCase(repository),
    ),
    ProxyProvider<ProfileRepositoryImpl, UpdateProfileUseCase>(
      update: (_, repository, __) => UpdateProfileUseCase(repository),
    ),
    ProxyProvider<ProfileRepositoryImpl, ChangePasswordUseCase>(
      update: (_, repository, __) => ChangePasswordUseCase(repository),
    ),
    ProxyProvider<ProfileRepositoryImpl, GetLoyaltyCardUseCase>(
      update: (_, repository, __) => GetLoyaltyCardUseCase(repository),
    ),
    ProxyProvider<ProfileRepositoryImpl, ClaimLoyaltyPointsUseCase>(
      update: (_, repository, __) => ClaimLoyaltyPointsUseCase(repository),
    ),
    ProxyProvider<ProfileRepositoryImpl, GetPointTransactionsUseCase>(
      update: (_, repository, __) => GetPointTransactionsUseCase(repository),
    ),

    // Profile Provider
    ChangeNotifierProxyProvider6<
      GetProfileUseCase,
      UpdateProfileUseCase,
      ChangePasswordUseCase,
      GetLoyaltyCardUseCase,
      ClaimLoyaltyPointsUseCase,
      GetPointTransactionsUseCase,
      ProfileProvider
    >(
      create: (context) => ProfileProvider(
        getProfileUseCase: context.read<GetProfileUseCase>(),
        updateProfileUseCase: context.read<UpdateProfileUseCase>(),
        changePasswordUseCase: context.read<ChangePasswordUseCase>(),
        getLoyaltyCardUseCase: context.read<GetLoyaltyCardUseCase>(),
        claimLoyaltyPointsUseCase: context.read<ClaimLoyaltyPointsUseCase>(),
        getPointTransactionsUseCase: context
            .read<GetPointTransactionsUseCase>(),
      ),
      update:
          (
            _,
            getProfileUseCase,
            updateProfileUseCase,
            changePasswordUseCase,
            getLoyaltyCardUseCase,
            claimLoyaltyPointsUseCase,
            getPointTransactionsUseCase,
            previous,
          ) =>
              previous ??
              ProfileProvider(
                getProfileUseCase: getProfileUseCase,
                updateProfileUseCase: updateProfileUseCase,
                changePasswordUseCase: changePasswordUseCase,
                getLoyaltyCardUseCase: getLoyaltyCardUseCase,
                claimLoyaltyPointsUseCase: claimLoyaltyPointsUseCase,
                getPointTransactionsUseCase: getPointTransactionsUseCase,
              ),
    ),
  ];
}

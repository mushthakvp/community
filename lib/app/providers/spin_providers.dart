import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/network/api_client.dart';
import '../../core/network/network_info.dart';
import '../../features/spin/data/datasources/spin_local_datasource.dart';
import '../../features/spin/data/datasources/spin_remote_datasource.dart';
import '../../features/spin/data/repositories/spin_repository_impl.dart';
import '../../features/spin/domain/repositories/spin_repository.dart';
import '../../features/spin/domain/usecases/check_can_spin_usecase.dart';
import '../../features/spin/domain/usecases/get_remaining_spins_usecase.dart';
import '../../features/spin/domain/usecases/get_spin_config_usecase.dart';
import '../../features/spin/domain/usecases/get_spin_history_usecase.dart';
import '../../features/spin/domain/usecases/get_spin_options_usecase.dart';
import '../../features/spin/domain/usecases/get_user_loyalty_points_usecase.dart';
import '../../features/spin/domain/usecases/perform_spin_usecase.dart';
import '../../features/spin/presentation/providers/spin_provider.dart';

/// Spin games feature providers
class SpinProviders {
  static List<SingleChildWidget> get providers => [
    // ========================================
    // SPIN FEATURE PROVIDERS
    // ========================================

    // Spin Data Sources
    ProxyProvider<ApiClient, SpinRemoteDataSource>(
      update: (_, apiClient, __) =>
          SpinRemoteDataSourceImpl(apiClient: apiClient),
    ),

    // Spin Local Data Source - handles async SharedPreferences
    ProxyProvider<SharedPreferences?, SpinLocalDataSource>(
      update: (_, sharedPreferences, __) {
        if (sharedPreferences == null) {
          // Return a mock implementation or throw error
          throw Exception('SharedPreferences not initialized yet');
        }
        return SpinLocalDataSourceImpl(sharedPreferences: sharedPreferences);
      },
    ),

    // Spin Repository
    ProxyProvider3<
      SpinRemoteDataSource,
      SpinLocalDataSource,
      NetworkInfo,
      SpinRepository
    >(
      update: (_, remoteDataSource, localDataSource, networkInfo, __) =>
          SpinRepositoryImpl(
            remoteDataSource: remoteDataSource,
            localDataSource: localDataSource,
            networkInfo: networkInfo,
          ),
    ),

    // Spin Use Cases
    ProxyProvider<SpinRepository, GetSpinConfigUseCase>(
      update: (_, repository, __) => GetSpinConfigUseCase(repository),
    ),
    ProxyProvider<SpinRepository, GetSpinOptionsUseCase>(
      update: (_, repository, __) => GetSpinOptionsUseCase(repository),
    ),
    ProxyProvider<SpinRepository, PerformSpinUseCase>(
      update: (_, repository, __) => PerformSpinUseCase(repository),
    ),
    ProxyProvider<SpinRepository, GetSpinHistoryUseCase>(
      update: (_, repository, __) => GetSpinHistoryUseCase(repository),
    ),
    ProxyProvider<SpinRepository, CheckCanSpinUseCase>(
      update: (_, repository, __) => CheckCanSpinUseCase(repository),
    ),
    ProxyProvider<SpinRepository, GetRemainingSpinsUseCase>(
      update: (_, repository, __) => GetRemainingSpinsUseCase(repository),
    ),
    ProxyProvider<SpinRepository, GetUserLoyaltyPointsUseCase>(
      update: (_, repository, __) => GetUserLoyaltyPointsUseCase(repository),
    ),

    // Spin Provider - Create after all dependencies are available
    ChangeNotifierProvider<SpinProvider>(
      create: (context) {
        // Read all required dependencies from context
        final getSpinConfigUseCase = context.read<GetSpinConfigUseCase>();
        final getSpinOptionsUseCase = context.read<GetSpinOptionsUseCase>();
        final performSpinUseCase = context.read<PerformSpinUseCase>();
        final getSpinHistoryUseCase = context.read<GetSpinHistoryUseCase>();
        final checkCanSpinUseCase = context.read<CheckCanSpinUseCase>();
        final getRemainingSpinsUseCase = context
            .read<GetRemainingSpinsUseCase>();
        final getUserLoyaltyPointsUseCase = context
            .read<GetUserLoyaltyPointsUseCase>();

        return SpinProvider(
          getSpinConfigUseCase: getSpinConfigUseCase,
          getSpinOptionsUseCase: getSpinOptionsUseCase,
          performSpinUseCase: performSpinUseCase,
          getSpinHistoryUseCase: getSpinHistoryUseCase,
          checkCanSpinUseCase: checkCanSpinUseCase,
          getRemainingSpinsUseCase: getRemainingSpinsUseCase,
          getUserLoyaltyPointsUseCase: getUserLoyaltyPointsUseCase,
        );
      },
    ),
  ];
}

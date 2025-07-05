import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../features/spin/domain/repositories/spin_repository.dart';
import '../../features/spin/domain/usecases/execute_spin_usecase.dart';
import '../../features/spin/domain/usecases/get_spin_data_usecase.dart';
import '../../features/spin/domain/usecases/get_spin_history_usecase.dart';
import '../../features/spin/presentation/providers/spin_provider.dart';

/// Spin games feature providers
class SpinProviders {
  static List<SingleChildWidget> get providers => [
    // ========================================
    // SPIN FEATURE PROVIDERS
    // ========================================

    // Spin Use Cases
    ProxyProvider<SpinRepository, GetSpinDataUseCase>(
      update: (_, repository, __) => GetSpinDataUseCase(repository),
    ),

    ProxyProvider<SpinRepository, ExecuteSpinUseCase>(
      update: (_, repository, __) => ExecuteSpinUseCase(repository),
    ),

    ProxyProvider<SpinRepository, GetSpinHistoryUseCase>(
      update: (_, repository, __) => GetSpinHistoryUseCase(repository),
    ),

    // Spin Provider - Create after all dependencies are available
    ChangeNotifierProvider<SpinProvider>(
      create: (context) {
        // Read all required dependencies from context
        final getSpinDataUseCase = context.read<GetSpinDataUseCase>();
        final executeSpinUseCase = context.read<ExecuteSpinUseCase>();
        final getSpinHistoryUseCase = context.read<GetSpinHistoryUseCase>();

        return SpinProvider(
          getSpinDataUseCase: getSpinDataUseCase,
          executeSpinUseCase: executeSpinUseCase,
          getSpinHistoryUseCase: getSpinHistoryUseCase,
        );
      },
    ),
  ];
}

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../core/network/api_client.dart';
import '../../features/home/data/repositories/home_repository_impl.dart' as home_impl;
import '../../features/home/domain/usecases/get_notifications_usecase.dart';
import '../../features/home/domain/usecases/get_user_details_usecase.dart';
import '../../features/home/presentation/providers/home_provider.dart';

/// Home page and main app functionality providers
class HomeProviders {
  static List<SingleChildWidget> get providers => [
    // ========================================
    // HOME PROVIDERS
    // ========================================

    // Home Repository (using aliased import to avoid GetX conflicts)
    ProxyProvider<ApiClient, home_impl.HomeRepositoryImpl>(
      update: (_, apiClient, __) => home_impl.HomeRepositoryImpl(apiClient: apiClient),
    ),

    // Home Use Cases
    ProxyProvider<home_impl.HomeRepositoryImpl, GetUserDetailsUseCase>(
      update: (_, repository, __) => GetUserDetailsUseCase(repository),
    ),
    ProxyProvider<home_impl.HomeRepositoryImpl, GetNotificationsUseCase>(
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
  ];
}

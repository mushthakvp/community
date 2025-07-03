import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../../core/network/network_info.dart';
import '../../features/splash/presentation/providers/splash_provider.dart';

/// Core application providers for fundamental app services
class AppCoreProviders {
  static List<SingleChildWidget> get providers => [
    // ========================================
    // CORE INFRASTRUCTURE PROVIDERS
    // ========================================

    // Splash Provider
    ChangeNotifierProvider<SplashProvider>(create: (_) => SplashProvider()),

    // Network Providers
    Provider<Connectivity>(create: (_) => Connectivity()),
    ProxyProvider<Connectivity, NetworkInfo>(
      update: (_, connectivity, __) => NetworkInfoImpl(connectivity),
    ),

    // API Client
    ProxyProvider<NetworkInfo, ApiClient>(
      update: (_, networkInfo, __) =>
          ApiClient(baseUrl: ApiConstants.baseUrl, networkInfo: networkInfo),
    ),

    // SharedPreferences Provider
    FutureProvider<SharedPreferences?>(
      create: (_) => SharedPreferences.getInstance(),
      initialData: null,
    ),
  ];
}

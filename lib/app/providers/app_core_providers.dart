import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/network/api_client.dart';
import '../../core/network/api_client_wrapper.dart';
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

    // API Clients Wrapper
    ProxyProvider<NetworkInfo, ApiClientWrapper>(
      update: (_, networkInfo, __) => ApiClientWrapper(
        mainClient: ApiClient.main(networkInfo: networkInfo),
        chatClient: ApiClient.chat(networkInfo: networkInfo),
      ),
    ),

    // Main API Client for backward compatibility
    ProxyProvider<ApiClientWrapper, ApiClient>(
      update: (_, wrapper, __) => wrapper.mainClient,
    ),

    // SharedPreferences Provider
    Provider<SharedPreferences>(
      create: (_) =>
          throw UnimplementedError('SharedPreferences must be initialized'),
      lazy: false,
    ),
  ];

  /// Initialize SharedPreferences and return updated providers
  static Future<List<SingleChildWidget>> getInitializedProviders() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    return [
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

      // API Clients Wrapper
      ProxyProvider<NetworkInfo, ApiClientWrapper>(
        update: (_, networkInfo, __) => ApiClientWrapper(
          mainClient: ApiClient.main(networkInfo: networkInfo),
          chatClient: ApiClient.chat(networkInfo: networkInfo),
        ),
      ),

      // Main API Client for backward compatibility
      ProxyProvider<ApiClientWrapper, ApiClient>(
        update: (_, wrapper, __) => wrapper.mainClient,
      ),

      // SharedPreferences Provider - Now properly initialized
      Provider<SharedPreferences>(
        create: (_) => sharedPreferences,
        lazy: false,
      ),
    ];
  }
}

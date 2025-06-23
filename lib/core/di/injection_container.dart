// lib/core/di/injection_container.dart

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/coupons/data/datasources/coupon_local_datasource.dart';
import '../../features/coupons/data/datasources/coupon_remote_datasource.dart';
import '../../features/coupons/data/repositories/coupon_repository_impl.dart';
import '../../features/coupons/presentation/providers/coupon_provider.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';
import '../network/network_info.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Coupons
  sl.registerFactory(
    () => CouponProvider(repository: sl(), connectivity: sl()),
  );

  sl.registerLazySingleton<CouponRepositoryImpl>(
    () => CouponRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<CouponRemoteDataSource>(
    () => CouponRemoteDataSourceImpl(apiClient: sl()),
  );

  sl.registerLazySingleton<CouponLocalDataSource>(
    () => CouponLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  sl.registerLazySingleton(
    () => ApiClient(client: sl(), baseUrl: ApiEndpoints.baseUrl),
  );

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Connectivity());
}

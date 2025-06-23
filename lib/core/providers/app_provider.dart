import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../features/coupons/data/datasources/coupon_local_datasource.dart';
import '../../features/coupons/data/datasources/coupon_remote_datasource.dart';
import '../../features/coupons/data/repositories/coupon_repository_impl.dart';
import '../../features/coupons/presentation/providers/coupon_provider.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';
import '../network/network_info.dart';
import '../utils/secure_storage.dart';

final List<SingleChildWidget> providers = [
  ChangeNotifierProvider<CouponProvider>(
    create: (context) {
      // Create all dependencies inline
      final httpClient = http.Client();
      final connectivity = Connectivity();
      final apiClient = ApiClient(
        client: httpClient,
        baseUrl: ApiEndpoints.baseUrl,
      );

      final repository = CouponRepositoryImpl(
        remoteDataSource: CouponRemoteDataSourceImpl(apiClient: apiClient),
        localDataSource: CouponLocalDataSourceImpl(
          sharedPreferences: AppPref.pref,
        ),
        networkInfo: NetworkInfoImpl(connectivity),
      );

      return CouponProvider(repository: repository, connectivity: connectivity);
    },
  ),
];

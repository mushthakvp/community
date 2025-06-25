// lib/app/app_providers.dart
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/coupons/data/repositories/coupon_repository_impl.dart';
import '../features/coupons/presentation/providers/coupon_provider.dart';

class AppProviders {
  static List<SingleChildWidget> providers = [
    // Auth Provider
    ChangeNotifierProvider<AuthProvider>(
      create: (context) {
        return AuthProvider(
          repository: AuthRepositoryImpl(
            apiClient: ApiClient(baseUrl: ApiConstants.baseUrl),
          ),
        );
      },
    ),

    // Coupon Provider
    ChangeNotifierProvider<CouponProvider>(
      create: (context) => CouponProvider(
        repository: CouponRepositoryImpl(
          apiClient: ApiClient(baseUrl: ApiConstants.baseUrl),
        ),
      ),
    ),

    // Add more providers as needed
  ];
}

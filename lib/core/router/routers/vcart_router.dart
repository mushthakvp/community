// lib/core/router/routers/vcart_router.dart
import 'package:go_router/go_router.dart';

import '../../../features/vcart/vcart_app.dart';

class VCartRouter {
  /// Route paths constants
  static const String vcartHomePath = '/v-cart';
  static const String vcartCategoriesPath = '/v-cart/categories';
  static const String vcartCartPath = '/v-cart/cart';
  static const String vcartProfilePath = '/v-cart/profile';
  static const String vcartSearchPath = '/v-cart/search';
  static const String vcartProductDetailPath = '/v-cart/product/:id';
  static const String vcartCategoryPath = '/v-cart/category';
  static const String vcartMarketplacePath = '/v-cart/marketplace';

  /// VCart feature routes
  static List<RouteBase> get routes => [
    // ==================== VCART MAIN ROUTES ====================
    GoRoute(
      path: vcartHomePath,
      name: 'vcart',
      builder: (context, state) => const VCartApp(),
    ),

    // ==================== VCART SUB ROUTES ====================
  ];
}

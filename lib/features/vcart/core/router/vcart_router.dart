import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../categories/presentation/pages/categories_page.dart';
import '../../home/presentation/pages/home_page.dart';
import '../../navigation/presentation/controllers/bottom_nav_controller.dart';
import '../../navigation/presentation/pages/main_navigation_page.dart';
import '../../product_overview/presentation/controllers/product_overview_controller.dart';
import '../../product_overview/presentation/pages/product_overview_page.dart';
import '../../profile/presentation/pages/profile_page.dart';
import '../../search/presentation/pages/search_page.dart';
import '../../wishlist/presentation/pages/wishlist_page.dart';

class VCartRouterG {
  static const String vcartHome = '/vcart';
  static const String vcartHomePath = '/vcart/home';
  static const String vcartCategories = '/vcart/categories';
  static const String vcartCart = '/vcart/cart';
  static const String vcartProfile = '/vcart/profile';
  static const String vcartSearch = '/vcart/search';
  static const String vcartWishlist = '/vcart/wishlist';
  static const String vcartProduct = '/vcart/product';
  static const String vcartCategory = '/vcart/category';

  static List<GetPage> getPages() {
    return [
      GetPage(
        name: vcartHome,
        page: () => const VCartMainNavigationPage(
          pages: [
            VCartHomePage(),
            VCartCategoriesPage(),
            VCartCartPage(),
            VCartProfilePage(),
          ],
        ),
      ),
      GetPage(name: vcartHomePath, page: () => const VCartHomePage()),
      GetPage(name: vcartCategories, page: () => const VCartCategoriesPage()),
      GetPage(name: vcartCart, page: () => const VCartCartPage()),
      GetPage(name: vcartProfile, page: () => const VCartProfilePage()),
      GetPage(name: vcartSearch, page: () => const VCartSearchPage()),
      GetPage(name: vcartWishlist, page: () => const VCartWishlistPage()),
      GetPage(
        name: '$vcartProduct/:id',
        page: () {
          final productId = Get.parameters['id'] ?? '';
          if (!Get.isRegistered<VCartProductOverviewController>()) {
            Get.lazyPut<VCartProductOverviewController>(
              () => Get.find<VCartProductOverviewController>(),
              fenix: true,
            );
          }
          return VCartProductOverviewPage(productId: productId);
        },
        binding: BindingsBuilder(() {
          if (!Get.isRegistered<VCartProductOverviewController>()) {
            Get.lazyPut<VCartProductOverviewController>(
              () => Get.find<VCartProductOverviewController>(),
              fenix: true,
            );
          }
        }),
      ),
      GetPage(name: vcartCategory, page: () => const VCartCategoriesPage()),
    ];
  }

  static void toVCartHome() {
    _resetBottomNavToHome();
    Get.offAllNamed(vcartHome);
  }

  static void toVCartProduct(String productId) {
    Get.toNamed('$vcartProduct/$productId');
  }

  static void toVCartCategory(String categoryId) {
    Get.toNamed(vcartCategory, parameters: {'id': categoryId});
  }

  static void toVCartSearch({String? query}) {
    final params = query != null ? {'q': query} : <String, String>{};
    Get.toNamed(vcartSearch, parameters: params);
  }

  static void toVCartWishlist() {
    Get.toNamed(vcartWishlist);
  }

  static void toVCartProfile() {
    Get.toNamed(vcartProfile);
  }

  static void backToVCartHome() {
    _resetBottomNavToHome();
    Get.offAllNamed(vcartHome);
  }

  static void backInVCart() {
    final currentRoute = Get.currentRoute;
    if (currentRoute.startsWith('/vcart')) {
      if (currentRoute == vcartHome) {
        return;
      } else if (_isVCartSubRoute(currentRoute)) {
        _resetBottomNavToHome();
        Get.offAllNamed(vcartHome);
      } else if (Get.key.currentState?.canPop() ?? false) {
        final canPop = Get.key.currentState?.canPop() ?? false;
        if (canPop) {
          final routeHistory = Get.previousRoute;
          if (routeHistory.startsWith('/vcart')) {
            Get.back();
          } else {
            _resetBottomNavToHome();
            Get.offAllNamed(vcartHome);
          }
        } else {
          _resetBottomNavToHome();
          Get.offAllNamed(vcartHome);
        }
      } else {
        _resetBottomNavToHome();
        Get.offAllNamed(vcartHome);
      }
    } else {
      _resetBottomNavToHome();
      Get.offAllNamed(vcartHome);
    }
  }

  static void _resetBottomNavToHome() {
    try {
      if (Get.isRegistered<VCartBottomNavController>()) {
        final bottomNavController = Get.find<VCartBottomNavController>();
        bottomNavController.setCurrentIndex(0);
      }
    } catch (e) {
      debugPrint('Bottom nav controller not found: $e');
    }
  }

  static bool _isVCartSubRoute(String route) {
    return route == vcartSearch ||
        route == vcartWishlist ||
        route.startsWith(vcartProduct) ||
        route == vcartCategory;
  }

  static bool get isInVCartContext {
    final currentRoute = Get.currentRoute;
    return currentRoute.startsWith('/vcart') ||
        currentRoute.startsWith(vcartProduct) ||
        currentRoute == vcartHome;
  }
}

class VCartCartPage extends StatelessWidget {
  const VCartCartPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('VCart Cart'),
      backgroundColor: const Color(0xFF000000),
      foregroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => VCartRouterG.backInVCart(),
      ),
    ),
    body: const Center(
      child: Text('VCart Cart Page', style: TextStyle(color: Colors.white)),
    ),
    backgroundColor: const Color(0xFF000000),
  );
}

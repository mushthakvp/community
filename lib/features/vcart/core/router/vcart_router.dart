import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../categories/presentation/pages/categories_page.dart';
import '../../home/presentation/pages/home_page.dart';
import '../../navigation/presentation/pages/main_navigation_page.dart';
import '../../product_overview/presentation/controllers/product_overview_controller.dart';
import '../../product_overview/presentation/pages/product_overview_page.dart';
import '../../profile/presentation/pages/profile_page.dart';
import '../../search/presentation/pages/search_page.dart';
import '../../wishlist/presentation/pages/wishlist_page.dart';

class VCartRouter {
  static const String vcartHome = '/vcart';
  static const String vcartHomePath = '/vcart/home';
  static const String vcartCategories = '/vcart/categories';
  static const String vcartCart = '/vcart/cart';
  static const String vcartProfile = '/vcart/profile';
  static const String vcartSearch = '/vcart/search';
  static const String vcartWishlist = '/vcart/wishlist';
  static const String vcartProduct = '/product';
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
          // Ensure controller is available when navigating to product page
          Get.lazyPut<VCartProductOverviewController>(
            () => Get.find<VCartProductOverviewController>(),
            fenix: true,
          );
          return VCartProductOverviewPage(productId: productId);
        },
        binding: BindingsBuilder(() {
          // Initialize product overview controller if not already present
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

  // Navigation methods to ensure proper VCart context
  static void toVCartHome() {
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
    // Navigate back to VCart home, removing all other routes
    Get.offAllNamed(vcartHome);
  }

  static void backInVCart() {
    if (Get.currentRoute.startsWith('/vcart')) {
      if (Get.key.currentState?.canPop() ?? false) {
        Get.back();
      } else {
        Get.offAllNamed(vcartHome);
      }
    } else {
      Get.offAllNamed(vcartHome);
    }
  }

  // Check if current route is within VCart
  static bool get isInVCartContext {
    final currentRoute = Get.currentRoute;
    return currentRoute.startsWith('/vcart') ||
        currentRoute.startsWith('/product') ||
        currentRoute == vcartHome;
  }
}

// Updated placeholder pages for VCart
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
        onPressed: () => VCartRouter.backInVCart(),
      ),
    ),
    body: const Center(
      child: Text('VCart Cart Page', style: TextStyle(color: Colors.white)),
    ),
    backgroundColor: const Color(0xFF000000),
  );
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../categories/presentation/pages/categories_page.dart';
import '../../filter_page/presentation/controllers/filter_page_controller.dart';
import '../../filter_page/presentation/pages/filter_page.dart';
import '../../home/presentation/pages/home_page.dart';
import '../../navigation/presentation/controllers/bottom_nav_controller.dart';
import '../../navigation/presentation/pages/main_navigation_page.dart';
import '../../product_listing/presentation/controllers/product_listing_controller.dart';
import '../../product_listing/presentation/pages/product_listing_page.dart';
import '../../product_overview/presentation/controllers/product_overview_controller.dart';
import '../../product_overview/presentation/pages/product_overview_page.dart';
import '../../profile/presentation/pages/profile_page.dart';
import '../../search/presentation/pages/search_page.dart';
import '../../section_category/presentation/controllers/section_category_controller.dart';
import '../../section_category/presentation/pages/section_category_page.dart';
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
  static const String vcartSectionCategory = '/vcart/section-category';
  static const String vcartProductListing = '/vcart/products';
  static const String vcartFilter = '/vcart/filter';

  static final List<String> _navigationHistory = [vcartHome];
  static bool _isNavigatingWithinVCart = false;

  static final VCartNavigatorObserver _observer = VCartNavigatorObserver();

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
        middlewares: [VCartMiddleware()],
      ),
      GetPage(name: vcartHomePath, page: () => const VCartHomePage()),
      GetPage(name: vcartCategories, page: () => const VCartCategoriesPage()),
      GetPage(name: vcartCart, page: () => const VCartCartPage()),
      GetPage(name: vcartProfile, page: () => const VCartProfilePage()),
      GetPage(
        name: vcartSearch,
        page: () => const VCartSearchPage(),
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 300),
        middlewares: [VCartMiddleware()],
      ),
      GetPage(
        name: vcartWishlist,
        page: () => const VCartWishlistPage(),
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 300),
        middlewares: [VCartMiddleware()],
      ),
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
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 300),
        middlewares: [VCartMiddleware()],
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
      GetPage(
        name: '$vcartSectionCategory/:sectionId',
        page: () {
          final sectionId = Get.parameters['sectionId'] ?? '';
          final title = Get.parameters['title'] ?? 'Categories';
          if (!Get.isRegistered<VCartSectionCategoryController>()) {
            Get.lazyPut<VCartSectionCategoryController>(
              () => Get.find<VCartSectionCategoryController>(),
              fenix: true,
            );
          }
          return VCartSectionCategoryPage(title: title, sectionId: sectionId);
        },
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 300),
        middlewares: [VCartMiddleware()],
        binding: BindingsBuilder(() {
          if (!Get.isRegistered<VCartSectionCategoryController>()) {
            Get.lazyPut<VCartSectionCategoryController>(
              () => Get.find<VCartSectionCategoryController>(),
              fenix: true,
            );
          }
        }),
      ),
      GetPage(
        name: vcartProductListing,
        page: () {
          final title = Get.parameters['title'] ?? 'Products';
          final sectionId = Get.parameters['sectionId'];
          final categoryId = Get.parameters['categoryId'];
          final subCategoryId = Get.parameters['subCategoryId'];
          final brandId = Get.parameters['brandId'];

          if (!Get.isRegistered<VCartProductListingController>()) {
            Get.lazyPut<VCartProductListingController>(
              () => Get.find<VCartProductListingController>(),
              fenix: true,
            );
          }

          return VCartProductListingPage(
            title: title,
            sectionId: sectionId,
            categoryId: categoryId,
            subCategoryId: subCategoryId,
            brandId: brandId,
          );
        },
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 300),
        middlewares: [VCartMiddleware()],
        binding: BindingsBuilder(() {
          if (!Get.isRegistered<VCartProductListingController>()) {
            Get.lazyPut<VCartProductListingController>(
              () => Get.find<VCartProductListingController>(),
              fenix: true,
            );
          }
        }),
      ),
      GetPage(
        name: vcartFilter,
        page: () {
          final sectionId = Get.parameters['sectionId'];
          final brandId = Get.parameters['brandId'];

          if (!Get.isRegistered<VCartFilterPageController>()) {
            Get.lazyPut<VCartFilterPageController>(
              () => Get.find<VCartFilterPageController>(),
              fenix: true,
            );
          }

          return VCartFilterPage(sectionId: sectionId, brandId: brandId);
        },
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 300),
        middlewares: [VCartMiddleware()],
        binding: BindingsBuilder(() {
          if (!Get.isRegistered<VCartFilterPageController>()) {
            Get.lazyPut<VCartFilterPageController>(
              () => Get.find<VCartFilterPageController>(),
              fenix: true,
            );
          }
        }),
      ),
    ];
  }

  static VCartNavigatorObserver get observer => _observer;

  static void toVCartHome() {
    _resetBottomNavToHome();
    _isNavigatingWithinVCart = true;
    _navigationHistory.clear();
    _navigationHistory.add(vcartHome);
    Get.offAllNamed(vcartHome);
  }

  static void toVCartProduct(String productId) {
    _isNavigatingWithinVCart = true;
    final route = '$vcartProduct/$productId';
    _addToHistory(route);
    Get.toNamed(route);
  }

  static void toVCartCategory(String categoryId) {
    _isNavigatingWithinVCart = true;
    _addToHistory(vcartCategory);
    Get.toNamed(vcartCategory, parameters: {'id': categoryId});
  }

  static void toVCartSectionCategory(String sectionId, {String? title}) {
    _isNavigatingWithinVCart = true;
    final route = '$vcartSectionCategory/$sectionId';
    _addToHistory(route);
    Get.toNamed(route, parameters: {'title': title ?? 'Categories'});
  }

  static void toVCartProductListing({
    String? title,
    String? sectionId,
    String? categoryId,
    String? subCategoryId,
    String? brandId,
  }) {
    _isNavigatingWithinVCart = true;
    _addToHistory(vcartProductListing);

    final parameters = <String, String>{};
    if (title != null) parameters['title'] = title;
    if (sectionId != null) parameters['sectionId'] = sectionId;
    if (categoryId != null) parameters['categoryId'] = categoryId;
    if (subCategoryId != null) parameters['subCategoryId'] = subCategoryId;
    if (brandId != null) parameters['brandId'] = brandId;

    Get.toNamed(vcartProductListing, parameters: parameters);
  }

  static void toVCartFilter({String? sectionId, String? brandId}) {
    _isNavigatingWithinVCart = true;
    _addToHistory(vcartFilter);

    final parameters = <String, String>{};
    if (sectionId != null) parameters['sectionId'] = sectionId;
    if (brandId != null) parameters['brandId'] = brandId;

    Get.toNamed(vcartFilter, parameters: parameters);
  }

  static void toVCartSearch({String? query}) {
    _isNavigatingWithinVCart = true;
    final params = query != null ? {'q': query} : <String, String>{};
    _addToHistory(vcartSearch);
    Get.toNamed(vcartSearch, parameters: params);
  }

  static void toVCartWishlist() {
    _isNavigatingWithinVCart = true;
    _addToHistory(vcartWishlist);
    Get.toNamed(vcartWishlist);
  }

  static void toVCartProfile() {
    _isNavigatingWithinVCart = true;
    _addToHistory(vcartProfile);
    Get.toNamed(vcartProfile);
  }

  static void backToVCartHome() {
    _resetBottomNavToHome();
    _isNavigatingWithinVCart = true;
    _navigationHistory.clear();
    _navigationHistory.add(vcartHome);
    Get.offAllNamed(vcartHome);
  }

  static void backInVCart() {
    final currentRoute = Get.currentRoute;
    _isNavigatingWithinVCart = true;
    debugPrint('🔙 backInVCart called');
    debugPrint('Current route: $currentRoute');
    debugPrint('Navigation history: $_navigationHistory');
    debugPrint('Can pop: ${Get.key.currentState?.canPop()}');
    final cleanCurrentRoute = currentRoute.split('?')[0];
    if (cleanCurrentRoute.startsWith('/vcart') || cleanCurrentRoute == '/') {
      if (cleanCurrentRoute == vcartHome) {
        debugPrint('Already at VCart home, staying');
        return;
      } else if (_isVCartSubRoute(cleanCurrentRoute) ||
          cleanCurrentRoute == '/') {
        if (_navigationHistory.length > 1) {
          _navigationHistory.removeLast();
          final previousRoute = _navigationHistory.last;
          debugPrint('Going to previous route: $previousRoute');
          if (previousRoute == vcartHome || _navigationHistory.length == 1) {
            _resetBottomNavToHome();
            Get.offAllNamed(vcartHome);
          } else {
            Get.offAndToNamed(previousRoute);
          }
        } else {
          debugPrint('No history, going to VCart home');
          _resetBottomNavToHome();
          Get.offAllNamed(vcartHome);
        }
      } else {
        if (Get.key.currentState?.canPop() ?? false) {
          if (_navigationHistory.length > 1) {
            _navigationHistory.removeLast();
            Get.back();
          } else {
            Get.back();
          }
        } else {
          debugPrint('Cannot pop, going to VCart home');
          _resetBottomNavToHome();
          Get.offAllNamed(vcartHome);
        }
      }
    } else {
      debugPrint('Not in VCart context, going to VCart home');
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
    final cleanRoute = route.split('?')[0];
    return cleanRoute == vcartSearch ||
        cleanRoute == vcartWishlist ||
        cleanRoute.startsWith(vcartProduct) ||
        cleanRoute == vcartCategory ||
        cleanRoute.startsWith(vcartSectionCategory) ||
        cleanRoute == vcartProductListing ||
        cleanRoute == vcartFilter ||
        cleanRoute == '/' ||
        cleanRoute.isEmpty;
  }

  static void _addToHistory(String route) {
    final cleanRoute = route.split('?')[0];
    if (_navigationHistory.isEmpty || _navigationHistory.last != cleanRoute) {
      _navigationHistory.add(cleanRoute);
      if (_navigationHistory.length > 10) {
        _navigationHistory.removeAt(0);
      }
    }
    debugPrint('📝 Updated navigation history: $_navigationHistory');
  }

  static bool get isInVCartContext {
    final currentRoute = Get.currentRoute.split('?')[0];
    return currentRoute.startsWith('/vcart') ||
        currentRoute.startsWith(vcartProduct) ||
        currentRoute == vcartHome ||
        _isNavigatingWithinVCart;
  }

  static void resetNavigationFlags() {
    _isNavigatingWithinVCart = false;
    _navigationHistory.clear();
    _navigationHistory.add(vcartHome);
  }
}

class VCartMiddleware extends GetMiddleware {
  @override
  @override
  RouteSettings? redirect(String? route) {
    debugPrint('🛣️ VCart Middleware: Navigating to $route');
    return null;
  }

  @override
  @override
  GetPage? onPageCalled(GetPage? page) {
    debugPrint('📄 VCart Middleware: Page called ${page?.name}');
    return super.onPageCalled(page);
  }
}

class VCartNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    final routeName = route.settings.name ?? 'unknown';
    debugPrint('📍 VCart Observer: Pushed route: $routeName');
    if (routeName.startsWith('/vcart')) {
      VCartRouterG._isNavigatingWithinVCart = true;
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    final routeName = route.settings.name ?? 'unknown';
    final previousRouteName = previousRoute?.settings.name ?? 'unknown';
    debugPrint('🔙 VCart Observer: Popped route: $routeName');
    debugPrint('🔙 VCart Observer: Previous route: $previousRouteName');
    if (routeName.startsWith('/vcart')) {
      debugPrint('🔙 VCart Observer: System back detected in VCart');
      if (!previousRouteName.startsWith('/vcart') ||
          previousRouteName == 'unknown') {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          debugPrint('🔙 VCart Observer: Redirecting to VCart home');
          VCartRouterG.backToVCartHome();
        });
      }
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    debugPrint('🗑️ VCart Observer: Removed route: ${route.settings.name}');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    debugPrint(
      '🔄 VCart Observer: Replaced route: ${oldRoute?.settings.name} -> ${newRoute?.settings.name}',
    );
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

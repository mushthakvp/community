// lib/features/vcart/core/bindings/vcart_bindings.dart
import 'package:get/get.dart';

import '../../cart/presentation/controllers/cart_controller.dart';
import '../../categories/presentation/controllers/categories_controller.dart';
import '../../coupons/presentation/controllers/coupons_controller.dart';
import '../../filter_page/presentation/controllers/filter_page_controller.dart';
import '../../home/presentation/controllers/home_controller.dart';
import '../../product_listing/presentation/controllers/product_listing_controller.dart';
import '../../product_overview/presentation/controllers/product_overview_controller.dart';
import '../../profile/presentation/controllers/profile_controller.dart';
import '../../search/presentation/controllers/search_controller.dart';
import '../../section_category/presentation/controllers/section_category_controller.dart';
import '../../wishlist/presentation/controllers/wishlist_controller.dart';
import '../di/vcart_dependency_injection.dart';

/// Base binding with common functionality
abstract class VCartBaseBinding extends Bindings {
  Future<void> ensureVCartInitialized() async {
    if (!VCartDI.isInitialized) {
      await VCartDI.init();
    }
  }

  T ensureController<T>() {
    if (!Get.isRegistered<T>()) {
      throw Exception(
        'Controller $T is not registered. VCart DI may not be properly initialized.',
      );
    }
    return Get.find<T>();
  }
}

/// Binding for VCart Home page
class VCartHomeBinding extends VCartBaseBinding {
  @override
  Future<void> dependencies() async {
    await ensureVCartInitialized();
    ensureController<VCartHomeController>();
  }
}

/// Binding for VCart Cart page
class VCartCartBinding extends VCartBaseBinding {
  @override
  Future<void> dependencies() async {
    try {
      await ensureVCartInitialized();
      ensureController<VCartCartController>();
    } catch (e) {
      if (!Get.isRegistered<VCartCartController>()) {
        await VCartDI.init();
        if (!Get.isRegistered<VCartCartController>()) {
          throw Exception(
            'VCartCartController could not be registered. Please restart the app.',
          );
        }
      }
      rethrow;
    }
  }
}

/// Binding for VCart Categories page
class VCartCategoriesBinding extends VCartBaseBinding {
  @override
  Future<void> dependencies() async {
    await ensureVCartInitialized();
    ensureController<VCartCategoriesController>();
  }
}

/// Binding for VCart Coupons page
class VCartCouponsBinding extends VCartBaseBinding {
  @override
  Future<void> dependencies() async {
    await ensureVCartInitialized();
    ensureController<VCartCouponsController>();
  }
}

/// Binding for VCart Filter page
class VCartFilterBinding extends VCartBaseBinding {
  @override
  Future<void> dependencies() async {
    await ensureVCartInitialized();
    ensureController<VCartFilterPageController>();
  }
}

/// Binding for VCart Product Listing page
class VCartProductListingBinding extends VCartBaseBinding {
  @override
  Future<void> dependencies() async {
    await ensureVCartInitialized();
    ensureController<VCartProductListingController>();
  }
}

/// Binding for VCart Product Overview page
class VCartProductOverviewBinding extends VCartBaseBinding {
  @override
  Future<void> dependencies() async {
    await ensureVCartInitialized();
    ensureController<VCartProductOverviewController>();
  }
}

/// Binding for VCart Profile page
class VCartProfileBinding extends VCartBaseBinding {
  @override
  Future<void> dependencies() async {
    await ensureVCartInitialized();
    ensureController<VCartProfileController>();
  }
}

/// Binding for VCart Search page
class VCartSearchBinding extends VCartBaseBinding {
  @override
  Future<void> dependencies() async {
    await ensureVCartInitialized();
    ensureController<VCartSearchController>();
  }
}

/// Binding for VCart Section Category page
class VCartSectionCategoryBinding extends VCartBaseBinding {
  @override
  Future<void> dependencies() async {
    await ensureVCartInitialized();
    ensureController<VCartSectionCategoryController>();
  }
}

/// Binding for VCart Wishlist page
class VCartWishlistBinding extends VCartBaseBinding {
  @override
  Future<void> dependencies() async {
    await ensureVCartInitialized();
    ensureController<VCartWishlistController>();
  }
}

/// Helper class for managing VCart controller lifecycle
class VCartControllerHelper {
  /// Ensure a specific controller is loaded with error handling
  static T ensureController<T>() {
    if (!Get.isRegistered<T>()) {
      if (!VCartDI.isInitialized) {
        VCartDI.init();
        Future.delayed(const Duration(milliseconds: 100)).then((_) {
          if (!Get.isRegistered<T>()) {
            throw Exception(
              'Controller $T is still not registered after VCart DI initialization. '
              'Make sure VCartDI.init() is called properly.',
            );
          }
        });
      }

      throw Exception(
        'Controller $T is not registered. Make sure VCartDI.init() is called.',
      );
    }
    return Get.find<T>();
  }

  /// Ensure a controller is loaded with async handling
  static Future<T> ensureControllerAsync<T>() async {
    if (!Get.isRegistered<T>()) {
      if (!VCartDI.isInitialized) {
        await VCartDI.init();
      }

      // Wait a bit more for controller registration
      await Future.delayed(const Duration(milliseconds: 100));

      if (!Get.isRegistered<T>()) {
        throw Exception(
          'Controller $T could not be registered. Please restart the app.',
        );
      }
    }
    return Get.find<T>();
  }

  /// Pre-load a controller (useful for performance optimization)
  static void preloadController<T>() {
    if (Get.isRegistered<T>()) {
      Get.find<T>();
    }
  }

  /// Reset and reload a controller
  static void resetController<T>() {
    if (Get.isRegistered<T>()) {
      Get.delete<T>();
      // The controller will be recreated when accessed next time due to lazy loading
    }
  }

  /// Check if controller is currently instantiated
  static bool isControllerInstantiated<T>() {
    try {
      return Get.isRegistered<T>() && Get.find<T>(tag: null) != null;
    } catch (e) {
      return false;
    }
  }

  /// Pre-load all VCart controllers for better performance
  static void preloadAllControllers() {
    final controllers = [
      VCartHomeController,
      VCartCartController,
      VCartCategoriesController,
      VCartCouponsController,
      VCartFilterPageController,
      VCartProductListingController,
      VCartProductOverviewController,
      VCartProfileController,
      VCartSearchController,
      VCartSectionCategoryController,
      VCartWishlistController,
    ];

    for (final controllerType in controllers) {
      if (Get.isRegistered(tag: controllerType.toString())) {
        Get.find(tag: controllerType.toString());
      }
    }
  }

  /// Check if all controllers are registered
  static bool areAllControllersRegistered() {
    final registrationChecks = [
      Get.isRegistered<VCartHomeController>(),
      Get.isRegistered<VCartCartController>(),
      Get.isRegistered<VCartCategoriesController>(),
      Get.isRegistered<VCartCouponsController>(),
      Get.isRegistered<VCartFilterPageController>(),
      Get.isRegistered<VCartProductListingController>(),
      Get.isRegistered<VCartProductOverviewController>(),
      Get.isRegistered<VCartProfileController>(),
      Get.isRegistered<VCartSearchController>(),
      Get.isRegistered<VCartSectionCategoryController>(),
      Get.isRegistered<VCartWishlistController>(),
    ];

    return registrationChecks.every((isRegistered) => isRegistered);
  }

  /// Get registration status of all controllers
  static Map<String, bool> getControllerStatus() {
    return {
      'VCartHomeController': Get.isRegistered<VCartHomeController>(),
      'VCartCartController': Get.isRegistered<VCartCartController>(),
      'VCartCategoriesController':
          Get.isRegistered<VCartCategoriesController>(),
      'VCartCouponsController': Get.isRegistered<VCartCouponsController>(),
      'VCartFilterPageController':
          Get.isRegistered<VCartFilterPageController>(),
      'VCartProductListingController':
          Get.isRegistered<VCartProductListingController>(),
      'VCartProductOverviewController':
          Get.isRegistered<VCartProductOverviewController>(),
      'VCartProfileController': Get.isRegistered<VCartProfileController>(),
      'VCartSearchController': Get.isRegistered<VCartSearchController>(),
      'VCartSectionCategoryController':
          Get.isRegistered<VCartSectionCategoryController>(),
      'VCartWishlistController': Get.isRegistered<VCartWishlistController>(),
    };
  }

  /// Initialize missing controllers
  static Future<void> initializeMissingControllers() async {
    final status = getControllerStatus();
    final missingControllers = status.entries
        .where((entry) => !entry.value)
        .map((entry) => entry.key)
        .toList();

    if (missingControllers.isNotEmpty) {
      await VCartDI.init();
    }
  }
}

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

/// Binding for VCart Home page
class VCartHomeBinding extends Bindings {
  @override
  void dependencies() {
    // The controller is already lazy-loaded in DI, this ensures it's available
    Get.find<VCartHomeController>();
  }
}

/// Binding for VCart Cart page
class VCartCartBinding extends Bindings {
  @override
  void dependencies() {
    // The controller is already lazy-loaded in DI, this ensures it's available
    Get.find<VCartCartController>();
  }
}

/// Binding for VCart Categories page
class VCartCategoriesBinding extends Bindings {
  @override
  void dependencies() {
    // The controller is already lazy-loaded in DI, this ensures it's available
    Get.find<VCartCategoriesController>();
  }
}

/// Binding for VCart Coupons page
class VCartCouponsBinding extends Bindings {
  @override
  void dependencies() {
    // The controller is already lazy-loaded in DI, this ensures it's available
    Get.find<VCartCouponsController>();
  }
}

/// Binding for VCart Filter page
class VCartFilterBinding extends Bindings {
  @override
  void dependencies() {
    // The controller is already lazy-loaded in DI, this ensures it's available
    Get.find<VCartFilterPageController>();
  }
}

/// Binding for VCart Product Listing page
class VCartProductListingBinding extends Bindings {
  @override
  void dependencies() {
    // The controller is already lazy-loaded in DI, this ensures it's available
    Get.find<VCartProductListingController>();
  }
}

/// Binding for VCart Product Overview page
class VCartProductOverviewBinding extends Bindings {
  @override
  void dependencies() {
    // The controller is already lazy-loaded in DI, this ensures it's available
    Get.find<VCartProductOverviewController>();
  }
}

/// Binding for VCart Profile page
class VCartProfileBinding extends Bindings {
  @override
  void dependencies() {
    // The controller is already lazy-loaded in DI, this ensures it's available
    Get.find<VCartProfileController>();
  }
}

/// Binding for VCart Search page
class VCartSearchBinding extends Bindings {
  @override
  void dependencies() {
    // The controller is already lazy-loaded in DI, this ensures it's available
    Get.find<VCartSearchController>();
  }
}

/// Binding for VCart Section Category page
class VCartSectionCategoryBinding extends Bindings {
  @override
  void dependencies() {
    // The controller is already lazy-loaded in DI, this ensures it's available
    Get.find<VCartSectionCategoryController>();
  }
}

/// Binding for VCart Wishlist page
class VCartWishlistBinding extends Bindings {
  @override
  void dependencies() {
    // The controller is already lazy-loaded in DI, this ensures it's available
    Get.find<VCartWishlistController>();
  }
}

/// Helper class for managing VCart controller lifecycle
class VCartControllerHelper {
  /// Ensure a specific controller is loaded
  static T ensureController<T>() {
    if (!Get.isRegistered<T>()) {
      throw Exception(
        'Controller $T is not registered. Make sure VCartDI.init() is called.',
      );
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
    return Get.isRegistered<T>() && Get.find<T>(tag: null) != null;
  }

  /// Pre-load all VCart controllers for better performance
  static void preloadAllControllers() {
    preloadController<VCartHomeController>();
    preloadController<VCartCartController>();
    preloadController<VCartCategoriesController>();
    preloadController<VCartCouponsController>();
    preloadController<VCartFilterPageController>();
    preloadController<VCartProductListingController>();
    preloadController<VCartProductOverviewController>();
    preloadController<VCartProfileController>();
    preloadController<VCartSearchController>();
    preloadController<VCartSectionCategoryController>();
    preloadController<VCartWishlistController>();
  }

  /// Check if all controllers are registered
  static bool areAllControllersRegistered() {
    return Get.isRegistered<VCartHomeController>() &&
        Get.isRegistered<VCartCartController>() &&
        Get.isRegistered<VCartCategoriesController>() &&
        Get.isRegistered<VCartCouponsController>() &&
        Get.isRegistered<VCartFilterPageController>() &&
        Get.isRegistered<VCartProductListingController>() &&
        Get.isRegistered<VCartProductOverviewController>() &&
        Get.isRegistered<VCartProfileController>() &&
        Get.isRegistered<VCartSearchController>() &&
        Get.isRegistered<VCartSectionCategoryController>() &&
        Get.isRegistered<VCartWishlistController>();
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
}

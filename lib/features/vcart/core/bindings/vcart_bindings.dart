// lib/features/vcart/core/bindings/vcart_bindings.dart
import 'package:get/get.dart';

import '../../filter_page/presentation/controllers/filter_page_controller.dart';
import '../../home/presentation/controllers/home_controller.dart';
import '../../product_listing/presentation/controllers/product_listing_controller.dart';
import '../../search/presentation/controllers/search_controller.dart';

/// Binding for VCart Home page
class VCartHomeBinding extends Bindings {
  @override
  void dependencies() {
    // The controller is already lazy-loaded in DI, this ensures it's available
    Get.find<VCartHomeController>();
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

/// Binding for VCart Search page
class VCartSearchBinding extends Bindings {
  @override
  void dependencies() {
    // The controller is already lazy-loaded in DI, this ensures it's available
    Get.find<VCartSearchController>();
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
}

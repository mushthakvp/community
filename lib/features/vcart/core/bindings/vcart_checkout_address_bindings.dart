import 'package:get/get.dart';

import '../../address/presentation/controllers/address_controller.dart';
import '../../checkout/presentation/controllers/checkout_controller.dart';
import '../di/vcart_checkout_address_di.dart';

/// Base binding for checkout and address features
abstract class VCartCheckoutAddressBaseBinding extends Bindings {
  Future<void> ensureInitialized() async {
    if (!VCartCheckoutAddressDI.isInitialized) {
      await VCartCheckoutAddressDI.init();
    }
  }

  T ensureController<T>() {
    if (!Get.isRegistered<T>()) {
      throw Exception(
        'Controller $T is not registered. VCart Checkout Address DI may not be properly initialized.',
      );
    }
    return Get.find<T>();
  }
}

/// Binding for Checkout page
class VCartCheckoutBinding extends VCartCheckoutAddressBaseBinding {
  @override
  Future<void> dependencies() async {
    await ensureInitialized();
    ensureController<VCartCheckoutController>();
  }
}

/// Binding for Address List page
class VCartAddressListBinding extends VCartCheckoutAddressBaseBinding {
  @override
  Future<void> dependencies() async {
    await ensureInitialized();
    ensureController<VCartAddressController>();
  }
}

/// Binding for Address Form page (Add/Edit)
class VCartAddressFormBinding extends VCartCheckoutAddressBaseBinding {
  @override
  Future<void> dependencies() async {
    await ensureInitialized();
    ensureController<VCartAddressController>();
  }
}

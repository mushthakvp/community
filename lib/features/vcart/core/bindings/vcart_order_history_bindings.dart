import 'package:get/get.dart';

import '../../order_history/presentation/controllers/order_history_controller.dart';
import '../../order_history_details/presentation/controllers/order_details_controller.dart';
import '../di/vcart_order_history_di.dart';

abstract class VCartOrderHistoryBaseBinding extends Bindings {
  Future<void> ensureInitialized() async {
    if (!VCartOrderHistoryDI.isInitialized) {
      await VCartOrderHistoryDI.init();
    }
  }

  T ensureController<T>() {
    if (!Get.isRegistered<T>()) {
      throw Exception(
        'Controller $T is not registered. VCart Order History DI may not be properly initialized.',
      );
    }
    return Get.find<T>();
  }
}

class VCartOrderHistoryBinding extends VCartOrderHistoryBaseBinding {
  @override
  Future<void> dependencies() async {
    await ensureInitialized();
    ensureController<VCartOrderHistoryController>();
  }
}

class VCartOrderDetailsBinding extends VCartOrderHistoryBaseBinding {
  @override
  Future<void> dependencies() async {
    await ensureInitialized();
    ensureController<VCartOrderDetailsController>();
  }
}

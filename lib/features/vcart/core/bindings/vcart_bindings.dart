import 'package:get/get.dart';

import '../di/vcart_injection.dart';

class VCartBindings extends Bindings {
  @override
  void dependencies() {
    VCartInjection.init();
  }
}

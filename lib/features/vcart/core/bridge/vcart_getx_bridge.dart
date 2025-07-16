import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/network_info.dart';
import '../../home/presentation/controllers/home_controller.dart';
import '../../navigation/presentation/controllers/bottom_nav_controller.dart';
import '../di/vcart_injection.dart';

class VCartGetXBridge {
  static void initializeVCartDependencies(BuildContext context) {
    final apiClient = Provider.of<ApiClient>(context, listen: false);
    final networkInfo = Provider.of<NetworkInfo>(context, listen: false);
    _initializeGetXDependencies(apiClient, networkInfo);
  }

  static void _initializeGetXDependencies(
    ApiClient apiClient,
    NetworkInfo networkInfo,
  ) {
    Get.put<ApiClient>(apiClient, permanent: true);
    Get.put<NetworkInfo>(networkInfo, permanent: true);
    VCartInjection.init();
  }

  static void disposeVCartDependencies() {
    VCartInjection.dispose();
    if (Get.isRegistered<ApiClient>()) {
      Get.delete<ApiClient>();
    }
    if (Get.isRegistered<NetworkInfo>()) {
      Get.delete<NetworkInfo>();
    }
  }

  static bool get isInitialized {
    return Get.isRegistered<VCartHomeController>() &&
        Get.isRegistered<VCartBottomNavController>();
  }

  static VCartHomeController get homeController {
    return Get.find<VCartHomeController>();
  }

  static VCartBottomNavController get bottomNavController {
    return Get.find<VCartBottomNavController>();
  }
}

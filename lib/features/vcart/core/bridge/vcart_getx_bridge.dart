import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/network_info.dart';
import '../../home/presentation/controllers/home_controller.dart';
import '../../navigation/presentation/controllers/bottom_nav_controller.dart';
import '../di/vcart_injection.dart';

class VCartGetXBridge {
  static bool _isInitialized = false;

  static void initializeVCartDependencies(BuildContext context) {
    if (_isInitialized) return;

    try {
      final apiClient = Provider.of<ApiClient>(context, listen: false);
      final networkInfo = Provider.of<NetworkInfo>(context, listen: false);
      _initializeGetXDependencies(apiClient, networkInfo);
      _isInitialized = true;
    } catch (e) {
      debugPrint('Failed to initialize VCart dependencies: $e');
      // Try to initialize with GetX registered dependencies as fallback
      if (Get.isRegistered<ApiClient>() && Get.isRegistered<NetworkInfo>()) {
        VCartInjection.init();
        _isInitialized = true;
      }
    }
  }

  static void _initializeGetXDependencies(
    ApiClient apiClient,
    NetworkInfo networkInfo,
  ) {
    // Only put if not already registered
    if (!Get.isRegistered<ApiClient>()) {
      Get.put<ApiClient>(apiClient, permanent: true);
    }
    if (!Get.isRegistered<NetworkInfo>()) {
      Get.put<NetworkInfo>(networkInfo, permanent: true);
    }

    VCartInjection.init();
  }

  static void disposeVCartDependencies() {
    if (!_isInitialized) return;

    try {
      VCartInjection.dispose();

      // Only delete if we put them
      if (Get.isRegistered<ApiClient>()) {
        Get.delete<ApiClient>();
      }
      if (Get.isRegistered<NetworkInfo>()) {
        Get.delete<NetworkInfo>();
      }

      _isInitialized = false;
    } catch (e) {
      debugPrint('Error disposing VCart dependencies: $e');
    }
  }

  static bool get isInitialized {
    return _isInitialized &&
        Get.isRegistered<VCartHomeController>() &&
        Get.isRegistered<VCartBottomNavController>();
  }

  static VCartHomeController? get homeController {
    try {
      return Get.find<VCartHomeController>();
    } catch (e) {
      debugPrint('HomeController not found: $e');
      return null;
    }
  }

  static VCartBottomNavController? get bottomNavController {
    try {
      return Get.find<VCartBottomNavController>();
    } catch (e) {
      debugPrint('BottomNavController not found: $e');
      return null;
    }
  }
}

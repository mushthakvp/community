import '../di/vcart_checkout_address_di.dart';
import '../di/vcart_dependency_injection.dart';

/// Extension to VCartDI for checkout and address features
extension VCartDIExtension on VCartDI {
  /// Initialize checkout and address features
  static Future<void> initCheckoutAndAddress() async {
    // Ensure main VCart DI is initialized first
    if (!VCartDI.isInitialized) {
      await VCartDI.init();
    }

    // Initialize checkout and address specific dependencies
    await VCartCheckoutAddressDI.init();
  }

  /// Check if checkout and address features are ready
  static bool get isCheckoutAddressReady {
    return VCartDI.isInitialized && VCartCheckoutAddressDI.isInitialized;
  }

  /// Get comprehensive initialization status
  static Map<String, dynamic> getComprehensiveStatus() {
    return {
      'mainVCartDI': VCartDI.getInitializationStatus(),
      'checkoutAddressDI': VCartCheckoutAddressDI.getDependencyStatus(),
      'isCheckoutAddressReady': isCheckoutAddressReady,
    };
  }
}

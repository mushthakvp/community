import 'package:get/get.dart';

import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/network_info.dart';
import '../../address/data/datasources/address_local_datasource.dart';
// Address imports
import '../../address/data/datasources/address_remote_datasource.dart';
import '../../address/data/repositories/address_repository_impl.dart';
import '../../address/domain/repositories/address_repository.dart';
import '../../address/domain/usecases/manage_addresses.dart';
import '../../address/presentation/controllers/address_controller.dart';
// Checkout imports
import '../../checkout/data/datasources/checkout_remote_datasource.dart';
import '../../checkout/data/repositories/checkout_repository_impl.dart';
import '../../checkout/domain/repositories/checkout_repository.dart';
import '../../checkout/domain/usecases/get_checkout_data.dart';
import '../../checkout/domain/usecases/initiate_payment.dart';
import '../../checkout/presentation/controllers/checkout_controller.dart';

/// Dependency injection for Checkout and Address features
class VCartCheckoutAddressDI {
  static bool _isInitialized = false;

  static bool get isInitialized => _isInitialized;

  static Future<void> init() async {
    if (_isInitialized) return;

    try {
      // Initialize data sources
      await _initDataSources();

      // Initialize repositories
      await _initRepositories();

      // Initialize use cases
      await _initUseCases();

      // Initialize controllers
      await _initControllers();

      _isInitialized = true;
    } catch (e) {
      throw Exception('Failed to initialize VCart Checkout Address DI: $e');
    }
  }

  static Future<void> _initDataSources() async {
    // Checkout Data Sources
    Get.lazyPut<CheckoutRemoteDataSource>(
      () => CheckoutRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );

    // Address Data Sources
    Get.lazyPut<AddressRemoteDataSource>(
      () => AddressRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );

    Get.lazyPut<AddressLocalDataSource>(
      () => AddressLocalDataSourceImpl(),
      fenix: true,
    );
  }

  static Future<void> _initRepositories() async {
    // Checkout Repository
    Get.lazyPut<CheckoutRepository>(
      () => CheckoutRepositoryImpl(
        remoteDataSource: Get.find<CheckoutRemoteDataSource>(),
        networkInfo: Get.find<NetworkInfo>(),
      ),
      fenix: true,
    );

    // Address Repository
    Get.lazyPut<AddressRepository>(
      () => AddressRepositoryImpl(
        remoteDataSource: Get.find<AddressRemoteDataSource>(),
        localDataSource: Get.find<AddressLocalDataSource>(),
        networkInfo: Get.find<NetworkInfo>(),
      ),
      fenix: true,
    );
  }

  static Future<void> _initUseCases() async {
    // Checkout Use Cases
    Get.lazyPut<GetCheckoutData>(
      () => GetCheckoutData(Get.find<CheckoutRepository>()),
      fenix: true,
    );

    Get.lazyPut<InitiateRazorpayPayment>(
      () => InitiateRazorpayPayment(Get.find<CheckoutRepository>()),
      fenix: true,
    );

    Get.lazyPut<InitiateWalletPayment>(
      () => InitiateWalletPayment(Get.find<CheckoutRepository>()),
      fenix: true,
    );

    Get.lazyPut<VerifyRazorpayPayment>(
      () => VerifyRazorpayPayment(Get.find<CheckoutRepository>()),
      fenix: true,
    );

    Get.lazyPut<GetWalletBalance>(
      () => GetWalletBalance(Get.find<CheckoutRepository>()),
      fenix: true,
    );

    // Address Use Cases
    Get.lazyPut<GetAddresses>(
      () => GetAddresses(Get.find<AddressRepository>()),
      fenix: true,
    );

    Get.lazyPut<AddAddress>(
      () => AddAddress(Get.find<AddressRepository>()),
      fenix: true,
    );

    Get.lazyPut<UpdateAddress>(
      () => UpdateAddress(Get.find<AddressRepository>()),
      fenix: true,
    );

    Get.lazyPut<DeleteAddress>(
      () => DeleteAddress(Get.find<AddressRepository>()),
      fenix: true,
    );

    Get.lazyPut<GetCachedSelectedAddress>(
      () => GetCachedSelectedAddress(Get.find<AddressRepository>()),
      fenix: true,
    );

    Get.lazyPut<CacheSelectedAddress>(
      () => CacheSelectedAddress(Get.find<AddressRepository>()),
      fenix: true,
    );
  }

  static Future<void> _initControllers() async {
    // Checkout Controller
    Get.lazyPut<VCartCheckoutController>(
      () => VCartCheckoutController(
        getCheckoutDataUseCase: Get.find<GetCheckoutData>(),
        initiateRazorpayPaymentUseCase: Get.find<InitiateRazorpayPayment>(),
        initiateWalletPaymentUseCase: Get.find<InitiateWalletPayment>(),
        verifyRazorpayPaymentUseCase: Get.find<VerifyRazorpayPayment>(),
        getWalletBalanceUseCase: Get.find<GetWalletBalance>(),
      ),
      fenix: true,
    );

    // Address Controller
    Get.lazyPut<VCartAddressController>(
      () => VCartAddressController(
        getAddressesUseCase: Get.find<GetAddresses>(),
        addAddressUseCase: Get.find<AddAddress>(),
        updateAddressUseCase: Get.find<UpdateAddress>(),
        deleteAddressUseCase: Get.find<DeleteAddress>(),
        getCachedSelectedAddressUseCase: Get.find<GetCachedSelectedAddress>(),
        cacheSelectedAddressUseCase: Get.find<CacheSelectedAddress>(),
      ),
      fenix: true,
    );
  }

  /// Reset all dependencies (use with caution)
  static void reset() {
    _isInitialized = false;
  }

  /// Check if all dependencies are registered
  static bool areAllDependenciesRegistered() {
    final dependencies = [
      // Data Sources
      CheckoutRemoteDataSource,
      AddressRemoteDataSource,
      AddressLocalDataSource,

      // Repositories
      CheckoutRepository,
      AddressRepository,

      // Use Cases
      GetCheckoutData,
      InitiateRazorpayPayment,
      InitiateWalletPayment,
      VerifyRazorpayPayment,
      GetWalletBalance,
      GetAddresses,
      AddAddress,
      UpdateAddress,
      DeleteAddress,
      GetCachedSelectedAddress,
      CacheSelectedAddress,

      // Controllers
      VCartCheckoutController,
      VCartAddressController,
    ];

    return dependencies.every((type) => Get.isRegistered(tag: type.toString()));
  }

  /// Get registration status of all dependencies
  static Map<String, bool> getDependencyStatus() {
    return {
      // Data Sources
      'CheckoutRemoteDataSource': Get.isRegistered<CheckoutRemoteDataSource>(),
      'AddressRemoteDataSource': Get.isRegistered<AddressRemoteDataSource>(),
      'AddressLocalDataSource': Get.isRegistered<AddressLocalDataSource>(),

      // Repositories
      'CheckoutRepository': Get.isRegistered<CheckoutRepository>(),
      'AddressRepository': Get.isRegistered<AddressRepository>(),

      // Use Cases
      'GetCheckoutData': Get.isRegistered<GetCheckoutData>(),
      'InitiateRazorpayPayment': Get.isRegistered<InitiateRazorpayPayment>(),
      'InitiateWalletPayment': Get.isRegistered<InitiateWalletPayment>(),
      'VerifyRazorpayPayment': Get.isRegistered<VerifyRazorpayPayment>(),
      'GetWalletBalance': Get.isRegistered<GetWalletBalance>(),
      'GetAddresses': Get.isRegistered<GetAddresses>(),
      'AddAddress': Get.isRegistered<AddAddress>(),
      'UpdateAddress': Get.isRegistered<UpdateAddress>(),
      'DeleteAddress': Get.isRegistered<DeleteAddress>(),
      'GetCachedSelectedAddress': Get.isRegistered<GetCachedSelectedAddress>(),
      'CacheSelectedAddress': Get.isRegistered<CacheSelectedAddress>(),

      // Controllers
      'VCartCheckoutController': Get.isRegistered<VCartCheckoutController>(),
      'VCartAddressController': Get.isRegistered<VCartAddressController>(),
    };
  }
}

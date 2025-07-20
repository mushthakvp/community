import 'package:get/get.dart';

import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/network_info.dart';
import '../../filter_page/data/datasources/filter_page_remote_datasource.dart';
import '../../filter_page/data/repositories/filter_page_repository_impl.dart';
import '../../filter_page/domain/repositories/filter_page_repository.dart';
import '../../filter_page/domain/usecases/get_filter_data.dart';
import '../../filter_page/presentation/controllers/filter_page_controller.dart';
import '../../home/data/datasources/home_local_datasource.dart';
import '../../home/data/datasources/home_remote_datasource.dart';
import '../../home/data/repositories/home_repository_impl.dart';
import '../../home/domain/repositories/home_repository.dart';
import '../../home/domain/usecases/get_home_data.dart';
import '../../home/domain/usecases/get_location.dart';
import '../../home/presentation/controllers/home_controller.dart';
import '../../navigation/data/repositories/navigation_repository_impl.dart';
import '../../navigation/domain/repositories/navigation_repository.dart';
import '../../navigation/presentation/controllers/bottom_nav_controller.dart';
import '../../product_listing/data/datasources/product_listing_remote_datasource.dart';
import '../../product_listing/data/repositories/product_listing_repository_impl.dart';
import '../../product_listing/domain/repositories/product_listing_repository.dart';
import '../../product_listing/domain/usecases/get_filtered_product_count.dart';
import '../../product_listing/domain/usecases/get_products.dart';
import '../../product_listing/presentation/controllers/product_listing_controller.dart';
import '../../search/data/datasources/search_local_datasource.dart';
import '../../search/data/datasources/search_remote_datasource.dart';
import '../../search/data/repositories/search_repository_impl.dart';
import '../../search/domain/repositories/search_repository.dart';
import '../../search/domain/usecases/get_search_data.dart';
import '../../search/domain/usecases/search_products.dart';
import '../../search/presentation/controllers/search_controller.dart';

class VCartDI {
  static bool _isInitialized = false;
  static bool _isInitializing = false;

  static bool get isInitialized => _isInitialized;
  static bool get isInitializing => _isInitializing;

  static Future<void> init() async {
    if (_isInitialized || _isInitializing) {
      return;
    }

    _isInitializing = true;

    try {
      await _initDataSources();
      await _initRepositories();
      await _initUseCases();
      await _initControllers();
      _isInitialized = true;
    } catch (e) {
      rethrow;
    } finally {
      _isInitializing = false;
    }
  }

  static Future<void> _initDataSources() async {
    // Filter Page DataSources
    Get.lazyPut<FilterPageRemoteDataSource>(
      () => FilterPageRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );

    // Home DataSources
    Get.lazyPut<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );

    Get.lazyPut<HomeLocalDataSource>(
      () => HomeLocalDataSourceImpl(),
      fenix: true,
    );

    // Product Listing DataSources
    Get.lazyPut<ProductListingRemoteDataSource>(
      () =>
          ProductListingRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );

    // Search DataSources
    Get.lazyPut<SearchRemoteDataSource>(
      () => SearchRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );

    Get.lazyPut<SearchLocalDataSource>(
      () => SearchLocalDataSourceImpl(),
      fenix: true,
    );
  }

  static Future<void> _initRepositories() async {
    // Navigation Repository - Initialize first as it's critical
    Get.lazyPut<NavigationRepository>(
      () => NavigationRepositoryImpl(),
      fenix: true,
    );

    // Filter Page Repository
    Get.lazyPut<FilterPageRepository>(
      () => FilterPageRepositoryImpl(
        remoteDataSource: Get.find<FilterPageRemoteDataSource>(),
        networkInfo: Get.find<NetworkInfo>(),
      ),
      fenix: true,
    );

    // Home Repository
    Get.lazyPut<HomeRepository>(
      () => HomeRepositoryImpl(
        remoteDataSource: Get.find<HomeRemoteDataSource>(),
        localDataSource: Get.find<HomeLocalDataSource>(),
        networkInfo: Get.find<NetworkInfo>(),
      ),
      fenix: true,
    );

    // Product Listing Repository
    Get.lazyPut<ProductListingRepository>(
      () => ProductListingRepositoryImpl(
        remoteDataSource: Get.find<ProductListingRemoteDataSource>(),
        networkInfo: Get.find<NetworkInfo>(),
      ),
      fenix: true,
    );

    // Search Repository
    Get.lazyPut<SearchRepository>(
      () => SearchRepositoryImpl(
        remoteDataSource: Get.find<SearchRemoteDataSource>(),
        localDataSource: Get.find<SearchLocalDataSource>(),
        networkInfo: Get.find<NetworkInfo>(),
      ),
      fenix: true,
    );
  }

  static Future<void> _initUseCases() async {
    // Filter Page Use Cases
    Get.lazyPut<GetFilterData>(
      () => GetFilterData(Get.find<FilterPageRepository>()),
      fenix: true,
    );

    // Home Use Cases
    Get.lazyPut<GetHomeData>(
      () => GetHomeData(Get.find<HomeRepository>()),
      fenix: true,
    );

    Get.lazyPut<GetLocation>(
      () => GetLocation(Get.find<HomeRepository>()),
      fenix: true,
    );

    // Product Listing Use Cases
    Get.lazyPut<GetProducts>(
      () => GetProducts(Get.find<ProductListingRepository>()),
      fenix: true,
    );

    Get.lazyPut<GetFilteredProductCount>(
      () => GetFilteredProductCount(Get.find<ProductListingRepository>()),
      fenix: true,
    );

    // Search Use Cases
    Get.lazyPut<GetSearchData>(
      () => GetSearchData(Get.find<SearchRepository>()),
      fenix: true,
    );

    Get.lazyPut<SearchProducts>(
      () => SearchProducts(Get.find<SearchRepository>()),
      fenix: true,
    );
  }

  static Future<void> _initControllers() async {
    if (!Get.isRegistered<VCartBottomNavController>()) {
      Get.put<VCartBottomNavController>(
        VCartBottomNavController(repository: Get.find<NavigationRepository>()),
        permanent: true,
      );
    }

    // Filter Page Controller - Lazy loaded
    Get.lazyPut<VCartFilterPageController>(
      () => VCartFilterPageController(
        getFilterDataUseCase: Get.find<GetFilterData>(),
      ),
      fenix: true,
    );

    // Home Controller - Lazy loaded
    Get.lazyPut<VCartHomeController>(
      () => VCartHomeController(
        getHomeDataUseCase: Get.find<GetHomeData>(),
        getLocationUseCase: Get.find<GetLocation>(),
      ),
      fenix: true,
    );

    // Product Listing Controller - Lazy loaded
    Get.lazyPut<VCartProductListingController>(
      () => VCartProductListingController(
        getProductsUseCase: Get.find<GetProducts>(),
        getFilteredProductCountUseCase: Get.find<GetFilteredProductCount>(),
      ),
      fenix: true,
    );

    // Search Controller - Lazy loaded
    Get.lazyPut<VCartSearchController>(
      () => VCartSearchController(
        getSearchDataUseCase: Get.find<GetSearchData>(),
        searchProductsUseCase: Get.find<SearchProducts>(),
      ),
      fenix: true,
    );
  }

  /// Initialize only the navigation controller for immediate use
  static Future<void> initNavigationOnly() async {
    try {
      if (!Get.isRegistered<NavigationRepository>()) {
        Get.lazyPut<NavigationRepository>(
          () => NavigationRepositoryImpl(),
          fenix: true,
        );
      }

      if (!Get.isRegistered<VCartBottomNavController>()) {
        Get.put<VCartBottomNavController>(
          VCartBottomNavController(
            repository: Get.find<NavigationRepository>(),
          ),
          permanent: true,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Ensure navigation controller is available
  static Future<VCartBottomNavController> ensureNavigationController() async {
    if (!Get.isRegistered<VCartBottomNavController>()) {
      await initNavigationOnly();
    }
    return Get.find<VCartBottomNavController>();
  }

  /// Clear all VCart dependencies
  static void clearAll() {
    // Clear controllers
    _clearController<VCartFilterPageController>();
    _clearController<VCartHomeController>();
    _clearController<VCartProductListingController>();
    _clearController<VCartSearchController>();
    // Don't delete navigation controller as it's permanent

    // Clear use cases
    _clearDependency<GetFilterData>();
    _clearDependency<GetHomeData>();
    _clearDependency<GetLocation>();
    _clearDependency<GetProducts>();
    _clearDependency<GetFilteredProductCount>();
    _clearDependency<GetSearchData>();
    _clearDependency<SearchProducts>();

    // Clear repositories
    _clearDependency<FilterPageRepository>();
    _clearDependency<HomeRepository>();
    _clearDependency<ProductListingRepository>();
    _clearDependency<SearchRepository>();
    // Don't delete navigation repository as it's permanent

    // Clear data sources
    _clearDependency<FilterPageRemoteDataSource>();
    _clearDependency<HomeRemoteDataSource>();
    _clearDependency<HomeLocalDataSource>();
    _clearDependency<ProductListingRemoteDataSource>();
    _clearDependency<SearchRemoteDataSource>();
    _clearDependency<SearchLocalDataSource>();
    _isInitialized = false;
  }

  static void _clearController<T>() {
    if (Get.isRegistered<T>()) {
      Get.delete<T>();
    }
  }

  static void _clearDependency<T>() {
    if (Get.isRegistered<T>()) {
      Get.delete<T>();
    }
  }

  /// Reset specific controller (useful for page refreshes)
  static void resetController<T>() {
    if (Get.isRegistered<T>()) {
      Get.delete<T>();
    }
  }

  /// Check if all core dependencies are properly registered
  static bool areCoreDependenciesRegistered() {
    final coreRegistered =
        Get.isRegistered<NetworkInfo>() && Get.isRegistered<ApiClient>();
    return coreRegistered;
  }

  static bool isNavigationReady() {
    final navRepoRegistered = Get.isRegistered<NavigationRepository>();
    final navControllerRegistered =
        Get.isRegistered<VCartBottomNavController>();
    return navRepoRegistered && navControllerRegistered;
  }

  /// Initialize only core dependencies (useful for testing or minimal setup)
  static Future<void> initCore() async {
    try {
      await _initDataSources();
      await _initRepositories();
      await _initUseCases();

      // Only put the navigation controller immediately
      if (!Get.isRegistered<VCartBottomNavController>()) {
        Get.put<VCartBottomNavController>(
          VCartBottomNavController(
            repository: Get.find<NavigationRepository>(),
          ),
          permanent: true,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get initialization status
  static Map<String, bool> getInitializationStatus() {
    return {
      'isInitialized': _isInitialized,
      'isInitializing': _isInitializing,
      'navigationRepository': Get.isRegistered<NavigationRepository>(),
      'navigationController': Get.isRegistered<VCartBottomNavController>(),
      'homeController': Get.isRegistered<VCartHomeController>(),
      'searchController': Get.isRegistered<VCartSearchController>(),
      'filterController': Get.isRegistered<VCartFilterPageController>(),
      'productListingController':
          Get.isRegistered<VCartProductListingController>(),
    };
  }
}

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
  static void init() {
    // Initialize all dependencies with lazy loading
    _initDataSources();
    _initRepositories();
    _initUseCases();
    _initControllers();
  }

  static void _initDataSources() {
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

  static void _initRepositories() {
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

    // Navigation Repository
    Get.lazyPut<NavigationRepository>(
      () => NavigationRepositoryImpl(),
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

  static void _initUseCases() {
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

  static void _initControllers() {
    // Bottom Navigation Controller - Put immediately as it's needed for main navigation
    Get.put<VCartBottomNavController>(
      VCartBottomNavController(repository: Get.find<NavigationRepository>()),
      permanent: true,
    );

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

  /// Clear all VCart dependencies
  static void clearAll() {
    // Clear controllers
    if (Get.isRegistered<VCartFilterPageController>()) {
      Get.delete<VCartFilterPageController>();
    }
    if (Get.isRegistered<VCartHomeController>()) {
      Get.delete<VCartHomeController>();
    }
    if (Get.isRegistered<VCartProductListingController>()) {
      Get.delete<VCartProductListingController>();
    }
    if (Get.isRegistered<VCartSearchController>()) {
      Get.delete<VCartSearchController>();
    }
    // Don't delete navigation controller as it's permanent

    // Clear use cases
    if (Get.isRegistered<GetFilterData>()) {
      Get.delete<GetFilterData>();
    }
    if (Get.isRegistered<GetHomeData>()) {
      Get.delete<GetHomeData>();
    }
    if (Get.isRegistered<GetLocation>()) {
      Get.delete<GetLocation>();
    }
    if (Get.isRegistered<GetProducts>()) {
      Get.delete<GetProducts>();
    }
    if (Get.isRegistered<GetFilteredProductCount>()) {
      Get.delete<GetFilteredProductCount>();
    }
    if (Get.isRegistered<GetSearchData>()) {
      Get.delete<GetSearchData>();
    }
    if (Get.isRegistered<SearchProducts>()) {
      Get.delete<SearchProducts>();
    }

    // Clear repositories
    if (Get.isRegistered<FilterPageRepository>()) {
      Get.delete<FilterPageRepository>();
    }
    if (Get.isRegistered<HomeRepository>()) {
      Get.delete<HomeRepository>();
    }
    if (Get.isRegistered<ProductListingRepository>()) {
      Get.delete<ProductListingRepository>();
    }
    if (Get.isRegistered<SearchRepository>()) {
      Get.delete<SearchRepository>();
    }
    // Don't delete navigation repository as it's permanent

    // Clear data sources
    if (Get.isRegistered<FilterPageRemoteDataSource>()) {
      Get.delete<FilterPageRemoteDataSource>();
    }
    if (Get.isRegistered<HomeRemoteDataSource>()) {
      Get.delete<HomeRemoteDataSource>();
    }
    if (Get.isRegistered<HomeLocalDataSource>()) {
      Get.delete<HomeLocalDataSource>();
    }
    if (Get.isRegistered<ProductListingRemoteDataSource>()) {
      Get.delete<ProductListingRemoteDataSource>();
    }
    if (Get.isRegistered<SearchRemoteDataSource>()) {
      Get.delete<SearchRemoteDataSource>();
    }
    if (Get.isRegistered<SearchLocalDataSource>()) {
      Get.delete<SearchLocalDataSource>();
    }
  }

  /// Reset specific controller (useful for page refreshes)
  static void resetController<T>() {
    if (Get.isRegistered<T>()) {
      Get.delete<T>();
    }
  }

  /// Check if all dependencies are properly registered
  static bool areCoreDependenciesRegistered() {
    return Get.isRegistered<NetworkInfo>() && Get.isRegistered<ApiClient>();
  }

  /// Initialize only core dependencies (useful for testing or minimal setup)
  static void initCore() {
    _initDataSources();
    _initRepositories();
    _initUseCases();

    // Only put the navigation controller immediately
    Get.put<VCartBottomNavController>(
      VCartBottomNavController(repository: Get.find<NavigationRepository>()),
      permanent: true,
    );
  }
}

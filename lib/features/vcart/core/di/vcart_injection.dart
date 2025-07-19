import 'package:get/get.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/network_info.dart';
// Categories dependencies
import '../../categories/data/datasources/categories_local_datasource.dart';
import '../../categories/data/datasources/categories_remote_datasource.dart';
import '../../categories/data/repositories/categories_repository_impl.dart';
import '../../categories/domain/repositories/categories_repository.dart';
import '../../categories/domain/usecases/get_categories_by_section.dart';
import '../../categories/domain/usecases/get_sections.dart';
import '../../categories/domain/usecases/get_subcategories_by_category.dart';
import '../../categories/presentation/controllers/categories_controller.dart';
// Home dependencies
import '../../home/data/datasources/home_local_datasource.dart';
import '../../home/data/datasources/home_remote_datasource.dart';
import '../../home/data/repositories/home_repository_impl.dart';
import '../../home/domain/repositories/home_repository.dart';
import '../../home/domain/usecases/get_home_data.dart';
import '../../home/domain/usecases/get_location.dart';
import '../../home/presentation/controllers/home_controller.dart';
// Navigation dependencies
import '../../navigation/data/repositories/navigation_repository_impl.dart';
import '../../navigation/domain/repositories/navigation_repository.dart';
import '../../navigation/presentation/controllers/bottom_nav_controller.dart';
// Product Overview dependencies
import '../../product_overview/data/datasources/product_overview_local_datasource.dart';
import '../../product_overview/data/datasources/product_overview_remote_datasource.dart';
import '../../product_overview/data/repositories/product_overview_repository_impl.dart';
import '../../product_overview/domain/repositories/product_overview_repository.dart';
import '../../product_overview/domain/usecases/add_to_cart.dart';
import '../../product_overview/domain/usecases/get_product_detail.dart';
import '../../product_overview/domain/usecases/get_product_reviews.dart';
import '../../product_overview/domain/usecases/toggle_wishlist.dart';
import '../../product_overview/presentation/controllers/product_overview_controller.dart';

class VCartInjection {
  static void init() {
    _initializeHomeDependencies();
    _initializeNavigationDependencies();
    _initializeCategoriesDependencies();
    _initializeProductOverviewDependencies();
  }

  static void _initializeHomeDependencies() {
    // Data Sources
    Get.lazyPut<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
    );
    Get.lazyPut<HomeLocalDataSource>(() => HomeLocalDataSourceImpl());

    // Repository
    Get.lazyPut<HomeRepository>(
      () => HomeRepositoryImpl(
        remoteDataSource: Get.find<HomeRemoteDataSource>(),
        localDataSource: Get.find<HomeLocalDataSource>(),
        networkInfo: Get.find<NetworkInfo>(),
      ),
    );

    // Use Cases
    Get.lazyPut(() => GetHomeData(Get.find<HomeRepository>()));
    Get.lazyPut(() => GetLocation(Get.find<HomeRepository>()));

    // Controller
    Get.lazyPut(
      () => VCartHomeController(
        getHomeDataUseCase: Get.find<GetHomeData>(),
        getLocationUseCase: Get.find<GetLocation>(),
      ),
    );
  }

  static void _initializeNavigationDependencies() {
    // Repository
    Get.lazyPut<NavigationRepository>(() => NavigationRepositoryImpl());

    // Controller
    Get.lazyPut(
      () => VCartBottomNavController(
        repository: Get.find<NavigationRepository>(),
      ),
    );
  }

  static void _initializeCategoriesDependencies() {
    // Data Sources
    Get.lazyPut<CategoriesRemoteDataSource>(
      () => CategoriesRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
    );
    Get.lazyPut<CategoriesLocalDataSource>(
      () => CategoriesLocalDataSourceImpl(),
    );

    // Repository
    Get.lazyPut<CategoriesRepository>(
      () => CategoriesRepositoryImpl(
        remoteDataSource: Get.find<CategoriesRemoteDataSource>(),
        localDataSource: Get.find<CategoriesLocalDataSource>(),
        networkInfo: Get.find<NetworkInfo>(),
      ),
    );

    // Use Cases
    Get.lazyPut(() => GetSections(Get.find<CategoriesRepository>()));
    Get.lazyPut(() => GetCategoriesBySection(Get.find<CategoriesRepository>()));
    Get.lazyPut(
      () => GetSubCategoriesByCategory(Get.find<CategoriesRepository>()),
    );

    // Controller
    Get.lazyPut(
      () => VCartCategoriesController(
        getSectionsUseCase: Get.find<GetSections>(),
        getCategoriesBySectionUseCase: Get.find<GetCategoriesBySection>(),
        getSubCategoriesByCategoryUseCase:
            Get.find<GetSubCategoriesByCategory>(),
      ),
    );
  }

  static void _initializeProductOverviewDependencies() {
    // Data Sources
    Get.lazyPut<ProductOverviewRemoteDataSource>(
      () =>
          ProductOverviewRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
    );
    Get.lazyPut<ProductOverviewLocalDataSource>(
      () => ProductOverviewLocalDataSourceImpl(),
    );

    // Repository
    Get.lazyPut<ProductOverviewRepository>(
      () => ProductOverviewRepositoryImpl(
        remoteDataSource: Get.find<ProductOverviewRemoteDataSource>(),
        localDataSource: Get.find<ProductOverviewLocalDataSource>(),
        networkInfo: Get.find<NetworkInfo>(),
      ),
    );

    // Use Cases
    Get.lazyPut(() => GetProductDetail(Get.find<ProductOverviewRepository>()));
    Get.lazyPut(() => GetProductReviews(Get.find<ProductOverviewRepository>()));
    Get.lazyPut(() => AddToCart(Get.find<ProductOverviewRepository>()));
    Get.lazyPut(() => ToggleWishlist(Get.find<ProductOverviewRepository>()));

    // Controller
    Get.lazyPut(
      () => VCartProductOverviewController(
        getProductDetailUseCase: Get.find<GetProductDetail>(),
        getProductReviewsUseCase: Get.find<GetProductReviews>(),
        addToCartUseCase: Get.find<AddToCart>(),
        toggleWishlistUseCase: Get.find<ToggleWishlist>(),
      ),
    );
  }

  static void dispose() {
    // Home
    Get.delete<VCartHomeController>();
    Get.delete<GetHomeData>();
    Get.delete<GetLocation>();
    Get.delete<HomeRepository>();
    Get.delete<HomeRemoteDataSource>();
    Get.delete<HomeLocalDataSource>();

    // Navigation
    Get.delete<VCartBottomNavController>();
    Get.delete<NavigationRepository>();

    // Categories
    Get.delete<VCartCategoriesController>();
    Get.delete<GetSections>();
    Get.delete<GetCategoriesBySection>();
    Get.delete<GetSubCategoriesByCategory>();
    Get.delete<CategoriesRepository>();
    Get.delete<CategoriesRemoteDataSource>();
    Get.delete<CategoriesLocalDataSource>();

    // Product Overview
    Get.delete<VCartProductOverviewController>();
    Get.delete<GetProductDetail>();
    Get.delete<GetProductReviews>();
    Get.delete<AddToCart>();
    Get.delete<ToggleWishlist>();
    Get.delete<ProductOverviewRepository>();
    Get.delete<ProductOverviewRemoteDataSource>();
    Get.delete<ProductOverviewLocalDataSource>();
  }
}

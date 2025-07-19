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
// Profile dependencies
import '../../profile/data/datasources/profile_local_datasource.dart';
import '../../profile/data/datasources/profile_remote_datasource.dart';
import '../../profile/data/repositories/profile_repository_impl.dart';
import '../../profile/domain/repositories/profile_repository.dart';
import '../../profile/domain/usecases/get_profile_data.dart';
import '../../profile/presentation/controllers/profile_controller.dart';
// Search dependencies
import '../../search/data/datasources/search_local_datasource.dart';
import '../../search/data/datasources/search_remote_datasource.dart';
import '../../search/data/repositories/search_repository_impl.dart';
import '../../search/domain/repositories/search_repository.dart';
import '../../search/domain/usecases/get_search_data.dart';
import '../../search/domain/usecases/search_products.dart';
import '../../search/presentation/controllers/search_controller.dart';
// Wishlist dependencies
import '../../wishlist/data/datasources/wishlist_remote_datasource.dart';
import '../../wishlist/data/repositories/wishlist_repository_impl.dart';
import '../../wishlist/domain/repositories/wishlist_repository.dart';
import '../../wishlist/domain/usecases/get_wishlist_data.dart';
import '../../wishlist/domain/usecases/toggle_wishlist_item.dart';
import '../../wishlist/presentation/controllers/wishlist_controller.dart';

class VCartInjection {
  static void init() {
    _initializeHomeDependencies();
    _initializeNavigationDependencies();
    _initializeCategoriesDependencies();
    _initializeProductOverviewDependencies();
    _initializeProfileDependencies();
    _initializeSearchDependencies();
    _initializeWishlistDependencies();
  }

  static void _initializeHomeDependencies() {
    // Data Sources
    Get.lazyPut<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<HomeLocalDataSource>(
      () => HomeLocalDataSourceImpl(),
      fenix: true,
    );

    // Repository
    Get.lazyPut<HomeRepository>(
      () => HomeRepositoryImpl(
        remoteDataSource: Get.find<HomeRemoteDataSource>(),
        localDataSource: Get.find<HomeLocalDataSource>(),
        networkInfo: Get.find<NetworkInfo>(),
      ),
      fenix: true,
    );

    // Use Cases
    Get.lazyPut(() => GetHomeData(Get.find<HomeRepository>()), fenix: true);
    Get.lazyPut(() => GetLocation(Get.find<HomeRepository>()), fenix: true);

    // Controller
    Get.put(
      VCartHomeController(
        getHomeDataUseCase: Get.find<GetHomeData>(),
        getLocationUseCase: Get.find<GetLocation>(),
      ),
      permanent: true,
    );
  }

  static void _initializeNavigationDependencies() {
    // Repository
    Get.lazyPut<NavigationRepository>(
      () => NavigationRepositoryImpl(),
      fenix: true,
    );

    // Controller
    Get.put(
      VCartBottomNavController(repository: Get.find<NavigationRepository>()),
      permanent: true,
    );
  }

  static void _initializeCategoriesDependencies() {
    // Data Sources
    Get.lazyPut<CategoriesRemoteDataSource>(
      () => CategoriesRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<CategoriesLocalDataSource>(
      () => CategoriesLocalDataSourceImpl(),
      fenix: true,
    );

    // Repository
    Get.lazyPut<CategoriesRepository>(
      () => CategoriesRepositoryImpl(
        remoteDataSource: Get.find<CategoriesRemoteDataSource>(),
        localDataSource: Get.find<CategoriesLocalDataSource>(),
        networkInfo: Get.find<NetworkInfo>(),
      ),
      fenix: true,
    );

    // Use Cases
    Get.lazyPut(
      () => GetSections(Get.find<CategoriesRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => GetCategoriesBySection(Get.find<CategoriesRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => GetSubCategoriesByCategory(Get.find<CategoriesRepository>()),
      fenix: true,
    );

    // Controller
    Get.put(
      VCartCategoriesController(
        getSectionsUseCase: Get.find<GetSections>(),
        getCategoriesBySectionUseCase: Get.find<GetCategoriesBySection>(),
        getSubCategoriesByCategoryUseCase:
            Get.find<GetSubCategoriesByCategory>(),
      ),
      permanent: true,
    );
  }

  static void _initializeProductOverviewDependencies() {
    // Data Sources
    Get.lazyPut<ProductOverviewRemoteDataSource>(
      () =>
          ProductOverviewRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<ProductOverviewLocalDataSource>(
      () => ProductOverviewLocalDataSourceImpl(),
      fenix: true,
    );

    // Repository
    Get.lazyPut<ProductOverviewRepository>(
      () => ProductOverviewRepositoryImpl(
        remoteDataSource: Get.find<ProductOverviewRemoteDataSource>(),
        localDataSource: Get.find<ProductOverviewLocalDataSource>(),
        networkInfo: Get.find<NetworkInfo>(),
      ),
      fenix: true,
    );

    // Use Cases
    Get.lazyPut(
      () => GetProductDetail(Get.find<ProductOverviewRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => GetProductReviews(Get.find<ProductOverviewRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => AddToCart(Get.find<ProductOverviewRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => ToggleWishlist(Get.find<ProductOverviewRepository>()),
      fenix: true,
    );

    // Controller
    Get.lazyPut(
      () => VCartProductOverviewController(
        getProductDetailUseCase: Get.find<GetProductDetail>(),
        getProductReviewsUseCase: Get.find<GetProductReviews>(),
        addToCartUseCase: Get.find<AddToCart>(),
        toggleWishlistUseCase: Get.find<ToggleWishlist>(),
      ),
      fenix: true,
    );
  }

  static void _initializeProfileDependencies() {
    // Data Sources
    Get.lazyPut<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<ProfileLocalDataSource>(
      () => ProfileLocalDataSourceImpl(),
      fenix: true,
    );

    // Repository
    Get.lazyPut<ProfileRepository>(
      () => ProfileRepositoryImpl(
        remoteDataSource: Get.find<ProfileRemoteDataSource>(),
        localDataSource: Get.find<ProfileLocalDataSource>(),
        networkInfo: Get.find<NetworkInfo>(),
      ),
      fenix: true,
    );

    // Use Cases
    Get.lazyPut(
      () => GetProfileData(Get.find<ProfileRepository>()),
      fenix: true,
    );

    // Controller
    Get.put(
      VCartProfileController(getProfileDataUseCase: Get.find<GetProfileData>()),
      permanent: true,
    );
  }

  static void _initializeSearchDependencies() {
    // Data Sources
    Get.lazyPut<SearchRemoteDataSource>(
      () => SearchRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<SearchLocalDataSource>(
      () => SearchLocalDataSourceImpl(),
      fenix: true,
    );

    // Repository
    Get.lazyPut<SearchRepository>(
      () => SearchRepositoryImpl(
        remoteDataSource: Get.find<SearchRemoteDataSource>(),
        localDataSource: Get.find<SearchLocalDataSource>(),
        networkInfo: Get.find<NetworkInfo>(),
      ),
      fenix: true,
    );

    // Use Cases
    Get.lazyPut(() => GetSearchData(Get.find<SearchRepository>()), fenix: true);
    Get.lazyPut(
      () => SearchProducts(Get.find<SearchRepository>()),
      fenix: true,
    );

    // Controller
    Get.put(
      VCartSearchController(
        getSearchDataUseCase: Get.find<GetSearchData>(),
        searchProductsUseCase: Get.find<SearchProducts>(),
      ),
      permanent: true,
    );
  }

  static void _initializeWishlistDependencies() {
    // Data Sources
    Get.lazyPut<WishlistRemoteDataSource>(
      () => WishlistRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );

    // Repository
    Get.lazyPut<WishlistRepository>(
      () => WishlistRepositoryImpl(
        remoteDataSource: Get.find<WishlistRemoteDataSource>(),
        networkInfo: Get.find<NetworkInfo>(),
      ),
      fenix: true,
    );

    // Use Cases
    Get.lazyPut(
      () => GetWishlistData(Get.find<WishlistRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => ToggleWishlistItem(Get.find<WishlistRepository>()),
      fenix: true,
    );

    // Controller
    Get.put(
      VCartWishlistController(
        getWishlistDataUseCase: Get.find<GetWishlistData>(),
        toggleWishlistItemUseCase: Get.find<ToggleWishlistItem>(),
      ),
      permanent: true,
    );
  }

  static void dispose() {
    // Dispose controllers that need cleanup
    if (Get.isRegistered<VCartProductOverviewController>()) {
      Get.delete<VCartProductOverviewController>();
    }

    // Dispose use cases
    Get.delete<GetProductDetail>(force: true);
    Get.delete<GetProductReviews>(force: true);
    Get.delete<AddToCart>(force: true);
    Get.delete<ToggleWishlist>(force: true);
    Get.delete<GetProfileData>(force: true);
    Get.delete<GetSearchData>(force: true);
    Get.delete<SearchProducts>(force: true);
    Get.delete<GetWishlistData>(force: true);
    Get.delete<ToggleWishlistItem>(force: true);

    // Dispose repositories
    Get.delete<ProductOverviewRepository>(force: true);
    Get.delete<ProfileRepository>(force: true);
    Get.delete<SearchRepository>(force: true);
    Get.delete<WishlistRepository>(force: true);

    // Dispose data sources
    Get.delete<ProductOverviewRemoteDataSource>(force: true);
    Get.delete<ProductOverviewLocalDataSource>(force: true);
    Get.delete<ProfileRemoteDataSource>(force: true);
    Get.delete<ProfileLocalDataSource>(force: true);
    Get.delete<SearchRemoteDataSource>(force: true);
    Get.delete<SearchLocalDataSource>(force: true);
    Get.delete<WishlistRemoteDataSource>(force: true);
  }
}

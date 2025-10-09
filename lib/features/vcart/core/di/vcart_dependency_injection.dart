import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/network_info.dart';
import '../../cart/data/datasources/cart_local_datasource.dart';
import '../../cart/data/datasources/cart_remote_datasource.dart';
import '../../cart/data/repositories/cart_repository_impl.dart';
import '../../cart/domain/repositories/cart_repository.dart';
import '../../cart/domain/usecases/get_cart_data.dart';
import '../../cart/domain/usecases/manage_coupon.dart';
import '../../cart/domain/usecases/move_to_wishlist.dart';
import '../../cart/domain/usecases/update_cart_item.dart';
import '../../cart/presentation/controllers/cart_controller.dart';
import '../../categories/data/datasources/categories_local_datasource.dart';
import '../../categories/data/datasources/categories_remote_datasource.dart';
import '../../categories/data/repositories/categories_repository_impl.dart';
import '../../categories/domain/repositories/categories_repository.dart';
import '../../categories/domain/usecases/get_categories_by_section.dart'
    as categories_usecases;
import '../../categories/domain/usecases/get_sections.dart';
import '../../categories/domain/usecases/get_subcategories_by_category.dart';
import '../../categories/presentation/controllers/categories_controller.dart';
import '../../coupons/data/datasources/coupons_remote_datasource.dart';
import '../../coupons/data/repositories/coupons_repository_impl.dart';
import '../../coupons/domain/repositories/coupons_repository.dart';
import '../../coupons/domain/usecases/apply_coupon.dart';
import '../../coupons/domain/usecases/get_coupons.dart';
import '../../coupons/presentation/controllers/coupons_controller.dart';
import '../../filter_page/data/datasources/filter_page_remote_datasource.dart';
import '../../filter_page/data/repositories/filter_page_repository_impl.dart';
import '../../filter_page/domain/repositories/filter_page_repository.dart';
import '../../filter_page/domain/usecases/get_filter_data.dart';
import '../../filter_page/presentation/controllers/filter_page_controller.dart';
import '../../home/data/datasources/home_local_datasource.dart';
import '../../home/data/datasources/home_remote_datasource.dart';
//import '../../home/data/repositories/home_repository_impl.dart' as vcart_impl;
//import '../../home/domain/repositories/home_repository.dart' as vcart_repo;
import '../../home/domain/usecases/get_home_data.dart';
import '../../home/domain/usecases/get_location.dart';
import '../../home/presentation/controllers/home_controller.dart';
import '../../navigation/data/repositories/navigation_repository_impl.dart';
import '../../navigation/domain/repositories/navigation_repository.dart';
import '../../navigation/presentation/controllers/bottom_nav_controller.dart';
import '../../order_history/data/datasources/order_history_remote_datasource.dart';
import '../../order_history/data/repositories/order_history_repository_impl.dart';
import '../../order_history/domain/repositories/order_history_repository.dart';
import '../../order_history/domain/usecases/get_order_history.dart';
import '../../order_history/presentation/controllers/order_history_controller.dart';
import '../../order_history_details/data/datasources/order_details_remote_datasource.dart';
import '../../order_history_details/data/repositories/order_details_repository_impl.dart';
import '../../order_history_details/domain/repositories/order_details_repository.dart';
import '../../order_history_details/domain/usecases/get_order_details.dart';
import '../../order_history_details/domain/usecases/submit_review.dart';
import '../../order_history_details/presentation/controllers/order_details_controller.dart';
import '../../product_listing/data/datasources/product_listing_remote_datasource.dart';
import '../../product_listing/data/repositories/product_listing_repository_impl.dart';
import '../../product_listing/domain/repositories/product_listing_repository.dart';
import '../../product_listing/domain/usecases/get_filtered_product_count.dart';
import '../../product_listing/domain/usecases/get_products.dart';
import '../../product_listing/presentation/controllers/product_listing_controller.dart';
import '../../product_overview/data/datasources/product_overview_local_datasource.dart';
import '../../product_overview/data/datasources/product_overview_remote_datasource.dart';
import '../../product_overview/data/repositories/product_overview_repository_impl.dart';
import '../../product_overview/domain/repositories/product_overview_repository.dart';
import '../../product_overview/domain/usecases/add_to_cart.dart';
import '../../product_overview/domain/usecases/get_product_detail.dart';
import '../../product_overview/domain/usecases/get_product_reviews.dart';
import '../../product_overview/domain/usecases/toggle_wishlist.dart';
import '../../product_overview/presentation/controllers/product_overview_controller.dart';
import '../../profile/data/datasources/profile_local_datasource.dart';
import '../../profile/data/datasources/profile_remote_datasource.dart';
import '../../profile/data/repositories/profile_repository_impl.dart';
import '../../profile/domain/repositories/profile_repository.dart';
import '../../profile/domain/usecases/get_profile_data.dart';
import '../../profile/presentation/controllers/profile_controller.dart';
import '../../search/data/datasources/search_local_datasource.dart';
import '../../search/data/datasources/search_remote_datasource.dart';
import '../../search/data/repositories/search_repository_impl.dart';
import '../../search/domain/repositories/search_repository.dart';
import '../../search/domain/usecases/get_search_data.dart';
import '../../search/domain/usecases/search_products.dart';
import '../../search/presentation/controllers/search_controller.dart';
import '../../section_category/data/datasources/section_category_remote_datasource.dart';
import '../../section_category/data/repositories/section_category_repository_impl.dart';
import '../../section_category/domain/repositories/section_category_repository.dart';
import '../../section_category/domain/usecases/get_categories_by_section.dart'
    as section_usecases;
import '../../section_category/presentation/controllers/section_category_controller.dart';
import '../../wishlist/data/datasources/wishlist_remote_datasource.dart';
import '../../wishlist/data/repositories/wishlist_repository_impl.dart';
import '../../wishlist/domain/repositories/wishlist_repository.dart';
import '../../wishlist/domain/usecases/get_wishlist_data.dart';
import '../../wishlist/domain/usecases/toggle_wishlist_item.dart';
import '../../wishlist/presentation/controllers/wishlist_controller.dart';
 import 'package:livera/features/vcart/home/domain/repositories/home_repository.dart' as vcart_repo;
 import 'package:livera/features/vcart/home/data/repositories/home_repository_impl.dart' as vcart_impl;

class VCartDI {
  static bool _isInitialized = false;
  static bool _isInitializing = false;
  static String? _lastError;

  static bool get isInitialized => _isInitialized;
  static bool get isInitializing => _isInitializing;
  static String? get lastError => _lastError;

  static Future<void> init() async {
    if (_isInitialized) {
      debugPrint('✅ VCart DI already initialized');
      return;
    }

    if (_isInitializing) {
      debugPrint('⏳ VCart DI initialization already in progress');
      // Wait for the ongoing initialization to complete
      while (_isInitializing) {
        await Future.delayed(const Duration(milliseconds: 50));
      }
      return;
    }

    _isInitializing = true;
    _lastError = null;

    try {
      debugPrint('🚀 Starting VCart DI initialization...');

      // Check prerequisites
      await _checkPrerequisites();

      // Initialize in order
      await _initDataSources();
      debugPrint('✅ Data sources initialized');

      await _initRepositories();
      debugPrint('✅ Repositories initialized');

      await _initUseCases();
      debugPrint('✅ Use cases initialized');

      await _initControllers();
      debugPrint('✅ Controllers initialized');

      _isInitialized = true;
      debugPrint('🎉 VCart DI initialization completed successfully');
    } catch (e, stackTrace) {
      _lastError = e.toString();
      debugPrint('❌ VCart DI initialization failed: $e');
      debugPrint('Stack trace: $stackTrace');

      // Clean up partial initialization
      _cleanup();
      rethrow;
    } finally {
      _isInitializing = false;
    }
  }

  static Future<void> _checkPrerequisites() async {
    // Check if core dependencies are available
    if (!Get.isRegistered<ApiClient>()) {
      throw Exception(
        'ApiClient not registered. Core DI must be initialized first.',
      );
    }

    if (!Get.isRegistered<NetworkInfo>()) {
      throw Exception(
        'NetworkInfo not registered. Core DI must be initialized first.',
      );
    }

    debugPrint('✅ Prerequisites check passed');
  }

  static Future<void> _initDataSources() async {
    try {
      // Cart DataSources
      Get.lazyPut<CartRemoteDataSource>(
        () => CartRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
        fenix: true,
      );

      Get.lazyPut<CartLocalDataSource>(
        () => CartLocalDataSourceImpl(),
        fenix: true,
      );

      // Categories DataSources
      Get.lazyPut<CategoriesRemoteDataSource>(
        () => CategoriesRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
        fenix: true,
      );

      Get.lazyPut<CategoriesLocalDataSource>(
        () => CategoriesLocalDataSourceImpl(),
        fenix: true,
      );

      // Coupons DataSources
      Get.lazyPut<CouponsRemoteDataSource>(
        () => CouponsRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
        fenix: true,
      );

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

      // Order History DataSources
      Get.lazyPut<OrderHistoryRemoteDataSource>(
        () =>
            OrderHistoryRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
        fenix: true,
      );

      Get.lazyPut<OrderDetailsRemoteDataSource>(
        () =>
            OrderDetailsRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
        fenix: true,
      );

      // Product Listing DataSources
      Get.lazyPut<ProductListingRemoteDataSource>(
        () => ProductListingRemoteDataSourceImpl(
          apiClient: Get.find<ApiClient>(),
        ),
        fenix: true,
      );

      // Product Overview DataSources
      Get.lazyPut<ProductOverviewRemoteDataSource>(
        () => ProductOverviewRemoteDataSourceImpl(
          apiClient: Get.find<ApiClient>(),
        ),
        fenix: true,
      );

      Get.lazyPut<ProductOverviewLocalDataSource>(
        () => ProductOverviewLocalDataSourceImpl(),
        fenix: true,
      );

      // Profile DataSources
      Get.lazyPut<ProfileRemoteDataSource>(
        () => ProfileRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
        fenix: true,
      );

      Get.lazyPut<ProfileLocalDataSource>(
        () => ProfileLocalDataSourceImpl(),
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

      // Section Category DataSources
      Get.lazyPut<SectionCategoryRemoteDataSource>(
        () => SectionCategoryRemoteDataSourceImpl(
          apiClient: Get.find<ApiClient>(),
        ),
        fenix: true,
      );

      // Wishlist DataSources
      Get.lazyPut<WishlistRemoteDataSource>(
        () => WishlistRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
        fenix: true,
      );
    } catch (e) {
      throw Exception('Failed to initialize data sources: $e');
    }
  }

  static Future<void> _initRepositories() async {
    try {
      // Navigation Repository - Initialize first as it's critical
      Get.lazyPut<NavigationRepository>(
        () => NavigationRepositoryImpl(),
        fenix: true,
      );

      // Cart Repository
      Get.lazyPut<CartRepository>(
        () => CartRepositoryImpl(
          remoteDataSource: Get.find<CartRemoteDataSource>(),
          localDataSource: Get.find<CartLocalDataSource>(),
          networkInfo: Get.find<NetworkInfo>(),
        ),
        fenix: true,
      );

      // Categories Repository
      Get.lazyPut<CategoriesRepository>(
        () => CategoriesRepositoryImpl(
          remoteDataSource: Get.find<CategoriesRemoteDataSource>(),
          localDataSource: Get.find<CategoriesLocalDataSource>(),
          networkInfo: Get.find<NetworkInfo>(),
        ),
        fenix: true,
      );

      // Coupons Repository
      Get.lazyPut<CouponsRepository>(
        () => CouponsRepositoryImpl(
          remoteDataSource: Get.find<CouponsRemoteDataSource>(),
          networkInfo: Get.find<NetworkInfo>(),
        ),
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
      Get.lazyPut<vcart_repo.HomeRepository>(
        () => vcart_impl.HomeRepositoryImpl(
          remoteDataSource: Get.find<HomeRemoteDataSource>(),
          localDataSource: Get.find<HomeLocalDataSource>(),
          networkInfo: Get.find<NetworkInfo>(),
        ),
        fenix: true,
      );

      // Order History Repositories
      Get.lazyPut<OrderHistoryRepository>(
        () => OrderHistoryRepositoryImpl(
          remoteDataSource: Get.find<OrderHistoryRemoteDataSource>(),
          networkInfo: Get.find<NetworkInfo>(),
        ),
        fenix: true,
      );

      Get.lazyPut<OrderDetailsRepository>(
        () => OrderDetailsRepositoryImpl(
          remoteDataSource: Get.find<OrderDetailsRemoteDataSource>(),
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

      // Product Overview Repository
      Get.lazyPut<ProductOverviewRepository>(
        () => ProductOverviewRepositoryImpl(
          remoteDataSource: Get.find<ProductOverviewRemoteDataSource>(),
          localDataSource: Get.find<ProductOverviewLocalDataSource>(),
          networkInfo: Get.find<NetworkInfo>(),
        ),
        fenix: true,
      );

      // Profile Repository
      Get.lazyPut<ProfileRepository>(
        () => ProfileRepositoryImpl(
          remoteDataSource: Get.find<ProfileRemoteDataSource>(),
          localDataSource: Get.find<ProfileLocalDataSource>(),
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

      // Section Category Repository
      Get.lazyPut<SectionCategoryRepository>(
        () => SectionCategoryRepositoryImpl(
          remoteDataSource: Get.find<SectionCategoryRemoteDataSource>(),
          networkInfo: Get.find<NetworkInfo>(),
        ),
        fenix: true,
      );

      // Wishlist Repository
      Get.lazyPut<WishlistRepository>(
        () => WishlistRepositoryImpl(
          remoteDataSource: Get.find<WishlistRemoteDataSource>(),
          networkInfo: Get.find<NetworkInfo>(),
        ),
        fenix: true,
      );
    } catch (e) {
      throw Exception('Failed to initialize repositories: $e');
    }
  }

  static Future<void> _initUseCases() async {
    try {
      // Cart Use Cases
      Get.lazyPut<GetCartData>(
        () => GetCartData(Get.find<CartRepository>()),
        fenix: true,
      );

      Get.lazyPut<UpdateCartItem>(
        () => UpdateCartItem(Get.find<CartRepository>()),
        fenix: true,
      );

      Get.lazyPut<MoveToWishlist>(
        () => MoveToWishlist(Get.find<CartRepository>()),
        fenix: true,
      );

      Get.lazyPut<ApplyCoupon>(
        () => ApplyCoupon(Get.find<CartRepository>()),
        fenix: true,
      );

      Get.lazyPut<RemoveCoupon>(
        () => RemoveCoupon(Get.find<CartRepository>()),
        fenix: true,
      );

      // Categories Use Cases
      Get.lazyPut<GetSections>(
        () => GetSections(Get.find<CategoriesRepository>()),
        fenix: true,
      );

      Get.lazyPut<categories_usecases.GetCategoriesBySection>(
        () => categories_usecases.GetCategoriesBySection(
          Get.find<CategoriesRepository>(),
        ),
        fenix: true,
      );

      Get.lazyPut<GetSubCategoriesByCategory>(
        () => GetSubCategoriesByCategory(Get.find<CategoriesRepository>()),
        fenix: true,
      );

      // Coupons Use Cases
      Get.lazyPut<GetCoupons>(
        () => GetCoupons(Get.find<CouponsRepository>()),
        fenix: true,
      );

      Get.lazyPut<ApplyCouponUseCase>(
        () => ApplyCouponUseCase(Get.find<CouponsRepository>()),
        fenix: true,
      );

      // Filter Page Use Cases
      Get.lazyPut<GetFilterData>(
        () => GetFilterData(Get.find<FilterPageRepository>()),
        fenix: true,
      );

      // Home Use Cases
      Get.lazyPut<GetHomeData>(
        () => GetHomeData(Get.find<vcart_repo.HomeRepository>()),
        fenix: true,
      );

      Get.lazyPut<GetLocation>(
        () => GetLocation(Get.find<vcart_repo.HomeRepository>()),
        fenix: true,
      );

      // Order History Use Cases
      Get.lazyPut<GetOrderHistory>(
        () => GetOrderHistory(Get.find<OrderHistoryRepository>()),
        fenix: true,
      );

      Get.lazyPut<GetOrderDetails>(
        () => GetOrderDetails(Get.find<OrderDetailsRepository>()),
        fenix: true,
      );

      Get.lazyPut<SubmitReview>(
        () => SubmitReview(Get.find<OrderDetailsRepository>()),
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

      // Product Overview Use Cases
      Get.lazyPut<GetProductDetail>(
        () => GetProductDetail(Get.find<ProductOverviewRepository>()),
        fenix: true,
      );

      Get.lazyPut<GetProductReviews>(
        () => GetProductReviews(Get.find<ProductOverviewRepository>()),
        fenix: true,
      );

      Get.lazyPut<AddToCart>(
        () => AddToCart(Get.find<ProductOverviewRepository>()),
        fenix: true,
      );

      Get.lazyPut<ToggleWishlist>(
        () => ToggleWishlist(Get.find<ProductOverviewRepository>()),
        fenix: true,
      );

      // Profile Use Cases
      Get.lazyPut<GetProfileData>(
        () => GetProfileData(Get.find<ProfileRepository>()),
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

      // Section Category Use Cases
      Get.lazyPut<section_usecases.GetCategoriesBySection>(
        () => section_usecases.GetCategoriesBySection(
          Get.find<SectionCategoryRepository>(),
        ),
        fenix: true,
      );

      // Wishlist Use Cases
      Get.lazyPut<GetWishlistData>(
        () => GetWishlistData(Get.find<WishlistRepository>()),
        fenix: true,
      );

      Get.lazyPut<ToggleWishlistItem>(
        () => ToggleWishlistItem(Get.find<WishlistRepository>()),
        fenix: true,
      );
    } catch (e) {
      throw Exception('Failed to initialize use cases: $e');
    }
  }

  static Future<void> _initControllers() async {
    try {
      // Navigation Controller - Permanent and critical
      if (!Get.isRegistered<VCartBottomNavController>()) {
        Get.put<VCartBottomNavController>(
          VCartBottomNavController(
            repository: Get.find<NavigationRepository>(),
          ),
          permanent: true,
        );
      }

      // Cart Controller - Critical for cart functionality
      Get.lazyPut<VCartCartController>(() {
        try {
          return VCartCartController(
            getCartDataUseCase: Get.find<GetCartData>(),
            updateCartItemUseCase: Get.find<UpdateCartItem>(),
            moveToWishlistUseCase: Get.find<MoveToWishlist>(),
            applyCouponUseCase: Get.find<ApplyCoupon>(),
            removeCouponUseCase: Get.find<RemoveCoupon>(),
          );
        } catch (e) {
          debugPrint('❌ Failed to create VCartCartController: $e');
          rethrow;
        }
      }, fenix: true);

      // Categories Controller
      Get.lazyPut<VCartCategoriesController>(
        () => VCartCategoriesController(
          getSectionsUseCase: Get.find<GetSections>(),
          getCategoriesBySectionUseCase:
              Get.find<categories_usecases.GetCategoriesBySection>(),
          getSubCategoriesByCategoryUseCase:
              Get.find<GetSubCategoriesByCategory>(),
        ),
        fenix: true,
      );

      // Coupons Controller
      Get.lazyPut<VCartCouponsController>(
        () => VCartCouponsController(
          getCouponsUseCase: Get.find<GetCoupons>(),
          applyCouponUseCase: Get.find<ApplyCouponUseCase>(),
        ),
        fenix: true,
      );

      // Filter Page Controller
      Get.lazyPut<VCartFilterPageController>(
        () => VCartFilterPageController(
          getFilterDataUseCase: Get.find<GetFilterData>(),
        ),
        fenix: true,
      );

      // Home Controller
      Get.lazyPut<VCartHomeController>(
        () => VCartHomeController(
          getHomeDataUseCase: Get.find<GetHomeData>(),
          getLocationUseCase: Get.find<GetLocation>(),
        ),
        fenix: true,
      );

      // Order History Controllers
      Get.lazyPut<VCartOrderHistoryController>(
        () => VCartOrderHistoryController(
          getOrderHistoryUseCase: Get.find<GetOrderHistory>(),
        ),
        fenix: true,
      );

      Get.lazyPut<VCartOrderDetailsController>(
        () => VCartOrderDetailsController(
          getOrderDetailsUseCase: Get.find<GetOrderDetails>(),
          submitReviewUseCase: Get.find<SubmitReview>(),
        ),
        fenix: true,
      );

      // Product Listing Controller
      Get.lazyPut<VCartProductListingController>(
        () => VCartProductListingController(
          getProductsUseCase: Get.find<GetProducts>(),
          getFilteredProductCountUseCase: Get.find<GetFilteredProductCount>(),
        ),
        fenix: true,
      );

      // Product Overview Controller
      Get.lazyPut<VCartProductOverviewController>(
        () => VCartProductOverviewController(
          getProductDetailUseCase: Get.find<GetProductDetail>(),
          getProductReviewsUseCase: Get.find<GetProductReviews>(),
          addToCartUseCase: Get.find<AddToCart>(),
          toggleWishlistUseCase: Get.find<ToggleWishlist>(),
        ),
        fenix: true,
      );

      // Profile Controller
      Get.lazyPut<VCartProfileController>(
        () => VCartProfileController(
          getProfileDataUseCase: Get.find<GetProfileData>(),
        ),
        fenix: true,
      );

      // Search Controller
      Get.lazyPut<VCartSearchController>(
        () => VCartSearchController(
          getSearchDataUseCase: Get.find<GetSearchData>(),
          searchProductsUseCase: Get.find<SearchProducts>(),
        ),
        fenix: true,
      );

      // Section Category Controller
      Get.lazyPut<VCartSectionCategoryController>(
        () => VCartSectionCategoryController(
          getCategoriesBySectionUseCase:
              Get.find<section_usecases.GetCategoriesBySection>(),
        ),
        fenix: true,
      );

      // Wishlist Controller
      Get.lazyPut<VCartWishlistController>(
        () => VCartWishlistController(
          getWishlistDataUseCase: Get.find<GetWishlistData>(),
          toggleWishlistItemUseCase: Get.find<ToggleWishlistItem>(),
        ),
        fenix: true,
      );

      // Verify critical controllers are registered
      await _verifyCriticalControllers();
    } catch (e) {
      throw Exception('Failed to initialize controllers: $e');
    }
  }

  static Future<void> _verifyCriticalControllers() async {
    // Fixed: Use Get.isRegistered<Type>() instead of Get.isRegistered(tag: Type.toString())
    final criticalControllers = <Type>[
      VCartBottomNavController,
      VCartCartController,
      VCartOrderHistoryController,
      VCartOrderDetailsController,
    ];

    for (final controllerType in criticalControllers) {
      bool isRegistered = false;

      // Check registration for each controller type specifically
      if (controllerType == VCartBottomNavController) {
        isRegistered = Get.isRegistered<VCartBottomNavController>();
      } else if (controllerType == VCartCartController) {
        isRegistered = Get.isRegistered<VCartCartController>();
      } else if (controllerType == VCartOrderHistoryController) {
        isRegistered = Get.isRegistered<VCartOrderHistoryController>();
      } else if (controllerType == VCartOrderDetailsController) {
        isRegistered = Get.isRegistered<VCartOrderDetailsController>();
      }

      if (!isRegistered) {
        throw Exception(
          'Critical controller $controllerType failed to register',
        );
      }
    }

    debugPrint('✅ Critical controllers verification passed');
  }

  static void _cleanup() {
    debugPrint('🧹 Cleaning up partial VCart DI initialization');

    // Don't clear navigation controller as it might be used elsewhere
    // Just clear the failed initialization state
    _isInitialized = false;
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
      debugPrint('❌ Failed to initialize navigation only: $e');
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

  /// Get initialization status
  static Map<String, dynamic> getInitializationStatus() {
    return {
      'isInitialized': _isInitialized,
      'isInitializing': _isInitializing,
      'lastError': _lastError,
      'navigationRepository': Get.isRegistered<NavigationRepository>(),
      'navigationController': Get.isRegistered<VCartBottomNavController>(),
      'cartController': Get.isRegistered<VCartCartController>(),
      'categoriesController': Get.isRegistered<VCartCategoriesController>(),
      'couponsController': Get.isRegistered<VCartCouponsController>(),
      'homeController': Get.isRegistered<VCartHomeController>(),
      'orderHistoryController': Get.isRegistered<VCartOrderHistoryController>(),
      'orderDetailsController': Get.isRegistered<VCartOrderDetailsController>(),
      'productOverviewController':
          Get.isRegistered<VCartProductOverviewController>(),
      'profileController': Get.isRegistered<VCartProfileController>(),
      'searchController': Get.isRegistered<VCartSearchController>(),
      'filterController': Get.isRegistered<VCartFilterPageController>(),
      'productListingController':
          Get.isRegistered<VCartProductListingController>(),
      'sectionCategoryController':
          Get.isRegistered<VCartSectionCategoryController>(),
      'wishlistController': Get.isRegistered<VCartWishlistController>(),
    };
  }

  /// Force reinitialize (use with caution)
  static Future<void> forceReinitialize() async {
    _isInitialized = false;
    _isInitializing = false;
    _lastError = null;
    await init();
  }

  /// Reset specific controller (useful for page refreshes)
  static void resetController<T>() {
    if (Get.isRegistered<T>()) {
      debugPrint('🔄 Resetting controller $T');
      Get.delete<T>();
    }
  }

  /// Clear all VCart dependencies (use with extreme caution)
  static void clearAll() {
    debugPrint('🧹 Clearing all VCart dependencies');

    // Reset state
    _isInitialized = false;
    _isInitializing = false;
    _lastError = null;

    // Note: In practice, you might want to preserve some critical dependencies
    // like the navigation controller
  }
}

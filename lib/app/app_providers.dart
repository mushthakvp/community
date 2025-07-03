import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../core/network/network_info.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/coupons/data/repositories/coupon_repository_impl.dart';
import '../features/coupons/presentation/providers/coupon_provider.dart';
import '../features/home/data/repositories/home_repository_impl.dart';
import '../features/home/domain/usecases/get_notifications_usecase.dart';
import '../features/home/domain/usecases/get_user_details_usecase.dart';
import '../features/home/presentation/providers/home_provider.dart';
import '../features/profile/data/datasources/profile_local_datasource.dart';
import '../features/profile/data/datasources/profile_remote_datasource.dart';
import '../features/profile/data/repositories/profile_repository_impl.dart';
import '../features/profile/domain/usecases/change_password_usecase.dart';
import '../features/profile/domain/usecases/claim_loyalty_points_usecase.dart';
import '../features/profile/domain/usecases/get_loyalty_card_usecase.dart';
import '../features/profile/domain/usecases/get_point_transactions_usecase.dart';
import '../features/profile/domain/usecases/get_profile_usecase.dart';
import '../features/profile/domain/usecases/update_profile_usecase.dart';
import '../features/profile/presentation/providers/profile_provider.dart';
import '../features/promos/data/datasources/promos_remote_datasource.dart';
import '../features/promos/data/repositories/promos_repository_impl.dart';
import '../features/promos/domain/usecases/add_reward_points_usecase.dart';
import '../features/promos/domain/usecases/get_promos_usecase.dart';
import '../features/promos/domain/usecases/launch_url_usecase.dart';
import '../features/promos/presentation/providers/promos_provider.dart';
import '../features/redemption/data/datasources/redemption_local_datasource.dart';
import '../features/redemption/data/datasources/redemption_remote_datasource.dart';
import '../features/redemption/data/repositories/redemption_repository_impl.dart';
import '../features/redemption/domain/usecases/get_user_redemption_details_usecase.dart';
import '../features/redemption/domain/usecases/get_wallet_transactions_usecase.dart';
import '../features/redemption/domain/usecases/initiate_tier_upgrade_usecase.dart';
import '../features/redemption/domain/usecases/initiate_wallet_recharge_usecase.dart';
import '../features/redemption/domain/usecases/verify_payment_usecase.dart';
import '../features/redemption/presentation/providers/redemption_provider.dart';
import '../features/redemption/presentation/providers/wallet_recharge_provider.dart';
import '../features/splash/presentation/providers/splash_provider.dart';
// Vizzle Ads Listing Providers
import '../features/vizzle/ads_listing/data/datasources/ads_local_data_source.dart';
import '../features/vizzle/ads_listing/data/datasources/ads_remote_data_source.dart';
import '../features/vizzle/ads_listing/data/repositories/ads_repository_impl.dart';
import '../features/vizzle/ads_listing/domain/repositories/ads_repository.dart';
import '../features/vizzle/ads_listing/domain/usecases/get_ad_details_usecase.dart';
import '../features/vizzle/ads_listing/domain/usecases/get_ads_usecase.dart'
    as ads_uc;
import '../features/vizzle/ads_listing/domain/usecases/get_filter_options_usecase.dart';
import '../features/vizzle/ads_listing/domain/usecases/toggle_favorite_usecase.dart'
    as ads_toggle;
import '../features/vizzle/ads_listing/presentation/providers/ads_listing_provider.dart';
// Vizzle Core Providers
import '../features/vizzle/data/datasources/vizzle_local_data_source.dart';
import '../features/vizzle/data/datasources/vizzle_remote_data_source.dart';
import '../features/vizzle/data/repositories/vizzle_repository_impl.dart';
import '../features/vizzle/domain/usecases/get_categories_usecase.dart'
    as vizzle_core;
import '../features/vizzle/domain/usecases/get_sub_categories_usecase.dart';
import '../features/vizzle/domain/usecases/get_sub_items_usecase.dart';
import '../features/vizzle/domain/usecases/get_sub_sub_categories_usecase.dart';
import '../features/vizzle/domain/usecases/get_vizzle_home_usecase.dart';
import '../features/vizzle/home/presentation/providers/vizzle_home_provider.dart';
import '../features/vizzle/place_add/data/datasources/place_add_remote_datasource.dart';
import '../features/vizzle/place_add/data/repositories/place_add_repository_impl.dart';
import '../features/vizzle/place_add/domain/usecases/create_ad_usecase.dart';
import '../features/vizzle/place_add/domain/usecases/get_categories_usecase.dart'
    as place_add;
import '../features/vizzle/place_add/domain/usecases/get_cities_usecase.dart';
import '../features/vizzle/place_add/domain/usecases/upload_images_usecase.dart';
import '../features/vizzle/place_add/presentation/providers/place_add_provider.dart';
import '../features/vizzle/product_detail/data/datasources/product_detail_remote_datasource.dart';
import '../features/vizzle/product_detail/data/repositories/product_detail_repository_impl.dart';
import '../features/vizzle/product_detail/domain/usecases/access_chat_usecase.dart';
import '../features/vizzle/product_detail/domain/usecases/get_product_detail_usecase.dart';
import '../features/vizzle/product_detail/domain/usecases/report_product_usecase.dart';
import '../features/vizzle/product_detail/domain/usecases/share_product_usecase.dart';
import '../features/vizzle/product_detail/domain/usecases/toggle_favorite_usecase.dart';
import '../features/vizzle/product_detail/presentation/providers/product_detail_provider.dart';
import '../features/vizzle/recently_viewed/data/datasources/recently_viewed_local_datasource.dart';
import '../features/vizzle/recently_viewed/data/datasources/recently_viewed_remote_datasource.dart';
import '../features/vizzle/recently_viewed/data/repositories/recently_viewed_repository_impl.dart';
import '../features/vizzle/recently_viewed/domain/repositories/recently_viewed_repository.dart';
import '../features/vizzle/recently_viewed/domain/usecases/clear_recently_viewed_cache_usecase.dart';
import '../features/vizzle/recently_viewed/domain/usecases/clear_recently_viewed_usecase.dart';
import '../features/vizzle/recently_viewed/domain/usecases/get_recently_viewed_ads_usecase.dart';
import '../features/vizzle/recently_viewed/domain/usecases/toggle_recently_viewed_favorite_usecase.dart';
import '../features/vizzle/recently_viewed/presentation/providers/recently_viewed_provider.dart';
// Vizzle Saved View Providers
import '../features/vizzle/saved_view/data/datasources/saved_ads_local_datasource.dart';
import '../features/vizzle/saved_view/data/datasources/saved_ads_remote_datasource.dart';
import '../features/vizzle/saved_view/data/repositories/saved_ads_repository_impl.dart';
import '../features/vizzle/saved_view/domain/repositories/saved_ads_repository.dart';
import '../features/vizzle/saved_view/domain/usecases/clear_saved_cache_usecase.dart';
import '../features/vizzle/saved_view/domain/usecases/get_saved_ads_usecase.dart';
import '../features/vizzle/saved_view/domain/usecases/toggle_saved_favorite_usecase.dart';
import '../features/vizzle/saved_view/presentation/providers/saved_ads_provider.dart';
// Vizzle Search Providers
import '../features/vizzle/search/data/datasources/search_remote_datasource.dart';
import '../features/vizzle/search/data/repositories/search_repository_impl.dart';
import '../features/vizzle/search/domain/usecases/search_ads_usecase.dart';
import '../features/vizzle/search/presentation/providers/search_provider.dart';
// Vizzle Seller Details Providers
import '../features/vizzle/seller_details/data/datasources/seller_remote_datasource.dart';
import '../features/vizzle/seller_details/data/repositories/seller_repository_impl.dart';
import '../features/vizzle/seller_details/domain/usecases/get_seller_profile_usecase.dart';
import '../features/vizzle/seller_details/presentation/providers/seller_details_provider.dart';
import '../features/vizzle/sub_category_listing/presentation/providers/sub_category_listing_provider.dart';
import '../features/vizzle/sub_items_view/presentation/providers/sub_items_provider.dart';
import '../features/vizzle/sub_sub_category_list_view/presentation/providers/sub_sub_category_provider.dart';

class AppProviders {
  static List<SingleChildWidget> providers = [
    // ========================================
    // CORE PROVIDERS
    // ========================================

    // Splash Provider
    ChangeNotifierProvider<SplashProvider>(create: (_) => SplashProvider()),

    // Network Providers
    Provider<Connectivity>(create: (_) => Connectivity()),
    ProxyProvider<Connectivity, NetworkInfo>(
      update: (_, connectivity, __) => NetworkInfoImpl(connectivity),
    ),
    ProxyProvider<NetworkInfo, ApiClient>(
      update: (_, networkInfo, __) =>
          ApiClient(baseUrl: ApiConstants.baseUrl, networkInfo: networkInfo),
    ),

    // ========================================
    // AUTH PROVIDERS
    // ========================================
    ChangeNotifierProvider<AuthProvider>(
      create: (context) => AuthProvider(
        repository: AuthRepositoryImpl(apiClient: context.read<ApiClient>()),
      ),
    ),

    // ========================================
    // HOME PROVIDERS
    // ========================================
    ProxyProvider<ApiClient, HomeRepositoryImpl>(
      update: (_, apiClient, __) => HomeRepositoryImpl(apiClient: apiClient),
    ),
    ProxyProvider<HomeRepositoryImpl, GetUserDetailsUseCase>(
      update: (_, repository, __) => GetUserDetailsUseCase(repository),
    ),
    ProxyProvider<HomeRepositoryImpl, GetNotificationsUseCase>(
      update: (_, repository, __) => GetNotificationsUseCase(repository),
    ),
    ChangeNotifierProxyProvider2<
      GetUserDetailsUseCase,
      GetNotificationsUseCase,
      HomeProvider
    >(
      create: (context) => HomeProvider(
        getUserDetailsUseCase: context.read<GetUserDetailsUseCase>(),
      ),
      update: (_, getUserDetailsUseCase, getNotificationsUseCase, previous) =>
          previous ??
          HomeProvider(getUserDetailsUseCase: getUserDetailsUseCase),
    ),

    // ========================================
    // PROFILE PROVIDERS
    // ========================================
    ProxyProvider<ApiClient, ProfileRemoteDataSource>(
      update: (_, apiClient, __) =>
          ProfileRemoteDataSourceImpl(client: apiClient),
    ),
    Provider<ProfileLocalDataSource>(
      create: (_) => ProfileLocalDataSourceImpl(),
    ),
    ProxyProvider2<
      ProfileRemoteDataSource,
      ProfileLocalDataSource,
      ProfileRepositoryImpl
    >(
      update: (_, remoteDataSource, localDataSource, __) =>
          ProfileRepositoryImpl(
            remoteDataSource: remoteDataSource,
            localDataSource: localDataSource,
          ),
    ),

    // Profile Use Cases
    ProxyProvider<ProfileRepositoryImpl, GetProfileUseCase>(
      update: (_, repository, __) => GetProfileUseCase(repository),
    ),
    ProxyProvider<ProfileRepositoryImpl, UpdateProfileUseCase>(
      update: (_, repository, __) => UpdateProfileUseCase(repository),
    ),
    ProxyProvider<ProfileRepositoryImpl, ChangePasswordUseCase>(
      update: (_, repository, __) => ChangePasswordUseCase(repository),
    ),
    ProxyProvider<ProfileRepositoryImpl, GetLoyaltyCardUseCase>(
      update: (_, repository, __) => GetLoyaltyCardUseCase(repository),
    ),
    ProxyProvider<ProfileRepositoryImpl, ClaimLoyaltyPointsUseCase>(
      update: (_, repository, __) => ClaimLoyaltyPointsUseCase(repository),
    ),
    ProxyProvider<ProfileRepositoryImpl, GetPointTransactionsUseCase>(
      update: (_, repository, __) => GetPointTransactionsUseCase(repository),
    ),

    // Profile Provider
    ChangeNotifierProxyProvider6<
      GetProfileUseCase,
      UpdateProfileUseCase,
      ChangePasswordUseCase,
      GetLoyaltyCardUseCase,
      ClaimLoyaltyPointsUseCase,
      GetPointTransactionsUseCase,
      ProfileProvider
    >(
      create: (context) => ProfileProvider(
        getProfileUseCase: context.read<GetProfileUseCase>(),
        updateProfileUseCase: context.read<UpdateProfileUseCase>(),
        changePasswordUseCase: context.read<ChangePasswordUseCase>(),
        getLoyaltyCardUseCase: context.read<GetLoyaltyCardUseCase>(),
        claimLoyaltyPointsUseCase: context.read<ClaimLoyaltyPointsUseCase>(),
        getPointTransactionsUseCase: context
            .read<GetPointTransactionsUseCase>(),
      ),
      update:
          (
            _,
            getProfileUseCase,
            updateProfileUseCase,
            changePasswordUseCase,
            getLoyaltyCardUseCase,
            claimLoyaltyPointsUseCase,
            getPointTransactionsUseCase,
            previous,
          ) =>
              previous ??
              ProfileProvider(
                getProfileUseCase: getProfileUseCase,
                updateProfileUseCase: updateProfileUseCase,
                changePasswordUseCase: changePasswordUseCase,
                getLoyaltyCardUseCase: getLoyaltyCardUseCase,
                claimLoyaltyPointsUseCase: claimLoyaltyPointsUseCase,
                getPointTransactionsUseCase: getPointTransactionsUseCase,
              ),
    ),

    // ========================================
    // COUPON & PROMOS PROVIDERS
    // ========================================
    ChangeNotifierProvider<CouponProvider>(
      create: (context) => CouponProvider(
        repository: CouponRepositoryImpl(apiClient: context.read<ApiClient>()),
      ),
    ),

    ChangeNotifierProvider<PromosProvider>(
      create: (context) {
        final apiClient = context.read<ApiClient>();
        final remoteDataSource = PromosRemoteDataSourceImpl(client: apiClient);
        final repository = PromosRepositoryImpl(
          remoteDataSource: remoteDataSource,
        );
        return PromosProvider(
          getPromosUseCase: GetPromosUseCase(repository),
          addRewardPointsUseCase: AddRewardPointsUseCase(repository),
          launchUrlUseCase: LaunchUrlUseCase(),
        );
      },
    ),

    // ========================================
    // REDEMPTION PROVIDERS
    // ========================================
    ProxyProvider<ApiClient, RedemptionRemoteDataSource>(
      update: (_, apiClient, __) =>
          RedemptionRemoteDataSourceImpl(client: apiClient),
    ),
    Provider<RedemptionLocalDataSource>(
      create: (_) => RedemptionLocalDataSourceImpl(),
    ),
    ProxyProvider2<
      RedemptionRemoteDataSource,
      RedemptionLocalDataSource,
      RedemptionRepositoryImpl
    >(
      update: (_, remoteDataSource, localDataSource, __) =>
          RedemptionRepositoryImpl(
            remoteDataSource: remoteDataSource,
            localDataSource: localDataSource,
          ),
    ),

    // Redemption Use Cases
    ProxyProvider<RedemptionRepositoryImpl, GetWalletTransactionsUseCase>(
      update: (_, repository, __) => GetWalletTransactionsUseCase(repository),
    ),
    ProxyProvider<RedemptionRepositoryImpl, GetUserRedemptionDetailsUseCase>(
      update: (_, repository, __) =>
          GetUserRedemptionDetailsUseCase(repository),
    ),
    ProxyProvider<RedemptionRepositoryImpl, InitiateWalletRechargeUseCase>(
      update: (_, repository, __) => InitiateWalletRechargeUseCase(repository),
    ),
    ProxyProvider<RedemptionRepositoryImpl, InitiateTierUpgradeUseCase>(
      update: (_, repository, __) => InitiateTierUpgradeUseCase(repository),
    ),
    ProxyProvider<RedemptionRepositoryImpl, VerifyPaymentUseCase>(
      update: (_, repository, __) => VerifyPaymentUseCase(repository),
    ),

    // Redemption Providers
    ChangeNotifierProxyProvider2<
      GetWalletTransactionsUseCase,
      GetUserRedemptionDetailsUseCase,
      RedemptionProvider
    >(
      create: (context) => RedemptionProvider(
        getWalletTransactionsUseCase: context
            .read<GetWalletTransactionsUseCase>(),
        getUserRedemptionDetailsUseCase: context
            .read<GetUserRedemptionDetailsUseCase>(),
      ),
      update:
          (
            _,
            getWalletTransactionsUseCase,
            getUserRedemptionDetailsUseCase,
            previous,
          ) =>
              previous ??
              RedemptionProvider(
                getWalletTransactionsUseCase: getWalletTransactionsUseCase,
                getUserRedemptionDetailsUseCase:
                    getUserRedemptionDetailsUseCase,
              ),
    ),

    ChangeNotifierProxyProvider3<
      InitiateWalletRechargeUseCase,
      InitiateTierUpgradeUseCase,
      VerifyPaymentUseCase,
      WalletRechargeProvider
    >(
      create: (context) {
        final provider = WalletRechargeProvider(
          initiateWalletRechargeUseCase: context
              .read<InitiateWalletRechargeUseCase>(),
          initiateTierUpgradeUseCase: context
              .read<InitiateTierUpgradeUseCase>(),
          verifyPaymentUseCase: context.read<VerifyPaymentUseCase>(),
        );
        provider.initializeRazorpay();
        return provider;
      },
      update:
          (
            _,
            initiateWalletRechargeUseCase,
            initiateTierUpgradeUseCase,
            verifyPaymentUseCase,
            previous,
          ) =>
              previous ??
              WalletRechargeProvider(
                initiateWalletRechargeUseCase: initiateWalletRechargeUseCase,
                initiateTierUpgradeUseCase: initiateTierUpgradeUseCase,
                verifyPaymentUseCase: verifyPaymentUseCase,
              ),
    ),

    // ========================================
    // VIZZLE CORE PROVIDERS
    // ========================================

    // Vizzle Data Sources
    ProxyProvider<ApiClient, VizzleRemoteDataSource>(
      update: (_, apiClient, __) =>
          VizzleRemoteDataSourceImpl(apiClient: apiClient),
    ),
    Provider<VizzleLocalDataSource>(create: (_) => VizzleLocalDataSourceImpl()),

    // Vizzle Repository
    ProxyProvider3<
      VizzleRemoteDataSource,
      VizzleLocalDataSource,
      NetworkInfo,
      VizzleRepositoryImpl
    >(
      update: (_, remoteDataSource, localDataSource, networkInfo, __) =>
          VizzleRepositoryImpl(
            remoteDataSource: remoteDataSource,
            localDataSource: localDataSource,
            networkInfo: networkInfo,
          ),
    ),

    // Vizzle Use Cases
    ProxyProvider<VizzleRepositoryImpl, GetVizzleHomeUseCase>(
      update: (_, repository, __) => GetVizzleHomeUseCase(repository),
    ),
    ProxyProvider<VizzleRepositoryImpl, vizzle_core.GetCategoriesUseCase>(
      update: (_, repository, __) =>
          vizzle_core.GetCategoriesUseCase(repository),
    ),
    ProxyProvider<VizzleRepositoryImpl, GetSubCategoriesUseCase>(
      update: (_, repository, __) => GetSubCategoriesUseCase(repository),
    ),
    ProxyProvider<VizzleRepositoryImpl, GetSubSubCategoriesUseCase>(
      update: (_, repository, __) => GetSubSubCategoriesUseCase(repository),
    ),
    ProxyProvider<VizzleRepositoryImpl, GetSubItemsUseCase>(
      update: (_, repository, __) => GetSubItemsUseCase(repository),
    ),

    // Vizzle Providers
    ChangeNotifierProxyProvider<GetVizzleHomeUseCase, VizzleHomeProvider>(
      create: (context) => VizzleHomeProvider(
        getVizzleHomeUseCase: context.read<GetVizzleHomeUseCase>(),
      ),
      update: (_, getVizzleHomeUseCase, previous) =>
          previous ??
          VizzleHomeProvider(getVizzleHomeUseCase: getVizzleHomeUseCase),
    ),

    ChangeNotifierProxyProvider2<
      vizzle_core.GetCategoriesUseCase,
      GetSubCategoriesUseCase,
      SubCategoryListingProvider
    >(
      create: (context) => SubCategoryListingProvider(
        getCategoriesUseCase: context.read<vizzle_core.GetCategoriesUseCase>(),
        getSubCategoriesUseCase: context.read<GetSubCategoriesUseCase>(),
      ),
      update: (_, getCategoriesUseCase, getSubCategoriesUseCase, previous) =>
          previous ??
          SubCategoryListingProvider(
            getCategoriesUseCase: getCategoriesUseCase,
            getSubCategoriesUseCase: getSubCategoriesUseCase,
          ),
    ),

    ChangeNotifierProxyProvider<
      GetSubSubCategoriesUseCase,
      SubSubCategoryProvider
    >(
      create: (context) => SubSubCategoryProvider(
        getSubSubCategoriesUseCase: context.read<GetSubSubCategoriesUseCase>(),
      ),
      update: (_, getSubSubCategoriesUseCase, previous) =>
          previous ??
          SubSubCategoryProvider(
            getSubSubCategoriesUseCase: getSubSubCategoriesUseCase,
          ),
    ),

    ChangeNotifierProxyProvider<GetSubItemsUseCase, SubItemsProvider>(
      create: (context) => SubItemsProvider(
        getSubItemsUseCase: context.read<GetSubItemsUseCase>(),
      ),
      update: (_, getSubItemsUseCase, previous) =>
          previous ?? SubItemsProvider(getSubItemsUseCase: getSubItemsUseCase),
    ),

    // ========================================
    // VIZZLE ADS LISTING PROVIDERS
    // ========================================

    // Ads Data Sources
    ProxyProvider<ApiClient, AdsRemoteDataSource>(
      update: (_, apiClient, __) =>
          AdsRemoteDataSourceImpl(apiClient: apiClient),
    ),
    Provider<AdsLocalDataSource>(create: (_) => AdsLocalDataSourceImpl()),

    // Ads Repository
    ProxyProvider3<
      AdsRemoteDataSource,
      AdsLocalDataSource,
      NetworkInfo,
      AdsRepository
    >(
      update: (_, remoteDataSource, localDataSource, networkInfo, __) =>
          AdsRepositoryImpl(
            remoteDataSource: remoteDataSource,
            localDataSource: localDataSource,
            networkInfo: networkInfo,
          ),
    ),

    // Ads Use Cases
    ProxyProvider<AdsRepository, ads_uc.GetAdsUseCase>(
      update: (_, repository, __) => ads_uc.GetAdsUseCase(repository),
    ),
    ProxyProvider<AdsRepository, GetAdDetailsUseCase>(
      update: (_, repository, __) => GetAdDetailsUseCase(repository),
    ),
    ProxyProvider<AdsRepository, GetFilterOptionsUseCase>(
      update: (_, repository, __) => GetFilterOptionsUseCase(repository),
    ),
    ProxyProvider<AdsRepository, ads_toggle.ToggleFavoriteUseCase>(
      update: (_, repository, __) =>
          ads_toggle.ToggleFavoriteUseCase(repository),
    ),

    // Ads Provider
    ChangeNotifierProxyProvider3<
      ads_uc.GetAdsUseCase,
      GetFilterOptionsUseCase,
      ads_toggle.ToggleFavoriteUseCase,
      AdsListingProvider
    >(
      create: (context) => AdsListingProvider(
        getAdsUseCase: context.read<ads_uc.GetAdsUseCase>(),
        getFilterOptionsUseCase: context.read<GetFilterOptionsUseCase>(),
        toggleFavoriteUseCase: context.read<ads_toggle.ToggleFavoriteUseCase>(),
      ),
      update:
          (
            _,
            getAdsUseCase,
            getFilterOptionsUseCase,
            toggleFavoriteUseCase,
            previous,
          ) =>
              previous ??
              AdsListingProvider(
                getAdsUseCase: getAdsUseCase,
                getFilterOptionsUseCase: getFilterOptionsUseCase,
                toggleFavoriteUseCase: toggleFavoriteUseCase,
              ),
    ),

    // ========================================
    // VIZZLE SEARCH PROVIDERS
    // ========================================
    ProxyProvider<ApiClient, SearchRemoteDataSource>(
      update: (_, apiClient, __) =>
          SearchRemoteDataSourceImpl(apiClient: apiClient),
    ),
    ProxyProvider2<SearchRemoteDataSource, NetworkInfo, SearchRepositoryImpl>(
      update: (_, remoteDataSource, networkInfo, __) => SearchRepositoryImpl(
        remoteDataSource: remoteDataSource,
        networkInfo: networkInfo,
      ),
    ),
    ProxyProvider<SearchRepositoryImpl, SearchAdsUseCase>(
      update: (_, repository, __) => SearchAdsUseCase(repository),
    ),
    ChangeNotifierProxyProvider<SearchAdsUseCase, SearchProvider>(
      create: (context) =>
          SearchProvider(searchAdsUseCase: context.read<SearchAdsUseCase>()),
      update: (_, searchAdsUseCase, previous) =>
          previous ?? SearchProvider(searchAdsUseCase: searchAdsUseCase),
    ),

    // ========================================
    // VIZZLE SELLER DETAILS PROVIDERS
    // ========================================
    ProxyProvider<ApiClient, SellerRemoteDataSource>(
      update: (_, apiClient, __) =>
          SellerRemoteDataSourceImpl(apiClient: apiClient),
    ),
    ProxyProvider2<SellerRemoteDataSource, NetworkInfo, SellerRepositoryImpl>(
      update: (_, remoteDataSource, networkInfo, __) => SellerRepositoryImpl(
        remoteDataSource: remoteDataSource,
        networkInfo: networkInfo,
      ),
    ),
    ProxyProvider<SellerRepositoryImpl, GetSellerProfileUseCase>(
      update: (_, repository, __) => GetSellerProfileUseCase(repository),
    ),
    ChangeNotifierProxyProvider<GetSellerProfileUseCase, SellerDetailsProvider>(
      create: (context) => SellerDetailsProvider(
        getSellerProfileUseCase: context.read<GetSellerProfileUseCase>(),
      ),
      update: (_, getSellerProfileUseCase, previous) =>
          previous ??
          SellerDetailsProvider(
            getSellerProfileUseCase: getSellerProfileUseCase,
          ),
    ),

    // ========================================
    // VIZZLE SAVED ADS PROVIDERS (FIXED)
    // ========================================

    // Saved Ads Data Sources
    ProxyProvider<ApiClient, SavedAdsRemoteDataSource>(
      update: (_, apiClient, __) =>
          SavedAdsRemoteDataSourceImpl(apiClient: apiClient),
    ),
    Provider<SavedAdsLocalDataSource>(
      create: (_) => SavedAdsLocalDataSourceImpl(),
    ),

    // Saved Ads Repository
    ProxyProvider3<
      SavedAdsRemoteDataSource,
      SavedAdsLocalDataSource,
      NetworkInfo,
      SavedAdsRepository
    >(
      update: (_, remoteDataSource, localDataSource, networkInfo, __) =>
          SavedAdsRepositoryImpl(
            remoteDataSource: remoteDataSource,
            localDataSource: localDataSource,
            networkInfo: networkInfo,
          ),
    ),

    // Saved Ads Use Cases
    ProxyProvider<SavedAdsRepository, GetSavedAdsUseCase>(
      update: (_, repository, __) => GetSavedAdsUseCase(repository),
    ),
    ProxyProvider<SavedAdsRepository, ToggleSavedFavoriteUseCase>(
      update: (_, repository, __) => ToggleSavedFavoriteUseCase(repository),
    ),
    ProxyProvider<SavedAdsRepository, ClearSavedCacheUseCase>(
      update: (_, repository, __) => ClearSavedCacheUseCase(repository),
    ),

    // Saved Ads Provider
    ChangeNotifierProxyProvider3<
      GetSavedAdsUseCase,
      ToggleSavedFavoriteUseCase,
      ClearSavedCacheUseCase,
      SavedAdsProvider
    >(
      create: (context) => SavedAdsProvider(
        getSavedAdsUseCase: context.read<GetSavedAdsUseCase>(),
        toggleSavedFavoriteUseCase: context.read<ToggleSavedFavoriteUseCase>(),
        clearSavedCacheUseCase: context.read<ClearSavedCacheUseCase>(),
      ),
      update:
          (
            _,
            getSavedAdsUseCase,
            toggleSavedFavoriteUseCase,
            clearSavedCacheUseCase,
            previous,
          ) =>
              previous ??
              SavedAdsProvider(
                getSavedAdsUseCase: getSavedAdsUseCase,
                toggleSavedFavoriteUseCase: toggleSavedFavoriteUseCase,
                clearSavedCacheUseCase: clearSavedCacheUseCase,
              ),
    ),

    // ========================================
    // VIZZLE RECENTLY VIEWED PROVIDERS
    // ========================================

    // Recently Viewed Data Sources
    ProxyProvider<ApiClient, RecentlyViewedRemoteDataSource>(
      update: (_, apiClient, __) =>
          RecentlyViewedRemoteDataSourceImpl(apiClient: apiClient),
    ),
    Provider<RecentlyViewedLocalDataSource>(
      create: (_) => RecentlyViewedLocalDataSourceImpl(),
    ),

    // Recently Viewed Repository
    ProxyProvider3<
      RecentlyViewedRemoteDataSource,
      RecentlyViewedLocalDataSource,
      NetworkInfo,
      RecentlyViewedRepository
    >(
      update: (_, remoteDataSource, localDataSource, networkInfo, __) =>
          RecentlyViewedRepositoryImpl(
            remoteDataSource: remoteDataSource,
            localDataSource: localDataSource,
            networkInfo: networkInfo,
          ),
    ),

    // Recently Viewed Use Cases
    ProxyProvider<RecentlyViewedRepository, GetRecentlyViewedAdsUseCase>(
      update: (_, repository, __) => GetRecentlyViewedAdsUseCase(repository),
    ),
    ProxyProvider<
      RecentlyViewedRepository,
      ToggleRecentlyViewedFavoriteUseCase
    >(
      update: (_, repository, __) =>
          ToggleRecentlyViewedFavoriteUseCase(repository),
    ),
    ProxyProvider<RecentlyViewedRepository, ClearRecentlyViewedUseCase>(
      update: (_, repository, __) => ClearRecentlyViewedUseCase(repository),
    ),
    ProxyProvider<RecentlyViewedRepository, ClearRecentlyViewedCacheUseCase>(
      update: (_, repository, __) =>
          ClearRecentlyViewedCacheUseCase(repository),
    ),

    // Recently Viewed Provider
    ChangeNotifierProxyProvider4<
      GetRecentlyViewedAdsUseCase,
      ToggleRecentlyViewedFavoriteUseCase,
      ClearRecentlyViewedUseCase,
      ClearRecentlyViewedCacheUseCase,
      RecentlyViewedProvider
    >(
      create: (context) => RecentlyViewedProvider(
        getRecentlyViewedAdsUseCase: context
            .read<GetRecentlyViewedAdsUseCase>(),
        toggleFavoriteUseCase: context
            .read<ToggleRecentlyViewedFavoriteUseCase>(),
        clearRecentlyViewedUseCase: context.read<ClearRecentlyViewedUseCase>(),
        clearCacheUseCase: context.read<ClearRecentlyViewedCacheUseCase>(),
      ),
      update:
          (
            _,
            getRecentlyViewedAdsUseCase,
            toggleFavoriteUseCase,
            clearRecentlyViewedUseCase,
            clearCacheUseCase,
            previous,
          ) =>
              previous ??
              RecentlyViewedProvider(
                getRecentlyViewedAdsUseCase: getRecentlyViewedAdsUseCase,
                toggleFavoriteUseCase: toggleFavoriteUseCase,
                clearRecentlyViewedUseCase: clearRecentlyViewedUseCase,
                clearCacheUseCase: clearCacheUseCase,
              ),
    ),

    // ========================================
    // VIZZLE PLACE ADD PROVIDERS
    // ========================================

    // Place Add Data Sources
    ProxyProvider<ApiClient, PlaceAddRemoteDataSource>(
      update: (_, apiClient, __) =>
          PlaceAddRemoteDataSourceImpl(apiClient: apiClient),
    ),

    // Place Add Repository
    ProxyProvider2<
      PlaceAddRemoteDataSource,
      NetworkInfo,
      PlaceAddRepositoryImpl
    >(
      update: (_, remoteDataSource, networkInfo, __) => PlaceAddRepositoryImpl(
        remoteDataSource: remoteDataSource,
        networkInfo: networkInfo,
      ),
    ),

    // Place Add Use Cases
    ProxyProvider<PlaceAddRepositoryImpl, GetCitiesUseCase>(
      update: (_, repository, __) => GetCitiesUseCase(repository),
    ),
    ProxyProvider<PlaceAddRepositoryImpl, place_add.GetCategoriesUseCase>(
      update: (_, repository, __) => place_add.GetCategoriesUseCase(repository),
    ),
    ProxyProvider<PlaceAddRepositoryImpl, CreateAdUseCase>(
      update: (_, repository, __) => CreateAdUseCase(repository),
    ),
    ProxyProvider<PlaceAddRepositoryImpl, UploadImagesUseCase>(
      update: (_, repository, __) => UploadImagesUseCase(repository),
    ),

    // Place Add Provider
    ChangeNotifierProxyProvider4<
      GetCitiesUseCase,
      place_add.GetCategoriesUseCase,
      CreateAdUseCase,
      UploadImagesUseCase,
      PlaceAddProvider
    >(
      create: (context) => PlaceAddProvider(
        getCitiesUseCase: context.read<GetCitiesUseCase>(),
        getCategoriesUseCase: context.read<place_add.GetCategoriesUseCase>(),
        createAdUseCase: context.read<CreateAdUseCase>(),
        uploadImagesUseCase: context.read<UploadImagesUseCase>(),
      ),
      update:
          (
            _,
            getCitiesUseCase,
            getCategoriesUseCase,
            createAdUseCase,
            uploadImagesUseCase,
            previous,
          ) =>
              previous ??
              PlaceAddProvider(
                getCitiesUseCase: getCitiesUseCase,
                getCategoriesUseCase: getCategoriesUseCase,
                createAdUseCase: createAdUseCase,
                uploadImagesUseCase: uploadImagesUseCase,
              ),
    ),

    // ========================================
    // VIZZLE PRODUCT DETAIL PROVIDERS
    // ========================================

    // Product Detail Data Sources
    ProxyProvider<ApiClient, ProductDetailRemoteDataSource>(
      update: (_, apiClient, __) =>
          ProductDetailRemoteDataSourceImpl(apiClient: apiClient),
    ),

    // Product Detail Repository
    ProxyProvider2<
      ProductDetailRemoteDataSource,
      NetworkInfo,
      ProductDetailRepositoryImpl
    >(
      update: (_, remoteDataSource, networkInfo, __) =>
          ProductDetailRepositoryImpl(
            remoteDataSource: remoteDataSource,
            networkInfo: networkInfo,
          ),
    ),

    // Product Detail Use Cases
    ProxyProvider<ProductDetailRepositoryImpl, GetProductDetailUseCase>(
      update: (_, repository, __) => GetProductDetailUseCase(repository),
    ),
    ProxyProvider<ProductDetailRepositoryImpl, ToggleFavoriteUseCase>(
      update: (_, repository, __) => ToggleFavoriteUseCase(repository),
    ),
    ProxyProvider<ProductDetailRepositoryImpl, ShareProductUseCase>(
      update: (_, repository, __) => ShareProductUseCase(repository),
    ),
    ProxyProvider<ProductDetailRepositoryImpl, ReportProductUseCase>(
      update: (_, repository, __) => ReportProductUseCase(repository),
    ),
    ProxyProvider<ProductDetailRepositoryImpl, AccessChatUseCase>(
      update: (_, repository, __) => AccessChatUseCase(repository),
    ),

    // Product Detail Provider
    ChangeNotifierProxyProvider5<
      GetProductDetailUseCase,
      ToggleFavoriteUseCase,
      ShareProductUseCase,
      ReportProductUseCase,
      AccessChatUseCase,
      ProductDetailProvider
    >(
      create: (context) => ProductDetailProvider(
        getProductDetailUseCase: context.read<GetProductDetailUseCase>(),
        toggleFavoriteUseCase: context.read<ToggleFavoriteUseCase>(),
        shareProductUseCase: context.read<ShareProductUseCase>(),
        reportProductUseCase: context.read<ReportProductUseCase>(),
        accessChatUseCase: context.read<AccessChatUseCase>(),
      ),
      update:
          (
            _,
            getProductDetailUseCase,
            toggleFavoriteUseCase,
            shareProductUseCase,
            reportProductUseCase,
            accessChatUseCase,
            previous,
          ) =>
              previous ??
              ProductDetailProvider(
                getProductDetailUseCase: getProductDetailUseCase,
                toggleFavoriteUseCase: toggleFavoriteUseCase,
                shareProductUseCase: shareProductUseCase,
                reportProductUseCase: reportProductUseCase,
                accessChatUseCase: accessChatUseCase,
              ),
    ),

    // ========================================
    // VIZZLE PROFILE PROVIDERS
    // ========================================
  ];
}

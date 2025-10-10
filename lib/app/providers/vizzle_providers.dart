import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../core/network/api_client.dart';
import '../../core/network/network_info.dart';
import '../../features/vizzle/ads_listing/data/datasources/ads_remote_data_source.dart';
import '../../features/vizzle/ads_listing/data/repositories/ads_repository_impl.dart';
import '../../features/vizzle/ads_listing/domain/repositories/ads_repository.dart';
import '../../features/vizzle/ads_listing/domain/usecases/get_ad_details_usecase.dart';
import '../../features/vizzle/ads_listing/domain/usecases/get_ads_usecase.dart'
    as ads_uc;
import '../../features/vizzle/ads_listing/domain/usecases/get_filter_options_usecase.dart';
import '../../features/vizzle/ads_listing/domain/usecases/toggle_favorite_usecase.dart'
    as ads_toggle;
import '../../features/vizzle/ads_listing/presentation/providers/ads_listing_provider.dart';
// Vizzle Core
import '../../features/vizzle/data/datasources/vizzle_remote_data_source.dart';
import '../../features/vizzle/data/repositories/vizzle_repository_impl.dart';
import '../../features/vizzle/domain/usecases/get_categories_usecase.dart'
    as vizzle_core;
import '../../features/vizzle/domain/usecases/get_sub_categories_usecase.dart';
import '../../features/vizzle/domain/usecases/get_sub_items_usecase.dart';
import '../../features/vizzle/domain/usecases/get_sub_sub_categories_usecase.dart';
import '../../features/vizzle/domain/usecases/get_vizzle_home_usecase.dart';
// Vizzle Edit Ad
import '../../features/vizzle/edit_ad/data/datasources/edit_ad_remote_datasource.dart';
import '../../features/vizzle/edit_ad/data/repositories/edit_ad_repository_impl.dart';
import '../../features/vizzle/edit_ad/domain/repositories/edit_ad_repository.dart';
import '../../features/vizzle/edit_ad/domain/usecases/edit_ad_usecase.dart';
import '../../features/vizzle/edit_ad/domain/usecases/get_ad_details_usecase.dart'
    as edit_ad_get;
import '../../features/vizzle/edit_ad/domain/usecases/upload_ad_images_usecase.dart';
import '../../features/vizzle/edit_ad/presentation/providers/edit_ad_provider.dart';
import '../../features/vizzle/home/presentation/providers/vizzle_home_provider.dart';
// Vizzle Place Add
import '../../features/vizzle/place_add/data/datasources/place_add_remote_datasource.dart';
import '../../features/vizzle/place_add/data/repositories/place_add_repository_impl.dart';
import '../../features/vizzle/place_add/domain/usecases/create_ad_usecase.dart';
import '../../features/vizzle/place_add/domain/usecases/get_categories_usecase.dart'
    as place_add;
import '../../features/vizzle/place_add/domain/usecases/get_cities_usecase.dart';
import '../../features/vizzle/place_add/domain/usecases/upload_images_usecase.dart';
import '../../features/vizzle/place_add/presentation/providers/place_add_provider.dart';
// Vizzle Product Detail
import '../../features/vizzle/product_detail/data/datasources/product_detail_remote_datasource.dart';
import '../../features/vizzle/product_detail/data/repositories/product_detail_repository_impl.dart';
import '../../features/vizzle/product_detail/domain/usecases/access_chat_usecase.dart';
import '../../features/vizzle/product_detail/domain/usecases/get_product_detail_usecase.dart';
import '../../features/vizzle/product_detail/domain/usecases/report_product_usecase.dart';
import '../../features/vizzle/product_detail/domain/usecases/share_product_usecase.dart';
import '../../features/vizzle/product_detail/domain/usecases/toggle_favorite_usecase.dart';
import '../../features/vizzle/product_detail/presentation/providers/product_detail_provider.dart';
// Vizzle Profile
import '../../features/vizzle/profile/data/datasources/profile_local_datasource.dart'
    as vizzle_profile_local;
import '../../features/vizzle/profile/data/datasources/profile_remote_datasource.dart'
    as vizzle_profile_remote;
import '../../features/vizzle/profile/data/repositories/profile_repository_impl.dart'
    as vizzle_profile_repo;
import '../../features/vizzle/profile/domain/repositories/profile_repository.dart'
    as vizzle_profile_interface;
import '../../features/vizzle/profile/domain/usecases/clear_profile_cache_usecase.dart';
import '../../features/vizzle/profile/domain/usecases/delete_ad_usecase.dart';
import '../../features/vizzle/profile/domain/usecases/get_profile_usecase.dart'
    as vizzle_profile_get;
import '../../features/vizzle/profile/domain/usecases/mark_as_sold_usecase.dart';
import '../../features/vizzle/profile/presentation/providers/profile_provider.dart'
    as vizzle_profile_provider;
// Vizzle Recently Viewed
import '../../features/vizzle/recently_viewed/data/datasources/recently_viewed_local_datasource.dart';
import '../../features/vizzle/recently_viewed/data/datasources/recently_viewed_remote_datasource.dart';
import '../../features/vizzle/recently_viewed/data/repositories/recently_viewed_repository_impl.dart';
import '../../features/vizzle/recently_viewed/domain/repositories/recently_viewed_repository.dart';
import '../../features/vizzle/recently_viewed/domain/usecases/clear_recently_viewed_cache_usecase.dart';
import '../../features/vizzle/recently_viewed/domain/usecases/clear_recently_viewed_usecase.dart';
import '../../features/vizzle/recently_viewed/domain/usecases/get_recently_viewed_ads_usecase.dart';
import '../../features/vizzle/recently_viewed/domain/usecases/toggle_recently_viewed_favorite_usecase.dart';
import '../../features/vizzle/recently_viewed/presentation/providers/recently_viewed_provider.dart';
// Vizzle Saved Ads
import '../../features/vizzle/saved_view/data/datasources/saved_ads_local_datasource.dart';
import '../../features/vizzle/saved_view/data/datasources/saved_ads_remote_datasource.dart';
import '../../features/vizzle/saved_view/data/repositories/saved_ads_repository_impl.dart';
import '../../features/vizzle/saved_view/domain/repositories/saved_ads_repository.dart';
import '../../features/vizzle/saved_view/domain/usecases/clear_saved_cache_usecase.dart';
import '../../features/vizzle/saved_view/domain/usecases/get_saved_ads_usecase.dart';
import '../../features/vizzle/saved_view/domain/usecases/toggle_saved_favorite_usecase.dart';
import '../../features/vizzle/saved_view/presentation/providers/saved_ads_provider.dart';
// Vizzle Search
import '../../features/vizzle/search/data/datasources/search_remote_datasource.dart';
import '../../features/vizzle/search/data/repositories/search_repository_impl.dart';
import '../../features/vizzle/search/domain/usecases/search_ads_usecase.dart';
import '../../features/vizzle/search/presentation/providers/search_provider.dart';
// Vizzle Seller Details
import '../../features/vizzle/seller_details/data/datasources/seller_remote_datasource.dart';
import '../../features/vizzle/seller_details/data/repositories/seller_repository_impl.dart';
import '../../features/vizzle/seller_details/domain/usecases/get_seller_profile_usecase.dart';
import '../../features/vizzle/seller_details/presentation/providers/seller_details_provider.dart';
import '../../features/vizzle/sub_category_listing/presentation/providers/sub_category_listing_provider.dart';
import '../../features/vizzle/sub_items_view/presentation/providers/sub_items_provider.dart';
import '../../features/vizzle/sub_sub_category_list_view/presentation/providers/sub_sub_category_provider.dart';

/// Vizzle marketplace feature providers
class VizzleProviders {
  static List<SingleChildWidget> get providers => [
    // ========================================
    // VIZZLE CORE PROVIDERS
    // ========================================

    // Vizzle Data Sources
    ProxyProvider<ApiClient, VizzleRemoteDataSource>(
      update: (_, apiClient, __) =>
          VizzleRemoteDataSourceImpl(apiClient: apiClient),
    ),

    // Vizzle Repository
    ProxyProvider2<VizzleRemoteDataSource, NetworkInfo, VizzleRepositoryImpl>(
      update: (_, remoteDataSource, networkInfo, __) => VizzleRepositoryImpl(
        remoteDataSource: remoteDataSource,
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

    // Ads Repository
    ProxyProvider2<AdsRemoteDataSource, NetworkInfo, AdsRepository>(
      update: (_, remoteDataSource, networkInfo, __) => AdsRepositoryImpl(
        remoteDataSource: remoteDataSource,
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
    // VIZZLE EDIT AD PROVIDERS
    // ========================================

    // Edit Ad Data Sources
    ProxyProvider<ApiClient, EditAdRemoteDataSource>(
      update: (_, apiClient, __) =>
          EditAdRemoteDataSourceImpl(apiClient: apiClient),
    ),

    ProxyProvider2<EditAdRemoteDataSource, NetworkInfo, EditAdRepository>(
      update: (_, remoteDataSource, networkInfo, __) => EditAdRepositoryImpl(
        remoteDataSource: remoteDataSource,
        networkInfo: networkInfo,
      ),
    ),

    // Edit Ad Use Cases
    ProxyProvider<EditAdRepository, edit_ad_get.GetAdDetailsUseCase>(
      update: (_, repository, __) =>
          edit_ad_get.GetAdDetailsUseCase(repository),
    ),
    ProxyProvider<EditAdRepository, EditAdUseCase>(
      update: (_, repository, __) => EditAdUseCase(repository),
    ),
    ProxyProvider<EditAdRepository, UploadAdImagesUseCase>(
      update: (_, repository, __) => UploadAdImagesUseCase(repository),
    ),

    // Edit Ad Provider
    ChangeNotifierProxyProvider3<
      edit_ad_get.GetAdDetailsUseCase,
      EditAdUseCase,
      UploadAdImagesUseCase,
      EditAdProvider
    >(
      create: (context) => EditAdProvider(
        getAdDetailsUseCase: context.read<edit_ad_get.GetAdDetailsUseCase>(),
        editAdUseCase: context.read<EditAdUseCase>(),
        uploadAdImagesUseCase: context.read<UploadAdImagesUseCase>(),
      ),
      update:
          (
            _,
            getAdDetailsUseCase,
            editAdUseCase,
            uploadAdImagesUseCase,
            previous,
          ) =>
              previous ??
              EditAdProvider(
                getAdDetailsUseCase: getAdDetailsUseCase,
                editAdUseCase: editAdUseCase,
                uploadAdImagesUseCase: uploadAdImagesUseCase,
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
    // VIZZLE SAVED ADS PROVIDERS
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
    ProxyProvider2<ApiClient, NetworkInfo, PlaceAddRemoteDataSource>(
      update: (_, apiClient, networkInfo, __) =>
          PlaceAddRemoteDataSourceImpl(
            apiClient: apiClient,
            networkInfo: networkInfo,
          ),
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

    // Vizzle Profile Data Sources
    ProxyProvider<ApiClient, vizzle_profile_remote.ProfileRemoteDataSource>(
      update: (_, apiClient, __) =>
          vizzle_profile_remote.ProfileRemoteDataSourceImpl(
            apiClient: apiClient,
          ),
    ),
    Provider<vizzle_profile_local.ProfileLocalDataSource>(
      create: (_) => vizzle_profile_local.ProfileLocalDataSourceImpl(),
    ),

    // Vizzle Profile Repository
    ProxyProvider3<
      vizzle_profile_remote.ProfileRemoteDataSource,
      vizzle_profile_local.ProfileLocalDataSource,
      NetworkInfo,
      vizzle_profile_interface.ProfileRepository
    >(
      update: (_, remoteDataSource, localDataSource, networkInfo, __) =>
          vizzle_profile_repo.ProfileRepositoryImpl(
            remoteDataSource: remoteDataSource,
            localDataSource: localDataSource,
            networkInfo: networkInfo,
          ),
    ),

    // Vizzle Profile Use Cases
    ProxyProvider<
      vizzle_profile_interface.ProfileRepository,
      vizzle_profile_get.GetProfileUseCase
    >(
      update: (_, repository, __) =>
          vizzle_profile_get.GetProfileUseCase(repository),
    ),
    ProxyProvider<vizzle_profile_interface.ProfileRepository, DeleteAdUseCase>(
      update: (_, repository, __) => DeleteAdUseCase(repository),
    ),
    ProxyProvider<
      vizzle_profile_interface.ProfileRepository,
      MarkAsSoldUseCase
    >(update: (_, repository, __) => MarkAsSoldUseCase(repository)),
    ProxyProvider<
      vizzle_profile_interface.ProfileRepository,
      ClearProfileCacheUseCase
    >(update: (_, repository, __) => ClearProfileCacheUseCase(repository)),

    // Vizzle Profile Provider
    ChangeNotifierProxyProvider4<
      vizzle_profile_get.GetProfileUseCase,
      DeleteAdUseCase,
      MarkAsSoldUseCase,
      ClearProfileCacheUseCase,
      vizzle_profile_provider.ProfileProvider
    >(
      create: (context) => vizzle_profile_provider.ProfileProvider(
        getProfileUseCase: context.read<vizzle_profile_get.GetProfileUseCase>(),
        deleteAdUseCase: context.read<DeleteAdUseCase>(),
        markAsSoldUseCase: context.read<MarkAsSoldUseCase>(),
        clearProfileCacheUseCase: context.read<ClearProfileCacheUseCase>(),
      ),
      update:
          (
            _,
            getProfileUseCase,
            deleteAdUseCase,
            markAsSoldUseCase,
            clearProfileCacheUseCase,
            previous,
          ) =>
              previous ??
              vizzle_profile_provider.ProfileProvider(
                getProfileUseCase: getProfileUseCase,
                deleteAdUseCase: deleteAdUseCase,
                markAsSoldUseCase: markAsSoldUseCase,
                clearProfileCacheUseCase: clearProfileCacheUseCase,
              ),
    ),
  ];
}

import 'package:flutter/foundation.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../domain/entities/saved_ad_entity.dart';
import '../../domain/usecases/clear_saved_cache_usecase.dart';
import '../../domain/usecases/get_saved_ads_usecase.dart';
import '../../domain/usecases/toggle_saved_favorite_usecase.dart';

enum SavedAdsStatus { initial, loading, success, error }

class SavedAdsProvider with ChangeNotifier {
  final GetSavedAdsUseCase getSavedAdsUseCase;
  final ToggleSavedFavoriteUseCase toggleSavedFavoriteUseCase;
  final ClearSavedCacheUseCase clearSavedCacheUseCase;

  SavedAdsProvider({
    required this.getSavedAdsUseCase,
    required this.toggleSavedFavoriteUseCase,
    required this.clearSavedCacheUseCase,
  });

  // State management
  SavedAdsStatus _status = SavedAdsStatus.initial;
  List<SavedAdEntity> _savedAds = [];
  String? _errorMessage;
  String? _toggleFavoriteId;

  // Getters
  SavedAdsStatus get status => _status;
  List<SavedAdEntity> get savedAds => _savedAds;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == SavedAdsStatus.loading;
  bool get hasError => _status == SavedAdsStatus.error;
  bool get isEmpty => _savedAds.isEmpty && _status == SavedAdsStatus.success;
  int get savedAdsCount => _savedAds.length;
  bool get isToggling => _toggleFavoriteId != null;

  bool isAdToggling(String adId) => _toggleFavoriteId == adId;

  // Methods
  Future<void> loadSavedAds({bool showLoading = true}) async {
    if (showLoading) {
      _status = SavedAdsStatus.loading;
      _errorMessage = null;
      notifyListeners();
    }

    final result = await getSavedAdsUseCase(NoParams());

    result.fold(
      (failure) {
        _status = SavedAdsStatus.error;
        _errorMessage = _getFailureMessage(failure);
        debugPrint('Error loading saved ads: $_errorMessage');
      },
      (ads) {
        _status = SavedAdsStatus.success;
        _savedAds = ads;
        _errorMessage = null;
      },
    );

    notifyListeners();
  }

  Future<bool> toggleFavorite(String adId) async {
    if (_toggleFavoriteId != null) return false; // Prevent multiple requests

    _toggleFavoriteId = adId;
    notifyListeners();

    final result = await toggleSavedFavoriteUseCase(
      ToggleSavedFavoriteParams(adId: adId),
    );

    _toggleFavoriteId = null;

    return result.fold(
      (failure) {
        _errorMessage = _getFailureMessage(failure);
        notifyListeners();
        return false;
      },
      (_) {
        // Remove the ad from the list immediately for better UX
        _savedAds.removeWhere((ad) => ad.id == adId);
        notifyListeners();
        return true;
      },
    );
  }

  Future<void> refreshSavedAds() async {
    await clearCache();
    await loadSavedAds();
  }

  Future<void> clearCache() async {
    await clearSavedCacheUseCase(NoParams());
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _getFailureMessage(Failure failure) {
    switch (failure.runtimeType) {
      case const (NetworkFailure):
        return 'No internet connection. Please check your network.';
      case const (ServerFailure):
        return failure.message.isNotEmpty
            ? failure.message
            : 'Server error. Please try again later.';
      case const (CacheFailure):
        return 'Cache error. Please refresh the app.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}

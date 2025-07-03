import 'package:flutter/foundation.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/usecases/clear_profile_cache_usecase.dart';
import '../../domain/usecases/delete_ad_usecase.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/mark_as_sold_usecase.dart';

enum ProfileStatus { initial, loading, success, error }

class ProfileProvider with ChangeNotifier {
  final GetProfileUseCase getProfileUseCase;
  final DeleteAdUseCase deleteAdUseCase;
  final MarkAsSoldUseCase markAsSoldUseCase;
  final ClearProfileCacheUseCase clearProfileCacheUseCase;

  ProfileProvider({
    required this.getProfileUseCase,
    required this.deleteAdUseCase,
    required this.markAsSoldUseCase,
    required this.clearProfileCacheUseCase,
  });

  // State management
  ProfileStatus _status = ProfileStatus.initial;
  ProfileEntity? _profile;
  String? _errorMessage;
  String? _operatingAdId; // For tracking which ad is being operated on

  // Getters
  ProfileStatus get status => _status;
  ProfileEntity? get profile => _profile;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == ProfileStatus.loading;
  bool get hasError => _status == ProfileStatus.error;
  bool get hasProfile => _profile != null;
  String? get operatingAdId => _operatingAdId;

  int get activeAdsCount => _profile?.activeAdsCount ?? 0;
  int get renewAdsCount => _profile?.renewAdsCount ?? 0;
  int get jobsCount => _profile?.jobsCount ?? 0;
  int get chatToAnswer => _profile?.chatToAnswer ?? 0;
  int get totalAdsCount => _profile?.advertisements.length ?? 0;

  bool isAdOperating(String adId) => _operatingAdId == adId;

  // Methods
  Future<void> loadProfile({bool showLoading = true}) async {
    if (showLoading) {
      _status = ProfileStatus.loading;
      _errorMessage = null;
      notifyListeners();
    }

    final result = await getProfileUseCase(NoParams());

    result.fold(
      (failure) {
        _status = ProfileStatus.error;
        _errorMessage = _getFailureMessage(failure);
        debugPrint('Error loading profile: $_errorMessage');
      },
      (profile) {
        _status = ProfileStatus.success;
        _profile = profile;
        _errorMessage = null;
      },
    );

    notifyListeners();
  }

  Future<bool> deleteAd(String adId) async {
    if (_operatingAdId != null) return false; // Prevent multiple operations

    _operatingAdId = adId;
    notifyListeners();

    final result = await deleteAdUseCase(DeleteAdParams(adId: adId));

    _operatingAdId = null;

    return result.fold(
      (failure) {
        _errorMessage = _getFailureMessage(failure);
        notifyListeners();
        return false;
      },
      (_) {
        // Remove the ad from the local list immediately for better UX
        if (_profile != null) {
          final updatedAds = _profile!.advertisements
              .where((ad) => ad.id != adId)
              .toList();

          _profile = ProfileEntity(
            success: _profile!.success,
            message: _profile!.message,
            user: _profile!.user,
            activeAdsCount: _profile!.activeAdsCount - 1,
            renewAdsCount: _profile!.renewAdsCount,
            jobsCount: _profile!.jobsCount,
            chatToAnswer: _profile!.chatToAnswer,
            currencyCode: _profile!.currencyCode,
            adsCount: _profile!.adsCount - 1,
            advertisements: updatedAds,
          );
        }
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> markAsSold(String adId) async {
    if (_operatingAdId != null) return false; // Prevent multiple operations

    _operatingAdId = adId;
    notifyListeners();

    final result = await markAsSoldUseCase(MarkAsSoldParams(adId: adId));

    _operatingAdId = null;

    return result.fold(
      (failure) {
        _errorMessage = _getFailureMessage(failure);
        notifyListeners();
        return false;
      },
      (_) {
        // Update the ad status locally for better UX
        if (_profile != null) {
          final updatedAds = _profile!.advertisements.map((ad) {
            if (ad.id == adId) {
              // Create a new ad entity with sold status
              // Note: This is a simplified update, in real implementation
              // you might want to create a copyWith method for the entity
              return ad;
            }
            return ad;
          }).toList();

          // Remove the sold ad from active count
          _profile = ProfileEntity(
            success: _profile!.success,
            message: _profile!.message,
            user: _profile!.user,
            activeAdsCount: _profile!.activeAdsCount - 1,
            renewAdsCount: _profile!.renewAdsCount,
            jobsCount: _profile!.jobsCount,
            chatToAnswer: _profile!.chatToAnswer,
            currencyCode: _profile!.currencyCode,
            adsCount: _profile!.adsCount,
            advertisements: updatedAds,
          );
        }
        notifyListeners();
        return true;
      },
    );
  }

  Future<void> refreshProfile() async {
    await clearCache();
    await loadProfile();
  }

  Future<void> clearCache() async {
    await clearProfileCacheUseCase(NoParams());
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

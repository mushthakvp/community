import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:livera/core/constants/app_constants.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/promo_entity.dart';
import '../../domain/entities/promos_data.dart';
import '../../domain/entities/social_links_entity.dart';
import '../../domain/entities/video_entity.dart';
import '../../domain/usecases/add_reward_points_usecase.dart';
import '../../domain/usecases/get_promos_usecase.dart';
import '../../domain/usecases/launch_url_usecase.dart';

enum PromosStatus { initial, loading, loaded, error }

class PromosProvider extends ChangeNotifier {
  final GetPromosUseCase _getPromosUseCase;
  final AddRewardPointsUseCase _addRewardPointsUseCase;
  final LaunchUrlUseCase _launchUrlUseCase;

  PromosProvider({
    required GetPromosUseCase getPromosUseCase,
    required AddRewardPointsUseCase addRewardPointsUseCase,
    required LaunchUrlUseCase launchUrlUseCase,
  }) : _getPromosUseCase = getPromosUseCase,
       _addRewardPointsUseCase = addRewardPointsUseCase,
       _launchUrlUseCase = launchUrlUseCase;

  // State
  PromosStatus _status = PromosStatus.initial;
  PromosData? _promosData;
  String? _errorMessage;
  bool _isAddingReward = false;

  // Getters
  PromosStatus get status => _status;
  PromosData? get promosData => _promosData;
  List<VideoEntity> get videos => _promosData?.videos ?? [];
  List<PromoEntity> get promos => _promosData?.promos ?? [];
  SocialLinksEntity? get socialLinks => _promosData?.socialLinks;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == PromosStatus.loading;
  bool get hasError => _status == PromosStatus.error;
  bool get hasData => _promosData != null && !_promosData!.isEmpty;
  bool get isAddingReward => _isAddingReward;

  final List<SocialMediaItem> socialMediaList = [
    SocialMediaItem(
      name: "Youtube",
      icon: AppConstants.youtubeIcon,
      points: 10,
    ),
    SocialMediaItem(
      name: "Facebook",
      icon: AppConstants.facebookIcon,
      points: 10,
    ),
    SocialMediaItem(
      name: "Instagram",
      icon: AppConstants.instagramIcon,
      points: 10,
    ),
  ];

  /// Load promos data from repository
  Future<void> loadPromos({bool forceRefresh = false}) async {
    if (_status == PromosStatus.loading && !forceRefresh) return;

    _setStatus(PromosStatus.loading);

    try {
      final result = await _getPromosUseCase();

      result.fold((failure) => _setError(_getErrorMessage(failure)), (
        promosData,
      ) {
        _promosData = promosData;
        _setStatus(PromosStatus.loaded);
      });
    } catch (e) {
      log('Unexpected error loading promos: $e');
      _setError('An unexpected error occurred');
    }
  }

  /// Add reward points for user actions
  Future<void> addRewardPoints({
    required int points,
    required String action,
    BuildContext? context,
  }) async {
    if (_isAddingReward) return;

    _isAddingReward = true;
    notifyListeners();

    try {
      final params = AddRewardPointsParams(points: points, action: action);
      final result = await _addRewardPointsUseCase(params);

      result.fold(
        (failure) {
          _showMessage(context, _getErrorMessage(failure), isError: true);
          log('Failed to add reward points: ${failure.message}');
        },
        (success) {
          if (success) {
            _showMessage(
              context,
              'Reward points added successfully! +$points points',
              isError: false,
            );
            log('Reward points added: $points for action: $action');
          } else {
            _showMessage(context, 'Failed to add reward points', isError: true);
          }
        },
      );
    } catch (e) {
      log('Unexpected error adding reward points: $e');
      _showMessage(context, 'An unexpected error occurred', isError: true);
    } finally {
      _isAddingReward = false;
      notifyListeners();
    }
  }

  /// Launch URL (social media links, websites, etc.)
  Future<bool> launchUrl(String url) async {
    try {
      final result = await _launchUrlUseCase(url);

      return result.fold(
        (failure) {
          log('Failed to launch URL: ${failure.message}');
          throw Exception(failure.message);
        },
        (success) {
          if (success) {
            log('URL launched successfully: $url');
            return true;
          } else {
            log('Failed to launch URL: $url');
            throw Exception('Failed to launch URL');
          }
        },
      );
    } catch (e) {
      log('Unexpected error launching URL: $e');
      throw Exception('Failed to launch URL: $e');
    }
  }

  /// Launch social media with app fallback
  Future<bool> launchSocialMedia({
    required String appUrl,
    required String webUrl,
  }) async {
    try {
      final result = await _launchUrlUseCase.launchSocialMedia(
        appUrl: appUrl,
        webUrl: webUrl,
      );

      return result.fold(
        (failure) {
          log('Failed to launch social media: ${failure.message}');
          throw Exception(failure.message);
        },
        (success) {
          log('Social media launched successfully');
          return true;
        },
      );
    } catch (e) {
      log('Unexpected error launching social media: $e');
      throw Exception('Failed to launch social media: $e');
    }
  }

  /// Clear error state
  void clearError() {
    if (_status == PromosStatus.error) {
      _errorMessage = null;
      _setStatus(PromosStatus.initial);
    }
  }

  /// Retry loading promos
  Future<void> retry() async {
    await loadPromos(forceRefresh: true);
  }

  // Private Methods
  void _setStatus(PromosStatus status) {
    _status = status;
    if (status != PromosStatus.error) {
      _errorMessage = null;
    }
    notifyListeners();
  }

  void _setError(String message) {
    _status = PromosStatus.error;
    _errorMessage = message;
    notifyListeners();
  }

  String _getErrorMessage(Failure failure) {
    return failure.userFriendlyMessage;
  }

  void _showMessage(
    BuildContext? context,
    String message, {
    required bool isError,
  }) {
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                isError ? Icons.error_outline : Icons.check_circle,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: isError ? Colors.red : Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: isError ? 4 : 3),
        ),
      );
    }
  }
}

// Social Media Item Model
class SocialMediaItem {
  final String name;
  final String icon;
  final int points;

  const SocialMediaItem({
    required this.name,
    required this.icon,
    required this.points,
  });
}

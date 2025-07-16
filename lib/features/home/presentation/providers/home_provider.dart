import 'dart:developer' as dev;

import 'package:flutter/material.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/home_entity.dart';
import '../../domain/usecases/get_user_details_usecase.dart';

enum HomeStatus { initial, loading, loaded, error }

class HomeProvider extends ChangeNotifier {
  final GetUserDetailsUseCase _getUserDetailsUseCase;

  HomeProvider({required GetUserDetailsUseCase getUserDetailsUseCase})
    : _getUserDetailsUseCase = getUserDetailsUseCase;

  // State
  HomeStatus _status = HomeStatus.initial;
  UserDetailsEntity? _userDetails;
  String? _errorMessage;

  // Getters
  HomeStatus get status => _status;
  UserDetailsEntity? get userDetails => _userDetails;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == HomeStatus.loading;
  bool get hasError => _status == HomeStatus.error;
  bool get hasData => _userDetails != null;

  Future<void> loadUserDetails({bool forceRefresh = false}) async {
    if (_status == HomeStatus.loading) return;
    try {
      _setLoading();
      final result = await _getUserDetailsUseCase();
      result.fold((failure) => _setError(_getErrorMessage(failure)), (
        userDetails,
      ) {
        _userDetails = userDetails;
        _setLoaded();
      });
    } catch (e) {
      dev.log('Error loading user details: $e');
      _setError('Failed to load user details. Please try again.');
    }
  }

  void _setLoading() {
    _status = HomeStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoaded() {
    _status = HomeStatus.loaded;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _status = HomeStatus.error;
    _errorMessage = message;
    dev.log('Home provider error: $message');
    notifyListeners();
  }

  String _getErrorMessage(Failure failure) {
    return failure.userFriendlyMessage;
  }
}

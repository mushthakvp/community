import 'package:flutter/material.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/usecases/get_profile_usecase.dart';

enum ProfileStatus { initial, loading, loaded, error }

class ProfileProvider extends ChangeNotifier {
  final GetProfileUseCase _getProfileUseCase;

  ProfileProvider({required GetProfileUseCase getProfileUseCase})
    : _getProfileUseCase = getProfileUseCase;

  // State
  ProfileStatus _status = ProfileStatus.initial;
  ProfileEntity? _profile;
  String _errorMessage = '';

  // Getters
  ProfileStatus get status => _status;
  ProfileEntity? get profile => _profile;
  String get errorMessage => _errorMessage;
  bool get isLoading => _status == ProfileStatus.loading;
  bool get hasError => _status == ProfileStatus.error;

  // Methods
  Future<void> getProfile() async {
    try {
      _status = ProfileStatus.loading;
      notifyListeners();

      final result = await _getProfileUseCase(NoParams());

      result.fold(
        (failure) {
          _errorMessage = _getFailureMessage(failure);
          _status = ProfileStatus.error;
        },
        (profile) {
          _profile = profile;
          _status = ProfileStatus.loaded;
        },
      );
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: $e';
      _status = ProfileStatus.error;
    }

    notifyListeners();
  }

  void reset() {
    _status = ProfileStatus.initial;
    _profile = null;
    _errorMessage = '';
    notifyListeners();
  }

  String _getFailureMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure _:
        return failure.message.isNotEmpty
            ? failure.message
            : 'Server error occurred';
      case NetworkFailure _:
        return 'No internet connection';
      case CacheFailure _:
        return 'Cache error occurred';
      default:
        return 'An unexpected error occurred';
    }
  }
}

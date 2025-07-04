import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/spin_config_entity.dart';
import '../../domain/entities/spin_history_entity.dart';
import '../../domain/entities/spin_option_entity.dart';
import '../../domain/entities/spin_result_entity.dart';
import '../../domain/usecases/check_can_spin_usecase.dart';
import '../../domain/usecases/get_remaining_spins_usecase.dart';
import '../../domain/usecases/get_spin_config_usecase.dart';
import '../../domain/usecases/get_spin_history_usecase.dart';
import '../../domain/usecases/get_spin_options_usecase.dart';
import '../../domain/usecases/get_user_loyalty_points_usecase.dart';
import '../../domain/usecases/perform_spin_usecase.dart';

enum SpinStatus { initial, loading, ready, spinning, completed, error }

class SpinProvider extends ChangeNotifier {
  final GetSpinConfigUseCase getSpinConfigUseCase;
  final GetSpinOptionsUseCase getSpinOptionsUseCase;
  final PerformSpinUseCase performSpinUseCase;
  final GetSpinHistoryUseCase getSpinHistoryUseCase;
  final CheckCanSpinUseCase checkCanSpinUseCase;
  final GetRemainingSpinsUseCase getRemainingSpinsUseCase;
  final GetUserLoyaltyPointsUseCase getUserLoyaltyPointsUseCase;

  SpinProvider({
    required this.getSpinConfigUseCase,
    required this.getSpinOptionsUseCase,
    required this.performSpinUseCase,
    required this.getSpinHistoryUseCase,
    required this.checkCanSpinUseCase,
    required this.getRemainingSpinsUseCase,
    required this.getUserLoyaltyPointsUseCase,
  });

  // State variables
  SpinStatus _status = SpinStatus.initial;
  SpinConfigEntity? _spinConfig;
  List<SpinOptionEntity> _spinOptions = [];
  SpinResultEntity? _lastSpinResult;
  final List<SpinHistoryEntity> _spinHistory = [];
  String? _errorMessage;
  int _userLoyaltyPoints = 0;
  int _remainingSpins = 0;
  bool _canSpin = false;

  // Spin animation state
  bool _isSpinning = false;
  int _selectedIndex = 0;
  final StreamController<int> _spinController =
      StreamController<int>.broadcast();
  Timer? _spinTimer;

  bool _soundEnabled = true;

  // History pagination
  int _currentPage = 1;
  bool _hasMoreHistory = true;
  bool _isLoadingMoreHistory = false;

  // Getters
  SpinStatus get status => _status;
  SpinConfigEntity? get spinConfig => _spinConfig;
  List<SpinOptionEntity> get spinOptions => _spinOptions;
  SpinResultEntity? get lastSpinResult => _lastSpinResult;
  List<SpinHistoryEntity> get spinHistory => _spinHistory;
  String? get errorMessage => _errorMessage;
  int get userLoyaltyPoints => _userLoyaltyPoints;
  int get remainingSpins => _remainingSpins;
  bool get canSpin => _canSpin && !_isSpinning;
  bool get isSpinning => _isSpinning;
  int get selectedIndex => _selectedIndex;
  Stream<int> get spinStream => _spinController.stream;
  bool get soundEnabled => _soundEnabled;
  bool get hasMoreHistory => _hasMoreHistory;
  bool get isLoadingMoreHistory => _isLoadingMoreHistory;

  // Computed properties
  bool get isLoading => _status == SpinStatus.loading;
  bool get hasError => _status == SpinStatus.error;
  bool get isReady => _status == SpinStatus.ready;
  bool get isCompleted => _status == SpinStatus.completed;
  bool get hasSpinOptions => _spinOptions.isNotEmpty;
  bool get hasSpinHistory => _spinHistory.isNotEmpty;

  @override
  void dispose() {
    _spinController.close();
    _spinTimer?.cancel();
    super.dispose();
  }

  // Public methods
  Future<void> initializeSpin(String spinType) async {
    _setStatus(SpinStatus.loading);
    _clearError();

    try {
      // Load spin configuration
      await _loadSpinConfig(spinType);

      // Load spin options
      await _loadSpinOptions(spinType);

      // Check user's spin eligibility
      await _checkSpinEligibility(spinType);

      // Load user's loyalty points
      await _loadUserLoyaltyPoints();

      _setStatus(SpinStatus.ready);
    } catch (e) {
      _setError('Failed to initialize spin: $e');
      _setStatus(SpinStatus.error);
    }
  }

  Future<void> refreshSpinData(String spinType) async {
    await initializeSpin(spinType);
  }

  Future<void> performSpin(String spinType) async {
    if (!canSpin || _spinOptions.isEmpty) return;

    _setSpinning(true);
    _clearError();

    try {
      // Play spinning sound
      if (_soundEnabled) {
        await _playSpinSound();
      }

      // Trigger haptic feedback
      await _triggerHapticFeedback();

      // Animate the wheel
      await _animateWheel();

      // Get the selected option
      final selectedOption = _spinOptions[_selectedIndex];

      // Perform the actual spin on the backend
      final result = await performSpinUseCase(
        PerformSpinParams(
          optionId: selectedOption.id,
          spinType: spinType,
          isUnlimited: spinType == 'spin_and_earn',
        ),
      );

      result.fold(
        (failure) {
          _setError(_getErrorMessage(failure));
          _setStatus(SpinStatus.error);
        },
        (spinResult) {
          _lastSpinResult = spinResult;
          _setStatus(SpinStatus.completed);

          // Play result sound
          if (_soundEnabled) {
            _playResultSound(spinResult.isWinning);
          }

          // Update user data
          _updateUserData(spinType);
        },
      );
    } catch (e) {
      _setError('Failed to perform spin: $e');
      _setStatus(SpinStatus.error);
    } finally {
      _setSpinning(false);
    }
  }

  Future<void> loadSpinHistory({String? spinType, bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _hasMoreHistory = true;
      _spinHistory.clear();
    }

    if (!_hasMoreHistory || _isLoadingMoreHistory) return;

    _isLoadingMoreHistory = true;
    notifyListeners();

    try {
      final result = await getSpinHistoryUseCase(
        SpinHistoryParams(page: _currentPage, limit: 10, spinType: spinType),
      );

      result.fold(
        (failure) {
          if (_currentPage == 1) {
            _setError(_getErrorMessage(failure));
          }
        },
        (history) {
          if (history.isEmpty) {
            _hasMoreHistory = false;
          } else {
            _spinHistory.addAll(history);
            _currentPage++;
          }
        },
      );
    } catch (e) {
      if (_currentPage == 1) {
        _setError('Failed to load spin history: $e');
      }
    } finally {
      _isLoadingMoreHistory = false;
      notifyListeners();
    }
  }

  void toggleSound() {
    _soundEnabled = !_soundEnabled;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }

  void resetSpinResult() {
    _lastSpinResult = null;
    _setStatus(SpinStatus.ready);
  }

  Future<void> _loadSpinConfig(String spinType) async {
    final result = await getSpinConfigUseCase(spinType);
    result.fold(
      (failure) => throw Exception(_getErrorMessage(failure)),
      (config) => _spinConfig = config,
    );
  }

  Future<void> _loadSpinOptions(String spinType) async {
    final result = await getSpinOptionsUseCase(spinType);
    result.fold(
      (failure) => throw Exception(_getErrorMessage(failure)),
      (options) => _spinOptions = options,
    );
  }

  Future<void> _checkSpinEligibility(String spinType) async {
    // Check if user can spin
    final canSpinResult = await checkCanSpinUseCase(spinType);
    canSpinResult.fold(
      (failure) => _canSpin = false,
      (canSpin) => _canSpin = canSpin,
    );

    // Get remaining spins
    final remainingSpinsResult = await getRemainingSpinsUseCase(spinType);
    remainingSpinsResult.fold(
      (failure) => _remainingSpins = 0,
      (remaining) => _remainingSpins = remaining,
    );
  }

  Future<void> _loadUserLoyaltyPoints() async {
    final result = await getUserLoyaltyPointsUseCase(NoParams());
    result.fold(
      (failure) => _userLoyaltyPoints = 0,
      (points) => _userLoyaltyPoints = points,
    );
  }

  Future<void> _animateWheel() async {
    // Generate random index
    final random = Random();
    _selectedIndex = random.nextInt(_spinOptions.length);

    // Add the spin animation
    _spinController.add(_selectedIndex);

    // Wait for animation to complete
    await Future.delayed(const Duration(seconds: 3));
  }

  Future<void> _playSpinSound() async {
    try {
      await AudioService.playSpinSound();
    } catch (e) {
      debugPrint('Failed to play spin sound: $e');
    }
  }

  Future<void> _playResultSound(bool isWinning) async {
    try {
      await AudioService.stopSpinSound();
      await AudioService.playWinSound();
    } catch (e) {
      // Sound playback failed - continue silently
    }
  }

  Future<void> _triggerHapticFeedback() async {
    try {
      await HapticFeedback.mediumImpact();
    } catch (e) {
      // Haptic feedback failed - continue silently
    }
  }

  Future<void> _updateUserData(String spinType) async {
    // Reload user data after spin
    await _loadUserLoyaltyPoints();
    await _checkSpinEligibility(spinType);
  }

  void _setStatus(SpinStatus status) {
    _status = status;
    notifyListeners();
  }

  void _setSpinning(bool spinning) {
    _isSpinning = spinning;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _getErrorMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure _:
        return failure.message;
      case NetworkFailure _:
        return 'Please check your internet connection';
      case CacheFailure _:
        return 'Unable to load cached data';
      case ValidationFailure _:
        return failure.message;
      default:
        return 'An unexpected error occurred';
    }
  }

  String formatSpinHistory(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);

    if (targetDate == today) {
      return 'Today';
    } else if (targetDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String getSpinResultMessage(SpinResultEntity result) {
    final option = result.spinOption;

    switch (option.rewardType) {
      case SpinRewardType.loyaltyPoints:
        return 'You won ${option.loyaltyPoints} loyalty points!';
      case SpinRewardType.coupon:
        return 'You won a coupon: ${option.couponCode}!';
      case SpinRewardType.gift:
        return 'You won a gift: ${option.giftDescription}!';
      case SpinRewardType.discount:
        return 'You won ${option.discountPercentage}% discount!';
      case SpinRewardType.extraSpin:
        return 'You won an extra spin!';
      case SpinRewardType.betterLuck:
        return 'Better luck next time!';
    }
  }

  Color getSpinResultColor(SpinResultEntity result) {
    return result.isWinning ? Colors.green : Colors.orange;
  }

  IconData getSpinResultIcon(SpinResultEntity result) {
    return result.isWinning ? Icons.celebration : Icons.sentiment_neutral;
  }
}

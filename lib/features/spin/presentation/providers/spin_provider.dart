import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livera/core/services/audio_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/spin_data_entity.dart';
import '../../domain/entities/spin_entity.dart';
import '../../domain/entities/spin_history_entity.dart';
import '../../domain/entities/spin_result_entity.dart';
import '../../domain/usecases/execute_spin_usecase.dart';
import '../../domain/usecases/get_spin_data_usecase.dart';
import '../../domain/usecases/get_spin_history_usecase.dart';

enum SpinStatus { initial, loading, loaded, spinning, error }

enum SpinType { daily, unlimited }

class SpinProvider extends ChangeNotifier {
  final GetSpinDataUseCase _getSpinDataUseCase;
  final ExecuteSpinUseCase _executeSpinUseCase;
  final GetSpinHistoryUseCase _getSpinHistoryUseCase;

  SpinProvider({
    required GetSpinDataUseCase getSpinDataUseCase,
    required ExecuteSpinUseCase executeSpinUseCase,
    required GetSpinHistoryUseCase getSpinHistoryUseCase,
  }) : _getSpinDataUseCase = getSpinDataUseCase,
       _executeSpinUseCase = executeSpinUseCase,
       _getSpinHistoryUseCase = getSpinHistoryUseCase;

  // State
  SpinStatus _status = SpinStatus.initial;
  SpinDataEntity? _spinData;
  final List<SpinHistoryEntity> _spinHistory = [];
  String? _errorMessage;
  SpinType _currentSpinType = SpinType.daily;
  SpinResultEntity? _lastSpinResult;

  // Spin Animation State
  bool _isSpinning = false;
  int? _selectedIndex;
  final StreamController<int> _spinController =
      StreamController<int>.broadcast();

  // History Pagination
  int _currentPage = 1;
  bool _hasMoreHistory = true;
  bool _isLoadingHistory = false;

  // Cache
  DateTime? _lastLoadTime;
  static const Duration _cacheValidDuration = Duration(minutes: 2);

  // Daily spin tracking
  SharedPreferences? _prefs;
  bool _isDailySpinUsed = false;

  // Getters
  SpinStatus get status => _status;
  SpinDataEntity? get spinData => _spinData;
  List<SpinHistoryEntity> get spinHistory => _spinHistory;
  String? get errorMessage => _errorMessage;
  SpinType get currentSpinType => _currentSpinType;
  bool get isSpinning => _isSpinning;
  int? get selectedIndex => _selectedIndex;
  Stream<int> get spinStream => _spinController.stream;
  bool get isLoading => _status == SpinStatus.loading;
  bool get hasError => _status == SpinStatus.error;

  // Fixed canSpin logic
  bool get canSpin {
    if (_currentSpinType == SpinType.daily) {
      return !_isDailySpinUsed && (_spinData?.canSpin ?? false);
    } else {
      // For unlimited spins, check if user has enough points
      return hasEnoughPoints && (_spinData?.canSpin ?? false);
    }
  }

  bool get hasSpinOptions => _spinData?.hasOptions ?? false;
  int get userLoyaltyPoints => _spinData?.userLoyaltyPoints ?? 0;
  int get requiredPoints => _spinData?.requiredPoints ?? 0;
  bool get hasEnoughPoints => userLoyaltyPoints >= requiredPoints;
  List<SpinEntity> get spinOptions => _spinData?.options ?? [];
  bool get hasMoreHistory => _hasMoreHistory;
  bool get isLoadingHistory => _isLoadingHistory;
  SpinResultEntity? get lastSpinResult => _lastSpinResult;

  // Daily spin specific getters
  bool get isDailySpinCompleted => _isDailySpinUsed;

  @override
  void dispose() {
    _spinController.close();
    super.dispose();
  }

  // Initialize SharedPreferences
  Future<void> _initializePrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Check if daily spin was used today
  Future<void> _checkDailySpinStatus() async {
    await _initializePrefs();

    final today = DateTime.now();
    final todayString = '${today.year}-${today.month}-${today.day}';
    final lastSpinDate = _prefs?.getString('last_daily_spin_date');

    _isDailySpinUsed = lastSpinDate == todayString;
    dev.log(
      'Daily spin status: used=$_isDailySpinUsed, lastDate=$lastSpinDate, today=$todayString',
    );
  }

  // Mark daily spin as used
  Future<void> _markDailySpinAsUsed() async {
    await _initializePrefs();

    final today = DateTime.now();
    final todayString = '${today.year}-${today.month}-${today.day}';
    await _prefs?.setString('last_daily_spin_date', todayString);

    _isDailySpinUsed = true;
    dev.log('Marked daily spin as used for: $todayString');
  }

  // Reset spin wheel state
  void _resetSpinState() {
    _selectedIndex = null;
    _lastSpinResult = null;
    _isSpinning = false;
    _status = SpinStatus.initial;
    dev.log('Spin state reset');
  }

  // Public Methods
  Future<void> initializeSpin(SpinType spinType) async {
    dev.log('Initializing spin with type: $spinType');

    // Reset state when switching spin types or reinitializing
    if (_currentSpinType != spinType) {
      _resetSpinState();
    }

    _currentSpinType = spinType;

    if (spinType == SpinType.daily) {
      await _checkDailySpinStatus();
    }

    await loadSpinData(forceRefresh: true);
  }

  Future<void> loadSpinData({bool forceRefresh = false}) async {
    if (_status == SpinStatus.loading) return;

    if (forceRefresh || !_shouldUseCachedData()) {
      _setLoading();
      await _fetchSpinData();
    } else if (_spinData != null) {
      _setLoaded();
    }
  }

  Future<void> refreshSpinData() async {
    _resetSpinState();
    await loadSpinData(forceRefresh: true);
  }

  Future<void> spinWheel() async {
    dev.log(
      'Spin wheel requested - canSpin: $canSpin, isSpinning: $_isSpinning, hasOptions: $hasSpinOptions',
    );

    if (_isSpinning || !canSpin || !hasSpinOptions) {
      String reason = '';
      if (_isSpinning) {
        reason = 'Already spinning';
      } else if (!canSpin) {
        reason = _currentSpinType == SpinType.daily
            ? 'Daily spin already used'
            : 'Not enough points';
      } else if (!hasSpinOptions) {
        reason = 'No spin options';
      }
      _showError('Cannot spin: $reason');
      return;
    }

    try {
      _setSpinning(true);
      _clearLastResult();
      final randomIndex = Random().nextInt(spinOptions.length);
      _selectedIndex = randomIndex;
      _spinController.add(randomIndex);
      await _playSpinSound();
      await Future.delayed(const Duration(seconds: 4));
      await AudioService.stopSpinSound();
      await _executeSpin(spinOptions[randomIndex].id);
    } catch (e) {
      _showError('Failed to spin. Please try again.');
    } finally {
      _setSpinning(false);
    }
  }

  Future<void> loadSpinHistory({bool isInitialLoad = false}) async {
    if ((_isLoadingHistory && !isInitialLoad) ||
        (!_hasMoreHistory && !isInitialLoad)) {
      return;
    }
    if (isInitialLoad) {
      _spinHistory.clear();
      _currentPage = 1;
      _hasMoreHistory = true;
    }
    _isLoadingHistory = true;
    notifyListeners();
    try {
      final result = await _getSpinHistoryUseCase(
        page: _currentPage,
        limit: 10,
      );
      result.fold(
        (failure) {
          _showError(_getErrorMessage(failure));
          if (isInitialLoad) {
            _hasMoreHistory = false;
          }
        },
        (history) {
          if (history.isNotEmpty) {
            _spinHistory.addAll(history);
            _currentPage++;
            if (history.length < 10) {
              _hasMoreHistory = false;
            }
          } else {
            _hasMoreHistory = false;
          }
        },
      );
    } catch (e) {
      _showError('Failed to load spin history');
      if (isInitialLoad) {
        _hasMoreHistory = false;
      }
    } finally {
      _isLoadingHistory = false;
      notifyListeners();
    }
  }

  Future<void> refreshSpinHistory() async {
    await loadSpinHistory(isInitialLoad: true);
  }

  void copyCouponCode(String couponCode) {
    try {
      Clipboard.setData(ClipboardData(text: couponCode));
    } catch (e) {
      dev.log('Error copying to clipboard: $e');
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearLastResult() {
    _clearLastResult();
  }

  // Date formatting methods
  String formatDateCategory(DateTime date) {
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));
    if (_isSameDay(date, today)) return 'Today';
    if (_isSameDay(date, yesterday)) return 'Yesterday';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Map<String, List<SpinHistoryEntity>> groupSpinHistoryByDate() {
    Map<String, List<SpinHistoryEntity>> groupedData = {};
    for (var spin in _spinHistory) {
      final category = formatDateCategory(spin.date.toLocal());
      groupedData.putIfAbsent(category, () => []).add(spin);
    }
    final sortedEntries = groupedData.entries.toList()
      ..sort((a, b) {
        if (a.key == 'Today') return -1;
        if (b.key == 'Today') return 1;
        if (a.key == 'Yesterday') return -1;
        if (b.key == 'Yesterday') return 1;
        try {
          final dateA = _parseGroupDate(a.key);
          final dateB = _parseGroupDate(b.key);
          return dateB.compareTo(dateA);
        } catch (e) {
          return 0;
        }
      });
    return Map.fromEntries(sortedEntries);
  }

  void handleSpinResult(SpinResultEntity result, {VoidCallback? onSpinAgain}) {
    _lastSpinResult = result;
    if (_currentSpinType == SpinType.daily) {
      _markDailySpinAsUsed();
    }
    loadSpinData(forceRefresh: true);
    notifyListeners();
  }

  Future<void> _playSpinSound() async {
    try {
      await AudioService.playSpinSound();
    } catch (e) {
      dev.log('Failed to play spin sound: $e');
    }
  }

  Future<void> _fetchSpinData() async {
    try {
      final spinTypeString = _currentSpinType == SpinType.daily
          ? 'daily_spin'
          : 'spin_and_earn';
      final result = await _getSpinDataUseCase(spinTypeString);
      result.fold((failure) => _setError(_getErrorMessage(failure)), (
        spinData,
      ) {
        _spinData = spinData;
        _lastLoadTime = DateTime.now();
        _setLoaded();
      });
    } catch (e) {
      _setError('Failed to load spin data. Please try again.');
    }
  }

  Future<void> _executeSpin(String optionId) async {
    try {
      final result = await _executeSpinUseCase(optionId);
      result.fold(
        (failure) {
          if (failure.message.toLowerCase().contains('already spun')) {
            _setError('You already spun today. Come back tomorrow!');
            if (_currentSpinType == SpinType.daily) {
              _markDailySpinAsUsed();
            }
          } else {
            _setError(_getErrorMessage(failure));
          }
        },
        (spinResult) {
          _lastSpinResult = spinResult;
          if (_currentSpinType == SpinType.daily) {
            _markDailySpinAsUsed();
          }
          notifyListeners();
        },
      );
    } catch (e) {
      _showError('Failed to execute spin. Please try again.');
    }
  }

  void _setLoading() {
    _status = SpinStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoaded() {
    _status = SpinStatus.loaded;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _status = SpinStatus.error;
    _errorMessage = message;
    dev.log('Spin provider error: $message');
    notifyListeners();
  }

  void _setSpinning(bool spinning) {
    _isSpinning = spinning;
    _status = spinning ? SpinStatus.spinning : SpinStatus.loaded;
    notifyListeners();
  }

  void _showError(String message) {
    _errorMessage = message;
    notifyListeners();
    Timer(const Duration(seconds: 3), () {
      if (_errorMessage == message) {
        _errorMessage = null;
        notifyListeners();
      }
    });
  }

  void _clearLastResult() {
    _lastSpinResult = null;
    notifyListeners();
  }

  bool _shouldUseCachedData() {
    return _spinData != null &&
        _lastLoadTime != null &&
        DateTime.now().difference(_lastLoadTime!) < _cacheValidDuration;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _getErrorMessage(Failure failure) {
    if (failure.message.toLowerCase().contains('already spun')) {
      return 'You have already used your daily spin. Come back tomorrow for more rewards!';
    }
    if (failure.message.toLowerCase().contains('network')) {
      return 'Network error. Please check your connection and try again.';
    }
    if (failure.message.toLowerCase().contains('server')) {
      return 'Server error. Please try again later.';
    }
    return failure.message.isNotEmpty
        ? failure.message
        : 'Something went wrong. Please try again.';
  }

  DateTime _parseGroupDate(String dateString) {
    final parts = dateString.split('/');
    if (parts.length == 3) {
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      return DateTime(year, month, day);
    }
    return DateTime.now();
  }
}

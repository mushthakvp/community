import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vivera/core/services/audio_service.dart';

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

  // Date tracking for daily spin
  String? _lastSpinDate;

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
  bool get canSpin => _spinData?.canSpin ?? false;
  bool get hasSpinOptions => _spinData?.hasOptions ?? false;
  int get userLoyaltyPoints => _spinData?.userLoyaltyPoints ?? 0;
  int get requiredPoints => _spinData?.requiredPoints ?? 0;
  bool get hasEnoughPoints => _spinData?.hasEnoughPoints ?? false;
  List<SpinEntity> get spinOptions => _spinData?.options ?? [];
  bool get hasMoreHistory => _hasMoreHistory;
  bool get isLoadingHistory => _isLoadingHistory;
  SpinResultEntity? get lastSpinResult => _lastSpinResult;

  // Daily spin specific getters
  bool get isDailySpinCompleted => _isDailySpinCompleted();
  String? get lastSpinDate => _lastSpinDate;

  @override
  void dispose() {
    _spinController.close();
    super.dispose();
  }

  // Public Methods
  Future<void> initializeSpin(SpinType spinType) async {
    _currentSpinType = spinType;
    await loadSpinData();
    if (spinType == SpinType.daily) {
      _checkDailySpinStatus();
    }
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
    await loadSpinData(forceRefresh: true);
  }

  Future<void> spinWheel() async {
    if (_isSpinning || !canSpin || !hasSpinOptions) {
      dev.log(
        'Cannot spin: isSpinning=$_isSpinning, canSpin=$canSpin, hasOptions=$hasSpinOptions',
      );
      _showError('Cannot spin at this time. Please try again.');
      return;
    }

    try {
      _setSpinning(true);
      _clearLastResult();

      // Generate random selection
      final randomIndex = Random().nextInt(spinOptions.length);
      _selectedIndex = randomIndex;

      // Add to stream for wheel animation
      _spinController.add(randomIndex);

      // Play spin sound
      await _playSpinSound();

      // Wait for animation duration
      await Future.delayed(const Duration(seconds: 5));

      // Stop sound
      await AudioService.stopSpinSound();

      // Execute the actual spin API call
      await _executeSpin(spinOptions[randomIndex].id);
    } catch (e) {
      dev.log('Error during spin: $e');
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

            // If we got less than the limit, we've reached the end
            if (history.length < 10) {
              _hasMoreHistory = false;
            }
          } else {
            _hasMoreHistory = false;
          }
        },
      );
    } catch (e) {
      dev.log('Error loading spin history: $e');
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

    // Direct formatting without extension
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Map<String, List<SpinHistoryEntity>> groupSpinHistoryByDate() {
    Map<String, List<SpinHistoryEntity>> groupedData = {};

    for (var spin in _spinHistory) {
      final category = formatDateCategory(spin.date.toLocal());
      groupedData.putIfAbsent(category, () => []).add(spin);
    }

    // Sort the groups by date (most recent first)
    final sortedEntries = groupedData.entries.toList()
      ..sort((a, b) {
        if (a.key == 'Today') return -1;
        if (b.key == 'Today') return 1;
        if (a.key == 'Yesterday') return -1;
        if (b.key == 'Yesterday') return 1;

        // Parse dates and compare
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

  // Daily spin specific methods
  void checkDailySpinStatus() {
    _checkDailySpinStatus();
  }

  void markDailySpinCompleted() {
    _lastSpinDate = _getCurrentDateString();
    notifyListeners();
  }

  // Result handling
  void handleSpinResult(SpinResultEntity result, {VoidCallback? onSpinAgain}) {
    _lastSpinResult = result;

    if (_currentSpinType == SpinType.daily) {
      markDailySpinCompleted();
    }

    // Refresh spin data to update user points and spin availability
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
      dev.log('Error fetching spin data: $e');
      _setError('Failed to load spin data. Please try again.');
    }
  }

  Future<void> _executeSpin(String optionId) async {
    try {
      final result = await _executeSpinUseCase(optionId);

      result.fold((failure) => _showError(_getErrorMessage(failure)), (
        spinResult,
      ) {
        _lastSpinResult = spinResult;

        if (_currentSpinType == SpinType.daily) {
          markDailySpinCompleted();
        }

        // Don't refresh data immediately, let the UI handle it
        notifyListeners();
      });
    } catch (e) {
      dev.log('Error executing spin: $e');
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

    // Clear error after some time
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
    return failure.userFriendlyMessage;
  }

  // Daily spin specific private methods
  void _checkDailySpinStatus() {
    final currentDate = _getCurrentDateString();
    if (_lastSpinDate == currentDate) {
      // Already spun today
      if (_spinData != null) {
        _spinData = _spinData!.copyWith(canSpin: false);
        notifyListeners();
      }
    }
  }

  bool _isDailySpinCompleted() {
    if (_currentSpinType != SpinType.daily) return false;

    final currentDate = _getCurrentDateString();
    return _lastSpinDate == currentDate;
  }

  String _getCurrentDateString() {
    final now = DateTime.now();
    return '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
  }

  DateTime _parseGroupDate(String dateString) {
    // Parse format: DD/MM/YYYY
    final parts = dateString.split('/');
    if (parts.length == 3) {
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      return DateTime(year, month, day);
    }
    return DateTime.now();
  }

  // Debug methods (for development)
  void debugPrintState() {
    dev.log('=== Spin Provider State ===');
    dev.log('Status: $_status');
    dev.log('Spin Type: $_currentSpinType');
    dev.log('Can Spin: $canSpin');
    dev.log('Has Options: $hasSpinOptions');
    dev.log('User Points: $userLoyaltyPoints');
    dev.log('Required Points: $requiredPoints');
    dev.log('Options Count: ${spinOptions.length}');
    dev.log('Is Spinning: $_isSpinning');
    dev.log('Selected Index: $_selectedIndex');
    dev.log('History Count: ${_spinHistory.length}');
    dev.log('Has More History: $_hasMoreHistory');
    dev.log('Last Spin Date: $_lastSpinDate');
    dev.log('Current Date: ${_getCurrentDateString()}');
    dev.log('Daily Spin Completed: $isDailySpinCompleted');
    dev.log('===========================');
  }

  void debugPrintSpinOptions() {
    dev.log('=== Spin Options ===');
    for (int i = 0; i < spinOptions.length; i++) {
      final option = spinOptions[i];
      dev.log('[$i] ${option.title} - ${option.id}');
      dev.log('    Type: ${option.type}');
      dev.log('    Better Luck: ${option.isBetterLuck}');
      dev.log('    Spin Again: ${option.isSpinAgain}');
      dev.log('    Loyalty Points: ${option.loyaltyPoint}');
      dev.log('    Coupon Code: ${option.couponCode}');
    }
    dev.log('==================');
  }

  void debugPrintHistory() {
    dev.log('=== Spin History ===');
    final grouped = groupSpinHistoryByDate();
    grouped.forEach((date, spins) {
      dev.log('$date: ${spins.length} spins');
      for (var spin in spins) {
        dev.log('  - ${spin.displayResult} (${spin.date})');
      }
    });
    dev.log('==================');
  }
}

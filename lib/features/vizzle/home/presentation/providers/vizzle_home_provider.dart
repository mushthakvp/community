import 'dart:developer' as dev;

import 'package:flutter/material.dart';

import '../../../../../core/error/failures.dart';
import '../../../domain/entities/vizzle_entities.dart';
import '../../../domain/usecases/get_vizzle_home_usecase.dart';

enum VizzleHomeStatus { initial, loading, loaded, error }

class VizzleHomeProvider extends ChangeNotifier {
  final GetVizzleHomeUseCase _getVizzleHomeUseCase;

  VizzleHomeProvider({required GetVizzleHomeUseCase getVizzleHomeUseCase})
    : _getVizzleHomeUseCase = getVizzleHomeUseCase;

  // State
  VizzleHomeStatus _status = VizzleHomeStatus.initial;
  VizzleHomeEntity? _vizzleHome;
  String? _errorMessage;

  // Getters
  VizzleHomeStatus get status => _status;
  VizzleHomeEntity? get vizzleHome => _vizzleHome;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == VizzleHomeStatus.loading;
  bool get hasError => _status == VizzleHomeStatus.error;
  bool get hasData => _vizzleHome != null;
  bool get isEmpty => _vizzleHome == null || !_vizzleHome!.hasAnyAds;

  // Categories for home screen
  List<Map<String, dynamic>> get categories => [
    {
      'title': 'Classifieds',
      'icon': Icons.category,
      'categoryName': 'Classifieds',
    },
    {
      'title': 'Freshly Grown',
      'icon': Icons.eco,
      'categoryName': 'Freshly Grown',
    },
    {'title': 'Motors', 'icon': Icons.directions_car, 'categoryName': 'Motors'},
    {
      'title': 'Property For Sale',
      'icon': Icons.home,
      'categoryName': 'Property For Sale',
    },
    {'title': 'Community', 'icon': Icons.people, 'categoryName': 'Community'},
    {
      'title': 'Property For Rent',
      'icon': Icons.house,
      'categoryName': 'Property For Rent',
    },
  ];

  // Public methods
  Future<void> loadVizzleHome({bool forceRefresh = false}) async {
    if (_status == VizzleHomeStatus.loading) return;
    _setLoading();
    await _fetchVizzleHome();
  }

  Future<void> refreshData() async {
    await loadVizzleHome(forceRefresh: true);
  }

  // Private methods
  Future<void> _fetchVizzleHome() async {
    try {
      dev.log('🔄 Starting to fetch vizzle home data...');
      final result = await _getVizzleHomeUseCase();
      result.fold(
        (failure) {
          dev.log(
            '❌ Failed to fetch vizzle home: ${_getErrorMessage(failure)}',
          );
          _setError(_getErrorMessage(failure));
        },
        (vizzleHome) {
          dev.log('✅ Successfully fetched vizzle home data');
          dev.log('Motors count: ${vizzleHome.motors.length}');
          dev.log('Classifieds count: ${vizzleHome.classifieds.length}');
          _vizzleHome = vizzleHome;
          _setLoaded();
        },
      );
    } catch (e) {
      dev.log('💥 Exception fetching vizzle home: $e');
      _setError('Failed to load vizzle home. Please try again.');
    }
  }

  void _setLoading() {
    _status = VizzleHomeStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoaded() {
    _status = VizzleHomeStatus.loaded;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _status = VizzleHomeStatus.error;
    _errorMessage = message;
    dev.log('Vizzle home provider error: $message');
    notifyListeners();
  }

  String _getErrorMessage(Failure failure) {
    return failure.userFriendlyMessage;
  }

  void navigateToCategory(String categoryName) {
    // This will be handled by the UI layer
    dev.log('Navigating to category: $categoryName');
  }

  void navigateToProductDetails(String shareUrl) {
    // This will be handled by the UI layer
    dev.log('Navigating to product details: $shareUrl');
  }
}

import 'package:flutter/material.dart';

import '../../../../core/services/audio_service.dart';
import '../../../../core/services/storage_service.dart';

class SplashProvider extends ChangeNotifier {
  bool _isLoading = true;
  bool _isAuthenticated = false;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> initializeApp() async {
    try {
      // Play app launch sound if available
      await AudioService.playAppLaunchSound();

      // Check authentication status
      await _checkAuthStatus();

      // Add a small delay to show the splash screen
      await Future.delayed(const Duration(milliseconds: 1500));
    } catch (e) {
      debugPrint('Initialization error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _checkAuthStatus() async {
    final token = await StorageService.getToken();
    _isAuthenticated = token != null && token.isNotEmpty;
    notifyListeners();
  }
}

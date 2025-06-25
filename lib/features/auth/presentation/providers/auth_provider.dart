// lib/features/auth/presentation/providers/auth_provider.dart - Improved
import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
  otpRequired,
}

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;

  AuthProvider({required AuthRepository repository}) : _repository = repository;

  // State
  AuthStatus _status = AuthStatus.initial;
  UserEntity? _user;
  String? _errorMessage;
  String? _firebaseToken;

  // Navigation state
  bool _hasNavigatedToOtp = false;
  bool _hasNavigatedToHome = false;

  // Getters
  AuthStatus get status => _status;
  UserEntity? get user => _user;
  String? get errorMessage => _errorMessage;
  String? get firebaseToken => _firebaseToken;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isLoading => _status == AuthStatus.loading;
  bool get isOtpRequired => _status == AuthStatus.otpRequired;
  bool get hasError => _status == AuthStatus.error && _errorMessage != null;

  // Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final otpController = TextEditingController();
  final referralCodeController = TextEditingController();

  // Form state
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String _selectedGender = '';
  DateTime? _selectedDateOfBirth;
  String _selectedProfession = '';
  String _selectedCountry = '';
  String _selectedState = '';
  String _selectedStateCode = '';
  String _selectedDistrict = '';
  String _verificationMethod = 'email';
  File? _profileImage;
  bool _agreeToTerms = false;

  // Form getters
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;
  String get selectedGender => _selectedGender;
  DateTime? get selectedDateOfBirth => _selectedDateOfBirth;
  String get selectedProfession => _selectedProfession;
  String get selectedCountry => _selectedCountry;
  String get selectedState => _selectedState;
  String get selectedDistrict => _selectedDistrict;
  String get verificationMethod => _verificationMethod;
  File? get profileImage => _profileImage;
  bool get agreeToTerms => _agreeToTerms;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    confirmPasswordController.dispose();
    otpController.dispose();
    referralCodeController.dispose();
    super.dispose();
  }

  // Navigation state management
  void resetNavigationFlags() {
    _hasNavigatedToOtp = false;
    _hasNavigatedToHome = false;
  }

  bool get canNavigateToOtp => !_hasNavigatedToOtp;
  bool get canNavigateToHome => !_hasNavigatedToHome;

  void markOtpNavigated() {
    _hasNavigatedToOtp = true;
  }

  void markHomeNavigated() {
    _hasNavigatedToHome = true;
  }

  // Methods
  void setFirebaseToken(String? token) {
    _firebaseToken = token;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }

  void setGender(String gender) {
    _selectedGender = gender;
    notifyListeners();
  }

  void setDateOfBirth(DateTime date) {
    _selectedDateOfBirth = date;
    notifyListeners();
  }

  void setProfession(String profession) {
    _selectedProfession = profession;
    notifyListeners();
  }

  void setLocation({
    String? country,
    String? state,
    String? district,
    String? stateCode,
  }) {
    if (country != null) {
      _selectedCountry = country;
      if (_selectedCountry != country) {
        _selectedState = '';
        _selectedDistrict = '';
      }
    }
    if (state != null) {
      _selectedStateCode = stateCode ?? '';
      _selectedState = state;
      if (_selectedState != state) {
        _selectedDistrict = '';
      }
    }
    if (district != null) _selectedDistrict = district;
    notifyListeners();
  }

  void setVerificationMethod(String method) {
    _verificationMethod = method;
    notifyListeners();
  }

  void setProfileImage(File? image) {
    _profileImage = image;
    notifyListeners();
  }

  void setAgreeToTerms(bool agree) {
    _agreeToTerms = agree;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    if (_status == AuthStatus.error) {
      _status = AuthStatus.initial;
      notifyListeners();
    }
  }

  Future<void> login() async {
    if (!_validateLoginForm()) return;
    _setLoading();
    resetNavigationFlags();

    final result = await _repository.login(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      firebaseId: _firebaseToken ?? "empty token",
    );

    result.fold((failure) {
      if (failure.message.toLowerCase().contains('otp') ||
          failure.message.toLowerCase().contains('verification')) {
        _setOtpRequired();
      } else {
        _setError(failure.message);
      }
    }, (user) => _setAuthenticated(user));
  }

  Future<void> register() async {
    if (!_validateRegisterForm()) return;
    _setLoading();
    resetNavigationFlags();

    final result = await _repository.register(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      password: passwordController.text.trim(),
      dialCode: '+91',
      gender: _selectedGender.toLowerCase(),
      dateOfBirth: _selectedDateOfBirth!.toIso8601String(),
      profession: _selectedProfession,
      country: _selectedCountry,
      state: _selectedState,
      stateCode: _selectedStateCode,
      district: _selectedDistrict.isNotEmpty ? _selectedDistrict : null,
      verificationMethod: _verificationMethod,
      profileImage: _profileImage?.path,
      referralCode: referralCodeController.text.trim().isNotEmpty
          ? referralCodeController.text.trim()
          : null,
      firebaseId: _firebaseToken ?? "empty token",
    );

    result.fold(
      (failure) {
        _setError(failure.message);
      },
      (success) {
        if (success) {
          _setOtpRequired();
        }
      },
    );
  }

  Future<void> verifyOtp({bool isLogin = false}) async {
    if (otpController.text.trim().length != 6) {
      _setError('Please enter a valid 6-digit OTP');
      return;
    }

    _setLoading();
    resetNavigationFlags();

    final result = await _repository.verifyOtp(
      otp: otpController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      dialCode: '+91',
      method: _verificationMethod,
      firebaseId: _firebaseToken ?? "empty token",
    );

    result.fold((failure) => _setError(failure.message), (success) {
      if (success) {
        checkAuthStatus();
      }
    });
  }

  Future<void> resendOtp() async {
    _setLoading();

    final result = await _repository.resendOtp(
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      dialCode: '+91',
      method: _verificationMethod,
    );

    result.fold((failure) => _setError(failure.message), (success) {
      if (success) {
        _setStatus(AuthStatus.otpRequired);
      }
    });
  }

  Future<void> forgotPassword(String email) async {
    _setLoading();

    final result = await _repository.forgotPassword(email: email);

    result.fold((failure) => _setError(failure.message), (success) {
      if (success) {
        _setStatus(AuthStatus.initial);
      }
    });
  }

  Future<void> logout() async {
    _setLoading();
    resetNavigationFlags();

    final result = await _repository.logout();

    result.fold((failure) => _setError(failure.message), (_) {
      _user = null;
      _firebaseToken = null;
      _setStatus(AuthStatus.unauthenticated);
      _clearControllers();
    });
  }

  Future<void> checkAuthStatus() async {
    resetNavigationFlags();

    if (StorageService.isLoggedIn()) {
      final result = await _repository.getCurrentUser();
      result.fold(
        (failure) => _setStatus(AuthStatus.unauthenticated),
        (user) => _setAuthenticated(user),
      );
    } else {
      _setStatus(AuthStatus.unauthenticated);
    }
  }

  // Private methods
  void _setLoading() {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setAuthenticated(UserEntity user) {
    _user = user;
    _status = AuthStatus.authenticated;
    _errorMessage = null;
    StorageService.setLoggedIn(true);
    notifyListeners();
  }

  void _setError(String message) {
    _status = AuthStatus.error;
    _errorMessage = message;
    notifyListeners();
  }

  void _setOtpRequired() {
    _status = AuthStatus.otpRequired;
    _errorMessage = null;
    notifyListeners();
  }

  void _setStatus(AuthStatus status) {
    _status = status;
    notifyListeners();
  }

  bool _validateLoginForm() {
    if (emailController.text.trim().isEmpty) {
      _setError('Please enter your email');
      return false;
    }

    if (!emailController.text.trim().isValidEmail()) {
      _setError('Please enter a valid email');
      return false;
    }

    if (passwordController.text.trim().isEmpty) {
      _setError('Please enter your password');
      return false;
    }

    return true;
  }

  bool _validateRegisterForm() {
    if (nameController.text.trim().isEmpty) {
      _setError('Please enter your full name');
      return false;
    }

    if (nameController.text.trim().length < 2) {
      _setError('Name must be at least 2 characters long');
      return false;
    }

    if (emailController.text.trim().isEmpty) {
      _setError('Please enter your email address');
      return false;
    }

    if (!emailController.text.trim().isValidEmail()) {
      _setError('Please enter a valid email address');
      return false;
    }

    if (phoneController.text.trim().isEmpty) {
      _setError('Please enter your phone number');
      return false;
    }

    if (phoneController.text.trim().length < 10) {
      _setError('Please enter a valid phone number');
      return false;
    }

    if (_selectedGender.isEmpty) {
      _setError('Please select your gender');
      return false;
    }

    if (_selectedDateOfBirth == null) {
      _setError('Please select your date of birth');
      return false;
    }

    final age = DateTime.now().difference(_selectedDateOfBirth!).inDays / 365;
    if (age < 13) {
      _setError('You must be at least 13 years old to register');
      return false;
    }

    if (_selectedProfession.isEmpty) {
      _setError('Please select your profession');
      return false;
    }

    if (_selectedCountry.isEmpty) {
      _setError('Please select your country');
      return false;
    }

    if (_selectedState.isEmpty) {
      _setError('Please select your state');
      return false;
    }

    if (passwordController.text.trim().length < 8) {
      _setError('Password must be at least 8 characters long');
      return false;
    }

    final password = passwordController.text.trim();
    if (!_isPasswordStrong(password)) {
      _setError(
        'Password must contain at least one uppercase letter, one lowercase letter, and one number',
      );
      return false;
    }

    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      _setError('Passwords do not match');
      return false;
    }

    if (!_agreeToTerms) {
      _setError('Please agree to the Terms of Service and Privacy Policy');
      return false;
    }

    return true;
  }

  bool _isPasswordStrong(String password) {
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasNumber = password.contains(RegExp(r'[0-9]'));
    return hasUppercase && hasLowercase && hasNumber;
  }

  void _clearControllers() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    phoneController.clear();
    confirmPasswordController.clear();
    otpController.clear();
    referralCodeController.clear();
    _selectedGender = '';
    _selectedDateOfBirth = null;
    _selectedProfession = '';
    _selectedCountry = '';
    _selectedState = '';
    _selectedDistrict = '';
    _profileImage = null;
    _agreeToTerms = false;
  }
}

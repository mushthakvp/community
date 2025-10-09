import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/services/cloudinary_service.dart';
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
  success,
}

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;

  AuthProvider({required AuthRepository repository}) : _repository = repository;

  // State
  AuthStatus _status = AuthStatus.initial;
  UserEntity? _user;
  String? _errorMessage;
  String? _successMessage;
  String? _firebaseToken;

  // Navigation state
  bool _hasNavigatedToOtp = false;
  bool _hasNavigatedToHome = false;

  // Image upload state
  bool _isUploadingImage = false;
  double _uploadProgress = 0.0;
  String? _uploadedImageUrl;

  // Getters
  AuthStatus get status => _status;
  UserEntity? get user => _user;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  String? get firebaseToken => _firebaseToken;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isLoading => _status == AuthStatus.loading;
  bool get isOtpRequired => _status == AuthStatus.otpRequired;
  bool get hasError => _status == AuthStatus.error && _errorMessage != null;
  bool get hasSuccess =>
      _status == AuthStatus.success && _successMessage != null;

  // Image upload getters
  bool get isUploadingImage => _isUploadingImage;
  double get uploadProgress => _uploadProgress;
  String? get uploadedImageUrl => _uploadedImageUrl;

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

  String _selectedCountryCode = 'AE';
  String _selectedDialCode = '+971';
  int _selectedCountryLength = 9;

  String get selectedCountryCode => _selectedCountryCode;
  String get selectedDialCode => _selectedDialCode;
  int get selectedCountryLength => _selectedCountryLength;

  void setCountryCode({
    required String countryCode,
    required String dialCode,
    String? countryName,
    required int length,
  }) {
    _selectedCountryCode = countryCode;
    _selectedDialCode = dialCode;
    _selectedCountryLength = length;
    if (countryName != null) {
      if (_selectedCountry.isEmpty || _selectedCountry != countryName) {
        _selectedCountry = countryName;
        _selectedState = '';
        _selectedDistrict = '';
        _selectedStateCode = '';
      }
    }
    setLocation(
      country: countryName,
      countryCode: countryCode,
      onSuccess: (String name) {
        debugPrint('Country set successfully from phone code: $name');
      },
    );

    notifyListeners();
  }

  void setLocation({
    String? country,
    String? state,
    String? district,
    String? stateCode,
    String? countryCode,
    Function(String)? onSuccess,
  }) {
    if (country != null) {
      _selectedCountry = country;
      _selectedCountryCode = countryCode ?? '';
      onSuccess?.call(country);
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
    _uploadedImageUrl = null;
    notifyListeners();
  }

  void setAgreeToTerms(bool agree) {
    _agreeToTerms = agree;
    notifyListeners();
  }

  Future<void> uploadProfileImage() async {
    if (_profileImage == null) return;
    _isUploadingImage = true;
    _uploadProgress = 0.0;
    notifyListeners();
    try {
      final imageUrl = await CloudinaryService.uploadSingleImage(
        file: _profileImage!,
        folder: 'vivera_profiles',
        onProgress: (progress) {
          _uploadProgress = progress;
          notifyListeners();
        },
      );
      if (imageUrl != null) {
        _uploadedImageUrl = imageUrl;
        debugPrint('Image uploaded successfully: $imageUrl');
      } else {
        _setError('Failed to upload profile image');
      }
    } catch (e) {
      debugPrint('Image upload error: $e');
      _setError('Failed to upload profile image: $e');
    } finally {
      _isUploadingImage = false;
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

  // In AuthProvider.register() method, update the repository call:

  Future<void> register() async {
    if (!_validateRegisterForm()) return;
    _setLoading();
    resetNavigationFlags();
    if (_profileImage != null && _uploadedImageUrl == null) {
      await uploadProfileImage();
      if (_uploadedImageUrl == null) {
        _setError('Failed to upload profile image. Please try again.');
        return;
      }
    }
    final result = await _repository.register(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      password: passwordController.text.trim(),
      dialCode: _selectedDialCode,
      gender: _selectedGender.toLowerCase(),
      dateOfBirth: _selectedDateOfBirth!.toIso8601String(),
      profession: _selectedProfession,
      country: _selectedCountry,
      state: _selectedState,
      stateCode: _selectedStateCode,
      district: _selectedDistrict.isNotEmpty ? _selectedDistrict : null,
      verificationMethod: _verificationMethod,
      profileImage: _uploadedImageUrl,
      referralCode: referralCodeController.text.trim().isNotEmpty
          ? referralCodeController.text.trim()
          : null,
      firebaseId: _firebaseToken ?? "empty token",
    );
    result.fold(
      (failure) {
        debugPrint('Registration failed: ${failure.message}');
        _setError(failure.message);
      },
      (success) {
        if (success) {
          _setOtpRequired();
        } else {
          _setError('Registration failed. Please try again.');
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
      dialCode: _selectedDialCode,
      method: _verificationMethod,
      firebaseId: _firebaseToken ?? "empty token",
    );

    result.fold(
      (failure) {
        debugPrint('OTP Verification Failed: ${failure.message}');

        if (failure.message.toLowerCase().contains('verified') ||
            failure.message.toLowerCase().contains('success')) {
          debugPrint('OTP Verification Successful (from error message)');
          _handleOtpSuccess();
        } else {
          _setError(failure.message);
        }
      },
      (user) {
        debugPrint('OTP Verification Successful');
        _handleOtpSuccess(user);
      },
    );
  }

  Future<void> resendOtp() async {
    _setLoading();
    final result = await _repository.resendOtp(
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      dialCode: _selectedCountryCode,
      method: _verificationMethod,
    );
    result.fold((failure) => _setError(failure.message), (success) {
      if (success) {
        _setStatus(AuthStatus.otpRequired);
      }
    });
  }

  void _handleOtpSuccess([UserEntity? user]) async {
    otpController.clear();
    _errorMessage = null;
    _successMessage = 'OTP verified successfully!';

    if (user != null) {
      _user = user;
    } else {
      _user = UserEntity(
        id: await StorageService.getUserId() ?? '',
        name: nameController.text.trim().isNotEmpty
            ? nameController.text.trim()
            : (await StorageService.getUserData())['name'] ?? '',
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        profileImage: _uploadedImageUrl,
        isOtpVerified: true,
        profileCompleted: true,
      );
    }

    _status = AuthStatus.authenticated;
    await StorageService.setLoggedIn(true);
    notifyListeners();
  }

  void _setAuthenticated(UserEntity user) {
    _user = user;
    _status = AuthStatus.authenticated;
    _errorMessage = null;
    _successMessage = 'Authentication successful!';
    StorageService.setLoggedIn(true);
    notifyListeners();
  }

  void _setError(String message) {
    _status = AuthStatus.error;
    _errorMessage = message;
    _successMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    _successMessage = null;
    resetNavigationFlags();
    if (_status == AuthStatus.error || _status == AuthStatus.success) {
      _status = _user != null ? AuthStatus.authenticated : AuthStatus.initial;
    }
    notifyListeners();
  }

  void resetRegistrationState() {
    _errorMessage = null;
    _successMessage = null;
    _status = AuthStatus.initial;
    _isUploadingImage = false;
    _uploadProgress = 0.0;
    resetNavigationFlags();
    notifyListeners();
  }

  bool get shouldShowError =>
      _status == AuthStatus.error && _errorMessage != null;

  bool get shouldShowSuccess =>
      _successMessage != null && _status == AuthStatus.authenticated;

  // Future<void> resendOtp() async {
  //   _setLoading();
  //   final result = await _repository.resendOtp(
  //     email: emailController.text.trim(),
  //     phone: phoneController.text.trim(),
  //     dialCode: _selectedCountryCode,
  //     method: _verificationMethod,
  //   );
  //   result.fold((failure) => _setError(failure.message), (success) {
  //     if (success) {
  //       _setStatus(AuthStatus.otpRequired);
  //     }
  //   });
  // }

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
    _successMessage = null;
    notifyListeners();
  }

  void _setOtpRequired() {
    _status = AuthStatus.otpRequired;
    _errorMessage = null;
    _successMessage = null;
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

    // if (phoneController.text.trim().length != _selectedCountryLength) {
    //   _setError(
    //     'Please enter a valid $_selectedCountryLength-digit phone number',
    //   );
    //   return false;
    // }

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
    _uploadedImageUrl = null;
    _agreeToTerms = false;
  }
}

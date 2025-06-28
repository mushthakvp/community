import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/utils/result.dart';
import '../../domain/entities/loyalty_card_entity.dart';
import '../../domain/entities/point_transaction_entity.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/usecases/change_password_usecase.dart';
import '../../domain/usecases/claim_loyalty_points_usecase.dart';
import '../../domain/usecases/get_loyalty_card_usecase.dart';
import '../../domain/usecases/get_point_transactions_usecase.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';

enum ProfileState { initial, loading, success, error }

class ProfileProvider extends ChangeNotifier {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final ChangePasswordUseCase changePasswordUseCase;
  final GetLoyaltyCardUseCase getLoyaltyCardUseCase;
  final ClaimLoyaltyPointsUseCase claimLoyaltyPointsUseCase;
  final GetPointTransactionsUseCase getPointTransactionsUseCase;

  ProfileProvider({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
    required this.changePasswordUseCase,
    required this.getLoyaltyCardUseCase,
    required this.claimLoyaltyPointsUseCase,
    required this.getPointTransactionsUseCase,
  });

  // Profile State
  ProfileState _profileState = ProfileState.initial;
  ProfileEntity? _profile;
  String? _profileError;

  // Loyalty Card State
  ProfileState _loyaltyCardState = ProfileState.initial;
  LoyaltyCardEntity? _loyaltyCard;
  String? _loyaltyCardError;

  // Point Transactions State
  ProfileState _transactionsState = ProfileState.initial;
  List<PointTransactionEntity> _transactions = [];
  String? _transactionsError;
  int _currentPage = 1;
  bool _hasMoreTransactions = true;
  String _selectedTransactionStatus = 'claimed';

  // Update Profile State
  ProfileState _updateProfileState = ProfileState.initial;
  String? _updateProfileError;

  // Change Password State
  ProfileState _changePasswordState = ProfileState.initial;
  String? _changePasswordError;

  // Password visibility
  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Selected profile image
  File? _selectedProfileImage;

  // Tab selection for loyalty points
  int _selectedTab = 0;

  // Getters
  ProfileState get profileState => _profileState;
  ProfileEntity? get profile => _profile;
  String? get profileError => _profileError;

  ProfileState get loyaltyCardState => _loyaltyCardState;
  LoyaltyCardEntity? get loyaltyCard => _loyaltyCard;
  String? get loyaltyCardError => _loyaltyCardError;

  ProfileState get transactionsState => _transactionsState;
  List<PointTransactionEntity> get transactions => _transactions;
  String? get transactionsError => _transactionsError;
  bool get hasMoreTransactions => _hasMoreTransactions;

  ProfileState get updateProfileState => _updateProfileState;
  String? get updateProfileError => _updateProfileError;

  ProfileState get changePasswordState => _changePasswordState;
  String? get changePasswordError => _changePasswordError;

  bool get isCurrentPasswordVisible => _isCurrentPasswordVisible;
  bool get isNewPasswordVisible => _isNewPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;

  File? get selectedProfileImage => _selectedProfileImage;
  int get selectedTab => _selectedTab;

  // Profile Methods
  Future<void> getProfile() async {
    _profileState = ProfileState.loading;
    _profileError = null;
    notifyListeners();

    final result = await getProfileUseCase();

    if (result is Success<ProfileEntity>) {
      _profile = result.data;
      _profileState = ProfileState.success;
      _profileError = null;
    } else if (result is Error<ProfileEntity>) {
      _profileState = ProfileState.error;
      _profileError = result.message;
    }

    notifyListeners();
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
    required String dialCode,
  }) async {
    _updateProfileState = ProfileState.loading;
    _updateProfileError = null;
    notifyListeners();

    final result = await updateProfileUseCase(
      name: name,
      email: email,
      phone: phone,
      dialCode: dialCode,
      profileImage: _selectedProfileImage,
    );

    if (result is Success<ProfileEntity>) {
      _profile = result.data;
      _updateProfileState = ProfileState.success;
      _updateProfileError = null;
      _selectedProfileImage = null; // Clear selected image
    } else if (result is Error<ProfileEntity>) {
      _updateProfileState = ProfileState.error;
      _updateProfileError = result.message;
    }

    notifyListeners();
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    _changePasswordState = ProfileState.loading;
    _changePasswordError = null;
    notifyListeners();

    final result = await changePasswordUseCase(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );

    if (result is Success<void>) {
      _changePasswordState = ProfileState.success;
      _changePasswordError = null;
    } else if (result is Error<void>) {
      _changePasswordState = ProfileState.error;
      _changePasswordError = result.message;
    }

    notifyListeners();
  }

  // Loyalty Card Methods
  Future<void> getLoyaltyCard() async {
    _loyaltyCardState = ProfileState.loading;
    _loyaltyCardError = null;
    notifyListeners();

    final result = await getLoyaltyCardUseCase();

    if (result is Success<LoyaltyCardEntity>) {
      _loyaltyCard = result.data;
      _loyaltyCardState = ProfileState.success;
      _loyaltyCardError = null;
    } else if (result is Error<LoyaltyCardEntity>) {
      _loyaltyCardState = ProfileState.error;
      _loyaltyCardError = result.message;
    }

    notifyListeners();
  }

  Future<void> claimLoyaltyPoints() async {
    final result = await claimLoyaltyPointsUseCase();

    if (result is Success<void>) {
      // Refresh loyalty card and transactions
      await getLoyaltyCard();
      await getPointTransactions(refresh: true);
    } else if (result is Error<void>) {
      _loyaltyCardError = result.message;
      notifyListeners();
    }
  }

  // Point Transactions Methods
  Future<void> getPointTransactions({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _transactions.clear();
      _hasMoreTransactions = true;
    }

    if (!_hasMoreTransactions) return;

    _transactionsState = ProfileState.loading;
    _transactionsError = null;
    notifyListeners();

    final result = await getPointTransactionsUseCase(
      status: _selectedTransactionStatus,
      page: _currentPage,
    );

    if (result is Success<List<PointTransactionEntity>>) {
      final newTransactions = result.data;

      if (refresh) {
        _transactions = newTransactions;
      } else {
        _transactions.addAll(newTransactions);
      }

      _hasMoreTransactions = newTransactions.isNotEmpty;
      if (_hasMoreTransactions) {
        _currentPage++;
      }

      _transactionsState = ProfileState.success;
      _transactionsError = null;
    } else if (result is Error<List<PointTransactionEntity>>) {
      _transactionsState = ProfileState.error;
      _transactionsError = result.message;
    }

    notifyListeners();
  }

  void selectTab(int tabIndex) {
    _selectedTab = tabIndex;
    _selectedTransactionStatus = tabIndex == 0 ? 'claimed' : 'earn';
    getPointTransactions(refresh: true);
  }

  // UI Helper Methods
  void toggleCurrentPasswordVisibility() {
    _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
    notifyListeners();
  }

  void toggleNewPasswordVisibility() {
    _isNewPasswordVisible = !_isNewPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }

  void selectProfileImage(File image) {
    _selectedProfileImage = image;
    notifyListeners();
  }

  void clearSelectedProfileImage() {
    _selectedProfileImage = null;
    notifyListeners();
  }

  // Reset methods
  void resetUpdateProfileState() {
    _updateProfileState = ProfileState.initial;
    _updateProfileError = null;
    notifyListeners();
  }

  void resetChangePasswordState() {
    _changePasswordState = ProfileState.initial;
    _changePasswordError = null;
    notifyListeners();
  }
}

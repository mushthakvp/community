import 'package:flutter/material.dart';

import '../../../../core/utils/result.dart';
import '../../domain/entities/redemption_entity.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/entities/user_details_entity.dart';
import '../../domain/usecases/get_user_redemption_details_usecase.dart';
import '../../domain/usecases/get_wallet_transactions_usecase.dart';

class RedemptionProvider extends ChangeNotifier {
  final GetWalletTransactionsUseCase getWalletTransactionsUseCase;
  final GetUserRedemptionDetailsUseCase getUserRedemptionDetailsUseCase;

  RedemptionProvider({
    required this.getWalletTransactionsUseCase,
    required this.getUserRedemptionDetailsUseCase,
  });

  // Loading states
  bool _isLoadingTransactions = false;
  bool _isLoadingUserDetails = false;
  bool _isLoadingMore = false;

  // Data states
  UserDetailsEntity? _userDetails;
  List<TransactionEntity> _allTransactions = [];
  List<bool> _transactionDetailsVisible = [];

  // Filter states
  String _selectedFilter = 'All';
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isShowingCommunityId = false;

  // Pagination
  int _currentPage = 1;
  bool _hasMoreData = true;
  int? _totalRecords;

  // Error states
  String? _error;

  // Getters
  bool get isLoadingTransactions => _isLoadingTransactions;
  bool get isLoadingUserDetails => _isLoadingUserDetails;
  bool get isLoadingMore => _isLoadingMore;
  UserDetailsEntity? get userDetails => _userDetails;
  List<TransactionEntity> get allTransactions => _allTransactions;
  List<bool> get transactionDetailsVisible => _transactionDetailsVisible;
  String get selectedFilter => _selectedFilter;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  bool get isShowingCommunityId => _isShowingCommunityId;
  bool get hasMoreData => _hasMoreData;
  String? get error => _error;
  int? get totalRecords => _totalRecords;

  // For compatibility with the UI widgets
  RedemptionEntity? get redemptionData => RedemptionEntity(
    success: true,
    message: 'Success',
    totalRecords: _totalRecords,
    transactions: _allTransactions,
  );

  // Initialize data
  Future<void> initialize() async {
    await getUserDetails();
    await getTransactions(isInitial: true);
  }

  // Get user details for redemption card
  Future<void> getUserDetails({bool forceRefresh = false}) async {
    _isLoadingUserDetails = true;
    _error = null;
    notifyListeners();

    final result = await getUserRedemptionDetailsUseCase();

    result.fold(
      onSuccess: (data) {
        _userDetails = data;
        _error = null;
      },
      onError: (error) {
        _error = error;
      },
    );

    _isLoadingUserDetails = false;
    notifyListeners();
  }

  // Get wallet transactions
  Future<void> getTransactions({
    bool isInitial = false,
    bool loadMore = false,
    bool forceRefresh = false,
  }) async {
    try {
      if (loadMore) {
        if (!_hasMoreData || _isLoadingMore) return;
        _isLoadingMore = true;
        _currentPage++;
      } else {
        _isLoadingTransactions = true;
        _currentPage = 1;
        _hasMoreData = true;
        if (isInitial || forceRefresh) {
          _allTransactions.clear();
        }
      }

      _error = null;
      notifyListeners();

      final result = await getWalletTransactionsUseCase(
        filter: _selectedFilter,
        fromDate: _startDate?.toIso8601String().substring(0, 10),
        toDate: _endDate?.toIso8601String().substring(0, 10),
        page: _currentPage,
      );

      result.fold(
        onSuccess: (data) {
          final newTransactions = data.transactions ?? [];

          if (loadMore) {
            _allTransactions.addAll(newTransactions);
            _hasMoreData = newTransactions.isNotEmpty;
          } else {
            _allTransactions = List<TransactionEntity>.from(newTransactions);
            _hasMoreData = newTransactions.isNotEmpty;
          }

          _totalRecords = data.totalRecords;

          _transactionDetailsVisible = List.filled(
            _allTransactions.length,
            false,
          );

          _error = null;
        },
        onError: (error) {
          _error = error;
          if (loadMore) {
            _currentPage--;
          }
        },
      );
    } catch (e) {
      _error = 'Exception in getTransactions: $e';
      if (loadMore) {
        _currentPage--;
      }
    } finally {
      _isLoadingTransactions = false;
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  // Change filter
  void changeFilter(String filter) {
    if (_selectedFilter == filter) return;

    _selectedFilter = filter;
    if (filter == 'All') {
      _startDate = null;
      _endDate = null;
    }
    getTransactions(isInitial: true, forceRefresh: true);
  }

  // Set date range filter
  Future<void> setDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );

    if (picked != null) {
      _startDate = picked.start;
      _endDate = picked.end;
      getTransactions(isInitial: true, forceRefresh: true);
    }
  }

  // Set custom date range
  void setCustomDateRange(DateTime startDate, DateTime endDate) {
    _startDate = startDate;
    _endDate = endDate;
    getTransactions(isInitial: true, forceRefresh: true);
  }

  // Clear date range filter
  void clearDateRange() {
    _startDate = null;
    _endDate = null;
    getTransactions(isInitial: true, forceRefresh: true);
  }

  // Check if date range is set
  bool get hasDateRange => _startDate != null && _endDate != null;

  // Toggle community ID visibility
  void toggleCommunityIdVisibility() {
    _isShowingCommunityId = !_isShowingCommunityId;
    notifyListeners();
  }

  // Toggle transaction details visibility
  void toggleTransactionDetails(int index) {
    if (index < _transactionDetailsVisible.length) {
      _transactionDetailsVisible[index] = !_transactionDetailsVisible[index];
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    _clearLocalData();
    await Future.wait([
      getUserDetails(forceRefresh: true),
      getTransactions(isInitial: true, forceRefresh: true),
    ]);
  }

  // FIXED: Method to refresh after wallet recharge
  Future<void> refreshAfterWalletRecharge() async {
    _clearLocalData();
    _userDetails = null;
    _allTransactions.clear();
    _transactionDetailsVisible.clear();

    notifyListeners();
    await Future.wait([
      getUserDetails(forceRefresh: true),
      getTransactions(isInitial: true, forceRefresh: true),
    ]);
  }

  void _clearLocalData() {
    _currentPage = 1;
    _hasMoreData = true;
    _totalRecords = null;
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}

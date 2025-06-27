import 'package:flutter/material.dart';

import '../../../../core/utils/result.dart';
import '../../domain/entities/redemption_entity.dart';
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
  RedemptionEntity? _redemptionData;
  UserDetailsEntity? _userDetails;
  List<bool> _transactionDetailsVisible = [];

  // Filter states
  String _selectedFilter = 'All';
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isShowingCommunityId = false;

  // Pagination
  int _currentPage = 1;
  bool _hasMoreData = true;

  // Error states
  String? _error;

  // Getters
  bool get isLoadingTransactions => _isLoadingTransactions;
  bool get isLoadingUserDetails => _isLoadingUserDetails;
  bool get isLoadingMore => _isLoadingMore;
  RedemptionEntity? get redemptionData => _redemptionData;
  UserDetailsEntity? get userDetails => _userDetails;
  List<bool> get transactionDetailsVisible => _transactionDetailsVisible;
  String get selectedFilter => _selectedFilter;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  bool get isShowingCommunityId => _isShowingCommunityId;
  bool get hasMoreData => _hasMoreData;
  String? get error => _error;

  // Initialize data
  Future<void> initialize() async {
    await getUserDetails();
    await getTransactions(isInitial: true);
  }

  // Get user details for redemption card
  Future<void> getUserDetails() async {
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
  }) async {
    if (loadMore) {
      if (!_hasMoreData || _isLoadingMore) return;
      _isLoadingMore = true;
      _currentPage++;
    } else {
      _isLoadingTransactions = true;
      _currentPage = 1;
      _hasMoreData = true;
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
        if (loadMore) {
          final currentTransactions = _redemptionData?.transactions ?? [];
          final newTransactions = data.transactions ?? [];
          _redemptionData = RedemptionEntity(
            success: data.success,
            message: data.message,
            totalRecords: data.totalRecords,
            transactions: [...currentTransactions, ...newTransactions],
          );
          _hasMoreData = newTransactions.isNotEmpty;
        } else {
          _redemptionData = data;
          _transactionDetailsVisible = List.filled(
            data.transactions?.length ?? 0,
            false,
          );
        }
        _error = null;
      },
      onError: (error) {
        _error = error;
        if (loadMore) {
          _currentPage--;
        }
      },
    );

    _isLoadingTransactions = false;
    _isLoadingMore = false;
    notifyListeners();
  }

  // Change filter
  void changeFilter(String filter) {
    if (_selectedFilter == filter) return;

    _selectedFilter = filter;
    if (filter == 'All') {
      _startDate = null;
      _endDate = null;
    }
    getTransactions(isInitial: true);
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
      getTransactions(isInitial: true);
    }
  }

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

  // Refresh data
  Future<void> refresh() async {
    await Future.wait([getUserDetails(), getTransactions(isInitial: true)]);
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/error/failures.dart';
import '../../../core/constants/vcart_colors.dart';
import '../../domain/entities/order_history.dart';
import '../../domain/entities/order_status.dart';
import '../../domain/usecases/get_order_history.dart';

class VCartOrderHistoryController extends GetxController {
  final GetOrderHistory getOrderHistoryUseCase;

  VCartOrderHistoryController({required this.getOrderHistoryUseCase});

  final _isLoading = false.obs;
  final _isLoadingMore = false.obs;
  final _hasError = false.obs;
  final _errorMessage = ''.obs;
  final _orderGroups = <OrderGroup>[].obs;
  final _availableYears = <int>[].obs;
  final _selectedYear = ''.obs;
  final _currentPage = 1.obs;
  final _hasMoreData = true.obs;
  final _isEmpty = false.obs;

  final ScrollController scrollController = ScrollController();

  static const int _itemsPerPage = 10;

  // Getters
  bool get isLoading => _isLoading.value;
  bool get isLoadingMore => _isLoadingMore.value;
  bool get hasError => _hasError.value;
  String get errorMessage => _errorMessage.value;
  List<OrderGroup> get orderGroups => _orderGroups;
  List<int> get availableYears => _availableYears;
  String get selectedYear => _selectedYear.value;
  bool get hasMoreData => _hasMoreData.value;
  bool get isEmpty => _isEmpty.value;

  @override
  void onInit() {
    super.onInit();
    _setupScrollController();
    loadOrderHistory();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void _setupScrollController() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (!isLoadingMore && hasMoreData) {
          loadMoreOrderHistory();
        }
      }
    });
  }

  Future<void> loadOrderHistory({bool refresh = false}) async {
    if (refresh) {
      _currentPage.value = 1;
      _orderGroups.clear();
      _hasMoreData.value = true;
    }

    _setLoading(true);
    _clearError();

    final result = await getOrderHistoryUseCase(
      GetOrderHistoryParams(
        page: _currentPage.value,
        limit: _itemsPerPage,
        year: _selectedYear.value.isEmpty ? null : _selectedYear.value,
      ),
    );

    result.fold(
      (failure) => _handleFailure(failure),
      (orderHistory) => _handleSuccess(orderHistory, refresh),
    );

    _setLoading(false);
  }

  Future<void> loadMoreOrderHistory() async {
    if (!hasMoreData || isLoadingMore) return;

    _setLoadingMore(true);
    _currentPage.value++;

    final result = await getOrderHistoryUseCase(
      GetOrderHistoryParams(
        page: _currentPage.value,
        limit: _itemsPerPage,
        year: _selectedYear.value.isEmpty ? null : _selectedYear.value,
      ),
    );

    result.fold((failure) {
      _currentPage.value--;
      _handleFailure(failure);
    }, (orderHistory) => _handleLoadMoreSuccess(orderHistory));

    _setLoadingMore(false);
  }

  void _handleSuccess(OrderHistory orderHistory, bool isRefresh) {
    if (isRefresh) {
      _orderGroups.clear();
    }

    _orderGroups.addAll(orderHistory.orders);
    _availableYears.assignAll(orderHistory.availableYears);

    final totalPages = orderHistory.pagination?.totalPages ?? 0;
    _hasMoreData.value = _currentPage.value < totalPages;

    _isEmpty.value = _orderGroups.isEmpty;
  }

  void _handleLoadMoreSuccess(OrderHistory orderHistory) {
    _orderGroups.addAll(orderHistory.orders);

    final totalPages = orderHistory.pagination?.totalPages ?? 0;
    _hasMoreData.value = _currentPage.value < totalPages;
  }

  Future<void> refreshOrderHistory() async {
    await loadOrderHistory(refresh: true);
  }

  void setYearFilter(String year) {
    if (_selectedYear.value != year) {
      _selectedYear.value = year;
      loadOrderHistory(refresh: true);
    }
  }

  void clearYearFilter() {
    setYearFilter('');
  }

  Color getStatusColor(String? status) {
    if (status == null) return VCartColors.textSecondary;

    final orderStatus = OrderStatus.fromString(status);
    switch (orderStatus) {
      case OrderStatus.orderPlaced:
        return VCartColors.textPrimary;
      case OrderStatus.delivered:
        return VCartColors.success;
      case OrderStatus.cancelled:
      case OrderStatus.returned:
        return VCartColors.error;
      case OrderStatus.shipped:
      case OrderStatus.packed:
      case OrderStatus.outForDelivery:
        return VCartColors.warning;
    }
  }

  String getStatusDisplayName(String? status) {
    if (status == null) return 'Unknown';
    return OrderStatus.fromString(status).displayName;
  }

  void _setLoading(bool value) {
    _isLoading.value = value;
  }

  void _setLoadingMore(bool value) {
    _isLoadingMore.value = value;
  }

  void _clearError() {
    _hasError.value = false;
    _errorMessage.value = '';
  }

  void _handleFailure(Failure failure) {
    _hasError.value = true;
    _errorMessage.value = failure.message;
    debugPrint('Order History Error: ${failure.message}');
  }
}

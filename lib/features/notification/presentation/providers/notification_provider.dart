// lib/features/notification/presentation/providers/notification_provider.dart
import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';

enum NotificationStatus { initial, loading, loaded, error, refreshing }

class NotificationProvider extends ChangeNotifier {
  final NotificationRepository _repository;

  NotificationProvider({required NotificationRepository repository})
    : _repository = repository;

  // State
  NotificationStatus _status = NotificationStatus.initial;
  List<NotificationEntity> _notifications = [];
  final Map<String, List<NotificationEntity>> _groupedNotifications = {};
  String? _errorMessage;
  int _unreadCount = 0;

  // Pagination
  int _currentPage = 1;
  bool _hasMoreData = true;
  bool _isLoadingMore = false;
  static const int _pageSize = 20;

  // Cache
  DateTime? _lastLoadTime;
  static const Duration _cacheValidDuration = Duration(minutes: 5);

  // Filters
  List<NotificationType> _selectedTypes = [];
  bool _showUnreadOnly = false;

  // Getters
  NotificationStatus get status => _status;
  List<NotificationEntity> get notifications => _notifications;
  Map<String, List<NotificationEntity>> get groupedNotifications =>
      _groupedNotifications;
  String? get errorMessage => _errorMessage;
  int get unreadCount => _unreadCount;
  List<NotificationType> get selectedTypes => _selectedTypes;
  bool get showUnreadOnly => _showUnreadOnly;
  bool get isLoading => _status == NotificationStatus.loading;
  bool get isRefreshing => _status == NotificationStatus.refreshing;
  bool get hasError => _status == NotificationStatus.error;
  bool get isEmpty => _notifications.isEmpty;
  bool get hasData => _notifications.isNotEmpty;
  bool get hasMoreData => _hasMoreData;
  bool get isLoadingMore => _isLoadingMore;

  // Public Methods
  Future<void> initialize() async {
    if (_shouldUseCachedData()) {
      _groupNotifications();
      return;
    }
    await loadNotifications();
  }

  Future<void> loadNotifications({bool forceRefresh = false}) async {
    if (_status == NotificationStatus.loading) return;

    if (forceRefresh || !_shouldUseCachedData()) {
      _currentPage = 1;
      _hasMoreData = true;
      _setLoading();
      await _fetchNotifications();
    } else {
      _groupNotifications();
      _setLoaded();
    }
  }

  Future<void> refreshNotifications() async {
    _currentPage = 1;
    _hasMoreData = true;
    _setRefreshing();
    await _fetchNotifications();
  }

  Future<void> loadMoreNotifications() async {
    if (_isLoadingMore || !_hasMoreData) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final result = await _repository.getNotifications(
        limit: _pageSize,
        offset: (_currentPage - 1) * _pageSize,
        unreadOnly: _showUnreadOnly,
        types: _selectedTypes.isNotEmpty ? _selectedTypes : null,
      );

      result.fold((failure) => _showError(failure.message), (newNotifications) {
        if (newNotifications.length < _pageSize) {
          _hasMoreData = false;
        }
        _notifications.addAll(newNotifications);
        _currentPage++;
        _groupNotifications();
      });
    } catch (e) {
      dev.log('Error loading more notifications: $e');
      _showError('Failed to load more notifications');
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      final result = await _repository.markNotificationAsRead(notificationId);
      result.fold((failure) => _showError(failure.message), (success) {
        if (success) {
          _updateNotificationInList(
            notificationId,
            (notification) => notification.copyWith(isRead: true),
          );
          _unreadCount = (_unreadCount - 1).clamp(0, double.infinity).toInt();
        }
      });
    } catch (e) {
      dev.log('Error marking notification as read: $e');
      _showError('Failed to mark notification as read');
    }
  }

  Future<void> markAllNotificationsAsRead() async {
    try {
      final result = await _repository.markAllNotificationsAsRead();
      result.fold((failure) => _showError(failure.message), (success) {
        if (success) {
          _notifications = _notifications
              .map((notification) => notification.copyWith(isRead: true))
              .toList();
          _unreadCount = 0;
          _groupNotifications();
        }
      });
    } catch (e) {
      dev.log('Error marking all notifications as read: $e');
      _showError('Failed to mark all notifications as read');
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      final result = await _repository.deleteNotification(notificationId);
      result.fold((failure) => _showError(failure.message), (success) {
        if (success) {
          final deletedNotification = _notifications.firstWhere(
            (n) => n.id == notificationId,
            orElse: () => NotificationEntity(
              id: '',
              title: '',
              message: '',
              createdAt: DateTime.now(),
            ),
          );

          _notifications.removeWhere((n) => n.id == notificationId);

          if (!deletedNotification.isRead) {
            _unreadCount = (_unreadCount - 1).clamp(0, double.infinity).toInt();
          }

          _groupNotifications();
        }
      });
    } catch (e) {
      dev.log('Error deleting notification: $e');
      _showError('Failed to delete notification');
    }
  }

  Future<void> clearAllNotifications() async {
    try {
      final result = await _repository.clearAllNotifications();
      result.fold((failure) => _showError(failure.message), (success) {
        if (success) {
          _notifications.clear();
          _groupedNotifications.clear();
          _unreadCount = 0;
          notifyListeners();
        }
      });
    } catch (e) {
      dev.log('Error clearing all notifications: $e');
      _showError('Failed to clear all notifications');
    }
  }

  Future<void> loadUnreadCount() async {
    try {
      final result = await _repository.getUnreadNotificationCount();
      result.fold(
        (failure) => dev.log('Failed to load unread count: ${failure.message}'),
        (count) {
          _unreadCount = count;
          notifyListeners();
        },
      );
    } catch (e) {
      dev.log('Error loading unread count: $e');
    }
  }

  void setTypeFilter(List<NotificationType> types) {
    _selectedTypes = types;
    _currentPage = 1;
    _hasMoreData = true;
    loadNotifications(forceRefresh: true);
  }

  void setUnreadFilter(bool unreadOnly) {
    _showUnreadOnly = unreadOnly;
    _currentPage = 1;
    _hasMoreData = true;
    loadNotifications(forceRefresh: true);
  }

  void clearFilters() {
    _selectedTypes.clear();
    _showUnreadOnly = false;
    _currentPage = 1;
    _hasMoreData = true;
    loadNotifications(forceRefresh: true);
  }

  // Private Methods
  Future<void> _fetchNotifications() async {
    try {
      final result = await _repository.getNotifications(
        limit: _pageSize,
        offset: 0,
        unreadOnly: _showUnreadOnly,
        types: _selectedTypes.isNotEmpty ? _selectedTypes : null,
      );

      result.fold((failure) => _setError(_getErrorMessage(failure)), (
        notifications,
      ) {
        _notifications = notifications;
        _lastLoadTime = DateTime.now();

        if (notifications.length < _pageSize) {
          _hasMoreData = false;
        }

        _groupNotifications();
        _setLoaded();

        // Load unread count separately
        loadUnreadCount();
      });
    } catch (e) {
      dev.log('Error fetching notifications: $e');
      _setError('Failed to load notifications. Please try again.');
    }
  }

  void _setLoading() {
    _status = NotificationStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setRefreshing() {
    _status = NotificationStatus.refreshing;
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoaded() {
    _status = NotificationStatus.loaded;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _status = NotificationStatus.error;
    _errorMessage = message;
    dev.log('Notification provider error: $message');
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

  void _groupNotifications() {
    _groupedNotifications.clear();

    for (final notification in _notifications) {
      final dateKey = notification.dateKey;
      if (!_groupedNotifications.containsKey(dateKey)) {
        _groupedNotifications[dateKey] = [];
      }
      _groupedNotifications[dateKey]!.add(notification);
    }

    // Sort each group by creation time (newest first)
    _groupedNotifications.forEach((key, notifications) {
      notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    });

    notifyListeners();
  }

  void _updateNotificationInList(
    String notificationId,
    NotificationEntity Function(NotificationEntity) updater,
  ) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = updater(_notifications[index]);
      _groupNotifications();
    }
  }

  bool _shouldUseCachedData() {
    return _notifications.isNotEmpty &&
        _lastLoadTime != null &&
        DateTime.now().difference(_lastLoadTime!) < _cacheValidDuration;
  }

  String _getErrorMessage(Failure failure) {
    if (failure is NetworkFailure) {
      return 'No internet connection. Please check your network.';
    } else if (failure is ServerFailure) {
      return failure.message;
    } else if (failure is ValidationFailure) {
      return failure.message;
    } else {
      return 'Something went wrong. Please try again.';
    }
  }

  // Debug methods
  void debugPrintNotifications() {
    dev.log('Total notifications: ${_notifications.length}');
    dev.log('Grouped notifications: ${_groupedNotifications.length}');
    dev.log('Unread count: $_unreadCount');
    dev.log('Selected types: $_selectedTypes');
    dev.log('Show unread only: $_showUnreadOnly');
  }
}

import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:livera/core/utils/extensions.dart';

import '../../domain/entities/birthday_wish_entity.dart';
import '../../domain/entities/community_entity.dart';
import '../../domain/entities/friend_entity.dart';
import '../../domain/usecases/get_birthday_friends_usecase.dart';
import '../../domain/usecases/get_communities_usecase.dart';
import '../../domain/usecases/get_friends_usecase.dart';
import '../../domain/usecases/manage_friend_requests_usecase.dart';
import '../../domain/usecases/send_birthday_wish_usecase.dart';

enum ChatStatus { initial, loading, loaded, error, refreshing }

class ChatProvider extends ChangeNotifier {
  // Use cases
  final GetCommunitiesUseCase _getCommunitiesUseCase;
  final GetFriendsUseCase _getFriendsUseCase;
  final GetBirthdayFriendsUseCase _getBirthdayFriendsUseCase;
  final ManageFriendRequestsUseCase _manageFriendRequestsUseCase;
  final SendBirthdayWishUseCase _sendBirthdayWishUseCase;

  ChatProvider({
    required GetCommunitiesUseCase getCommunitiesUseCase,
    required GetFriendsUseCase getFriendsUseCase,
    required GetBirthdayFriendsUseCase getBirthdayFriendsUseCase,
    required ManageFriendRequestsUseCase manageFriendRequestsUseCase,
    required SendBirthdayWishUseCase sendBirthdayWishUseCase,
  }) : _getCommunitiesUseCase = getCommunitiesUseCase,
       _getFriendsUseCase = getFriendsUseCase,
       _getBirthdayFriendsUseCase = getBirthdayFriendsUseCase,
       _manageFriendRequestsUseCase = manageFriendRequestsUseCase,
       _sendBirthdayWishUseCase = sendBirthdayWishUseCase;

  // State
  ChatStatus _status = ChatStatus.initial;
  List<CommunityEntity> _recommendedCommunities = [];
  List<CommunityEntity> _myCommunities = [];
  List<FriendEntity> _friends = [];
  List<FriendEntity> _friendRequests = [];
  List<BirthdayWishEntity> _birthdayFriends = [];
  String? _errorMessage;

  // UI State
  String _chatType = 'Explore';
  String _selectedMyGroupItem = 'Recently';

  // Cache
  DateTime? _lastLoadTime;
  static const Duration _cacheValidDuration = Duration(minutes: 5);

  // Getters
  ChatStatus get status => _status;
  List<CommunityEntity> get recommendedCommunities => _recommendedCommunities;
  List<CommunityEntity> get myCommunities => _myCommunities;
  List<FriendEntity> get friends => _friends;
  List<FriendEntity> get friendRequests => _friendRequests;
  List<BirthdayWishEntity> get birthdayFriends => _birthdayFriends;
  String? get errorMessage => _errorMessage;
  String get chatType => _chatType;
  String get selectedMyGroupItem => _selectedMyGroupItem;
  bool get isLoading => _status == ChatStatus.loading;
  bool get hasError => _status == ChatStatus.error;
  bool get isEmpty => _recommendedCommunities.isEmpty && _myCommunities.isEmpty;
  bool get hasData =>
      _recommendedCommunities.isNotEmpty || _myCommunities.isNotEmpty;

  // Public Methods
  Future<void> initializeChat() async {
    if (_shouldUseCachedData()) {
      _setLoaded();
      return;
    }
    await loadInitialData();
  }

  Future<void> loadInitialData({bool forceRefresh = false}) async {
    if (_status == ChatStatus.loading) return;

    if (forceRefresh || !_shouldUseCachedData()) {
      _setLoading();
      await Future.wait([
        loadCommunities(),
        loadFriends(type: 'recent'),
        loadBirthdayFriends(),
      ]);
      _setLoaded();
    }
  }

  Future<void> refreshData() async {
    _setRefreshing();
    await loadInitialData(forceRefresh: true);
  }

  Future<void> loadCommunities({String? status, String? type}) async {
    try {
      final result = await _getCommunitiesUseCase.call(
        status: status ?? 'recommended',
        type: type,
      );

      result.fold((failure) => _showError(failure.userFriendlyMessage), (
        communities,
      ) {
        if (status == 'recommended' || status == null) {
          _recommendedCommunities = communities;
        } else {
          _myCommunities = communities;
        }
        _lastLoadTime = DateTime.now();
        notifyListeners();
      });
    } catch (e) {
      dev.log('Error loading communities: $e');
      _showError('Failed to load communities. Please try again.');
    }
  }

  Future<void> loadFriends({required String type}) async {
    try {
      final result = await _getFriendsUseCase.call(type: type);

      result.fold((failure) => _showError(failure.userFriendlyMessage), (
        friendsList,
      ) {
        if (type == 'requests') {
          _friendRequests = friendsList;
        } else {
          _friends = friendsList;
        }
        notifyListeners();
      });
    } catch (e) {
      dev.log('Error loading friends: $e');
      _showError('Failed to load friends. Please try again.');
    }
  }

  Future<void> loadBirthdayFriends() async {
    try {
      final result = await _getBirthdayFriendsUseCase.call();

      result.fold((failure) => _showError(failure.userFriendlyMessage), (
        birthdayList,
      ) {
        _birthdayFriends = birthdayList;
        notifyListeners();
      });
    } catch (e) {
      dev.log('Error loading birthday friends: $e');
      _showError('Failed to load birthday friends. Please try again.');
    }
  }

  // Chat Type Management
  void changeChatType(String type) {
    if (_chatType != type) {
      _chatType = type;
      notifyListeners();
      switch (type) {
        case 'Explore':
          loadCommunities(status: 'recommended');
          break;
        case 'Popular':
          loadCommunities(status: 'popular');
          break;
        case 'My Group':
          loadCommunities(status: 'my_groups');
          loadFriends(type: 'recent');
          break;
      }
    }
  }

  void changeSelectedMyGroupItem(String item) {
    if (_selectedMyGroupItem != item) {
      _selectedMyGroupItem = item;
      notifyListeners();

      // Load appropriate data based on selection
      switch (item) {
        case 'Recently':
          loadCommunities(type: 'recent');
          break;
        case 'Joined':
          loadCommunities(type: 'joined');
          break;
        case 'Friend Request':
          loadFriends(type: 'request');
          break;
        case 'My Friends':
          loadFriends(type: 'friends');
          break;
      }
    }
  }

  // Friend Management
  Future<void> sendFriendRequest(String userId) async {
    try {
      final result = await _manageFriendRequestsUseCase.sendRequest(userId);
      result.fold((failure) => _showError(failure.userFriendlyMessage), (
        success,
      ) {
        if (success) {
          _showSuccess('Friend request sent successfully');
          loadFriends(type: 'recent');
        }
      });
    } catch (e) {
      dev.log('Error sending friend request: $e');
      _showError('Failed to send friend request. Please try again.');
    }
  }

  Future<void> acceptFriendRequest(String userId) async {
    try {
      final result = await _manageFriendRequestsUseCase.acceptRequest(userId);
      result.fold((failure) => _showError(failure.userFriendlyMessage), (
        success,
      ) {
        if (success) {
          _showSuccess('Friend request accepted');
          loadFriends(type: 'friends');
          loadFriends(type: 'requests');
        }
      });
    } catch (e) {
      dev.log('Error accepting friend request: $e');
      _showError('Failed to accept friend request. Please try again.');
    }
  }

  Future<void> rejectFriendRequest(String userId) async {
    try {
      final result = await _manageFriendRequestsUseCase.rejectRequest(userId);
      result.fold((failure) => _showError(failure.userFriendlyMessage), (
        success,
      ) {
        if (success) {
          _showSuccess('Friend request rejected');
          loadFriends(type: 'requests'); // Refresh requests list
        }
      });
    } catch (e) {
      dev.log('Error rejecting friend request: $e');
      _showError('Failed to reject friend request. Please try again.');
    }
  }

  Future<void> removeFriend(String userId) async {
    try {
      final result = await _manageFriendRequestsUseCase.removeFriend(userId);
      result.fold((failure) => _showError(failure.userFriendlyMessage), (
        success,
      ) {
        if (success) {
          _showSuccess('Friend removed successfully');
          loadFriends(type: 'friends');
        }
      });
    } catch (e) {
      dev.log('Error removing friend: $e');
      _showError('Failed to remove friend. Please try again.');
    }
  }

  // Birthday Wishes
  Future<void> sendBirthdayWish(String friendId, String message) async {
    try {
      final result = await _sendBirthdayWishUseCase.call(
        friendId: friendId,
        message: message,
      );

      result.fold((failure) => _showError(failure.userFriendlyMessage), (
        success,
      ) {
        if (success) {
          _showSuccess('Birthday wish sent successfully!');
          loadBirthdayFriends(); // Refresh birthday friends
        }
      });
    } catch (e) {
      dev.log('Error sending birthday wish: $e');
      _showError('Failed to send birthday wish. Please try again.');
    }
  }

  // Filter Methods
  List<CommunityEntity> getFilteredCommunities() {
    switch (_chatType) {
      case 'Explore':
        return _recommendedCommunities;
      case 'Popular':
        return _recommendedCommunities
            .where((c) => c.memberCount > 10)
            .toList();
      case 'My Group':
        switch (_selectedMyGroupItem) {
          case 'Recently':
            return _myCommunities.where((c) => c.isJoined).toList();
          case 'Joined':
            return _myCommunities
                .where((c) => c.isJoined && !c.isAdmin)
                .toList();
          default:
            return [];
        }
      default:
        return _recommendedCommunities;
    }
  }

  List<FriendEntity> getFilteredFriends() {
    switch (_selectedMyGroupItem) {
      case 'Friend Request':
        return _friendRequests;
      case 'My Friends':
        return _friends;
      default:
        return [];
    }
  }

  // Utility Methods
  String formatLastSeen(DateTime? lastSeen) {
    if (lastSeen == null) return "Last seen long ago";
    return lastSeen.timeAgo();
  }

  String getBirthdayMessage(String friendName) {
    final messages = [
      'Happy Birthday, $friendName! 🎉',
      'Wishing you a fantastic birthday, $friendName! 🎂',
      'Hope your special day is wonderful, $friendName! 🎈',
      'Happy Birthday! Have an amazing day, $friendName! 🎁',
    ];
    return messages[DateTime.now().millisecond % messages.length];
  }

  // Private Methods
  void _setLoading() {
    _status = ChatStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setRefreshing() {
    _status = ChatStatus.refreshing;
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoaded() {
    _status = ChatStatus.loaded;
    _errorMessage = null;
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

  void _showSuccess(String message) {
    // You can implement success message handling here
    dev.log('Success: $message');
  }

  bool _shouldUseCachedData() {
    return (_recommendedCommunities.isNotEmpty || _myCommunities.isNotEmpty) &&
        _lastLoadTime != null &&
        DateTime.now().difference(_lastLoadTime!) < _cacheValidDuration;
  }

  // Debug methods
  void debugPrintState() {
    dev.log('Chat Type: $_chatType');
    dev.log('Selected Group Item: $_selectedMyGroupItem');
    dev.log('Recommended Communities: ${_recommendedCommunities.length}');
    dev.log('My Communities: ${_myCommunities.length}');
    dev.log('Friends: ${_friends.length}');
    dev.log('Friend Requests: ${_friendRequests.length}');
    dev.log('Birthday Friends: ${_birthdayFriends.length}');
  }
}

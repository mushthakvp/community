import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../../../core/utils/app_utils.dart';
import '../../domain/entities/community_info_entity.dart';
import '../../domain/entities/community_member_entity.dart';
import '../../domain/entities/friend_entity.dart';
import '../../domain/entities/member_request_entity.dart';
import '../../domain/usecases/add_members.dart';
import '../../domain/usecases/approve_request.dart';
import '../../domain/usecases/get_community_info.dart';
import '../../domain/usecases/get_community_members.dart';
import '../../domain/usecases/get_friends.dart';
import '../../domain/usecases/get_member_requests.dart';
import '../../domain/usecases/leave_community.dart';
import '../../domain/usecases/reject_request.dart';
import '../../domain/usecases/remove_member.dart';
import '../../domain/usecases/send_friend_request.dart';

enum ChatProfileStatus { initial, loading, loaded, error }

enum RequestStatus { initial, loading, success, error }

class ChatProfileProvider extends ChangeNotifier {
  // Use cases
  final GetCommunityMembers getCommunityMembersUseCase;
  final GetMemberRequests getMemberRequestsUseCase;
  final AddMembers addMembersUseCase;
  final RemoveMember removeMemberUseCase;
  final ApproveRequest approveRequestUseCase;
  final RejectRequest rejectRequestUseCase;
  final SendFriendRequest sendFriendRequestUseCase;
  final GetFriends getFriendsUseCase;
  final GetCommunityInfo getCommunityInfoUseCase;
  final LeaveCommunity leaveCommunityUseCase;

  ChatProfileProvider({
    required this.getCommunityMembersUseCase,
    required this.getMemberRequestsUseCase,
    required this.addMembersUseCase,
    required this.removeMemberUseCase,
    required this.approveRequestUseCase,
    required this.rejectRequestUseCase,
    required this.sendFriendRequestUseCase,
    required this.getFriendsUseCase,
    required this.getCommunityInfoUseCase,
    required this.leaveCommunityUseCase,
  });

  // =============== STATE VARIABLES ===============

  // Community data
  String? _currentCommunityId;
  CommunityInfoEntity? _communityInfo;

  // Members data
  List<CommunityMemberEntity> _allMembers = [];
  List<CommunityMemberEntity> _filteredMembers = [];

  // Requests data
  MemberRequestsEntity? _memberRequests;

  // Friends data
  List<FriendEntity> _allFriends = [];
  List<FriendEntity> _filteredFriends = [];

  // Selection state
  final Set<String> _selectedMemberIds = {};

  // Status states
  ChatProfileStatus _status = ChatProfileStatus.initial;
  RequestStatus _requestStatus = RequestStatus.initial;
  String? _errorMessage;

  // Loading states for specific operations
  bool _isLoadingMembers = false;
  bool _isLoadingRequests = false;
  bool _isLoadingFriends = false;

  // Operation states
  final Set<String> _loadingOperations = {};

  // Search controllers
  final TextEditingController memberSearchController = TextEditingController();
  final TextEditingController friendSearchController = TextEditingController();

  Timer? _searchDebouncer;

  // =============== GETTERS ===============

  // Basic getters
  String? get currentCommunityId => _currentCommunityId;
  CommunityInfoEntity? get communityInfo => _communityInfo;
  List<CommunityMemberEntity> get members => _filteredMembers;
  List<CommunityMemberEntity> get allMembers => _allMembers;
  MemberRequestsEntity? get memberRequests => _memberRequests;
  List<FriendEntity> get friends => _filteredFriends;
  List<FriendEntity> get allFriends => _allFriends;
  Set<String> get selectedMemberIds => _selectedMemberIds;

  // Status getters
  ChatProfileStatus get status => _status;
  RequestStatus get requestStatus => _requestStatus;
  String? get errorMessage => _errorMessage;

  // Loading state getters
  bool get isLoading => _status == ChatProfileStatus.loading;
  bool get isRequestLoading => _requestStatus == RequestStatus.loading;
  bool get isLoadingMembers => _isLoadingMembers;
  bool get isLoadingRequests => _isLoadingRequests;
  bool get isLoadingFriends => _isLoadingFriends;
  bool get hasError => _status == ChatProfileStatus.error;

  // Community info getters
  bool get isCreator => _communityInfo?.isCreator ?? false;
  bool get isUserInGroup => _communityInfo?.isUserInGroup ?? false;
  String get communityName => _communityInfo?.name ?? '';
  String get communityId => _communityInfo?.communityId ?? '';
  String? get communityImage => _communityInfo?.image;

  // Data state getters
  bool get hasMembers => _allMembers.isNotEmpty;
  bool get hasFriends => _allFriends.isNotEmpty;
  bool get hasRequests => (_memberRequests?.requests.isNotEmpty) ?? false;
  bool get hasSelectedMembers => _selectedMemberIds.isNotEmpty;
  bool get isInitialized =>
      _currentCommunityId != null && _communityInfo != null;

  // Count getters
  int get totalMemberCount => _allMembers.length;
  int get filteredMemberCount => _filteredMembers.length;
  int get totalRequestCount => _memberRequests?.requests.length ?? 0;
  int get onlineFriendsCount => _allFriends.where((f) => f.isOnline).length;
  int get selectedMemberCount => _selectedMemberIds.length;

  // Filter getters
  List<CommunityMemberEntity> get adminMembers =>
      _allMembers.where((member) => member.isAdmin).toList();

  List<CommunityMemberEntity> get regularMembers =>
      _allMembers.where((member) => !member.isAdmin).toList();

  List<CommunityMemberEntity> get friendMembers =>
      _allMembers.where((member) => member.isFriend).toList();

  List<CommunityMemberEntity> get currentUserMembers =>
      _allMembers.where((member) => member.isCurrentUser).toList();

  // =============== MAIN OPERATIONS ===============

  /// Initialize community profile with all necessary data
  Future<void> initializeCommunityProfile(String communityId) async {
    try {
      // Skip if already loaded for this community
      if (_currentCommunityId == communityId &&
          _status == ChatProfileStatus.loaded &&
          _communityInfo != null) {
        return;
      }

      _currentCommunityId = communityId;
      _setStatus(ChatProfileStatus.loading);
      _clearError();
      _clearData();

      // Load community info and members in parallel
      await Future.wait([
        _loadCommunityInfo(communityId),
        _loadCommunityMembers(communityId),
      ]);

      // Load member requests if user is creator
      if (isCreator) {
        await _loadMemberRequests(communityId);
      }

      _setStatus(ChatProfileStatus.loaded);
      debugPrint(
        'Community profile initialized successfully for: $communityId',
      );
    } catch (e) {
      debugPrint('Error initializing community profile: $e');
      _setError('Failed to load community profile: ${e.toString()}');
    }
  }

  /// Load community basic information
  Future<void> _loadCommunityInfo(String communityId) async {
    try {
      final result = await getCommunityInfoUseCase(
        GetCommunityInfoParams(communityId: communityId),
      );

      result.fold((failure) => throw Exception(failure.message), (info) {
        _communityInfo = info;
        debugPrint('Community info loaded: ${info.name}');
      });
    } catch (e) {
      debugPrint('Error loading community info: $e');
      rethrow;
    }
  }

  /// Load community members
  Future<void> _loadCommunityMembers(String communityId) async {
    try {
      _isLoadingMembers = true;
      notifyListeners();

      final result = await getCommunityMembersUseCase(
        GetCommunityMembersParams(communityId: communityId),
      );

      result.fold((failure) => throw Exception(failure.message), (members) {
        _allMembers = members;
        _filteredMembers = List.from(members);
        debugPrint('Loaded ${members.length} community members');
      });
    } catch (e) {
      debugPrint('Error loading community members: $e');
      rethrow;
    } finally {
      _isLoadingMembers = false;
      notifyListeners();
    }
  }

  /// Load member requests (for creators only)
  Future<void> _loadMemberRequests(String communityId) async {
    try {
      _isLoadingRequests = true;
      notifyListeners();

      final result = await getMemberRequestsUseCase(
        GetMemberRequestsParams(communityId: communityId),
      );

      result.fold(
        (failure) {
          debugPrint('Failed to load member requests: ${failure.message}');
          // Don't throw error for requests, just log it
        },
        (requests) {
          _memberRequests = requests;
          debugPrint('Loaded ${requests.requests.length} member requests');
        },
      );
    } catch (e) {
      debugPrint('Error loading member requests: $e');
      // Don't rethrow for requests
    } finally {
      _isLoadingRequests = false;
      notifyListeners();
    }
  }

  /// Load friends for adding to community
  Future<void> loadFriends() async {
    try {
      if (_allFriends.isNotEmpty) {
        debugPrint('Friends already loaded, skipping...');
        return;
      }

      _isLoadingFriends = true;
      _setRequestStatus(RequestStatus.loading);

      final result = await getFriendsUseCase(NoParams());

      result.fold(
        (failure) {
          _setRequestStatus(RequestStatus.error);
          AppUtils.showErrorSnackBar(
            'Failed to load friends: ${failure.message}',
          );
          debugPrint('Error loading friends: ${failure.message}');
        },
        (friends) {
          _allFriends = friends;
          _filteredFriends = List.from(friends);
          _setRequestStatus(RequestStatus.success);
          debugPrint('Loaded ${friends.length} friends');
        },
      );
    } catch (e) {
      _setRequestStatus(RequestStatus.error);
      AppUtils.showErrorSnackBar('Failed to load friends: ${e.toString()}');
      debugPrint('Exception loading friends: $e');
    } finally {
      _isLoadingFriends = false;
      notifyListeners();
    }
  }

  // =============== SEARCH FUNCTIONALITY ===============

  /// Search members with debouncing
  void searchMembers(String query) {
    _searchDebouncer?.cancel();
    _searchDebouncer = Timer(const Duration(milliseconds: 300), () {
      final trimmedQuery = query.trim().toLowerCase();

      if (trimmedQuery.isEmpty) {
        _filteredMembers = List.from(_allMembers);
      } else {
        _filteredMembers = _allMembers
            .where(
              (member) =>
                  member.name.toLowerCase().contains(trimmedQuery) ||
                  member.id.toLowerCase().contains(trimmedQuery),
            )
            .toList();
      }

      debugPrint(
        'Member search: "$query" -> ${_filteredMembers.length} results',
      );
      notifyListeners();
    });
  }

  /// Search friends with debouncing
  void searchFriends(String query) {
    _searchDebouncer?.cancel();
    _searchDebouncer = Timer(const Duration(milliseconds: 300), () {
      final trimmedQuery = query.trim().toLowerCase();

      if (trimmedQuery.isEmpty) {
        _filteredFriends = List.from(_allFriends);
      } else {
        _filteredFriends = _allFriends
            .where((friend) => friend.name.toLowerCase().contains(trimmedQuery))
            .toList();
      }

      debugPrint(
        'Friend search: "$query" -> ${_filteredFriends.length} results',
      );
      notifyListeners();
    });
  }

  /// Clear all search fields and reset filters
  void clearSearches() {
    memberSearchController.clear();
    friendSearchController.clear();
    _filteredMembers = List.from(_allMembers);
    _filteredFriends = List.from(_allFriends);
    _searchDebouncer?.cancel();
    notifyListeners();
  }

  // =============== MEMBER SELECTION ===============

  /// Toggle member selection for adding to community
  void toggleMemberSelection(String memberId) {
    if (_selectedMemberIds.contains(memberId)) {
      _selectedMemberIds.remove(memberId);
      debugPrint('Deselected member: $memberId');
    } else {
      _selectedMemberIds.add(memberId);
      debugPrint('Selected member: $memberId');
    }
    notifyListeners();
  }

  /// Select all visible friends
  void selectAllVisibleFriends() {
    for (final friend in _filteredFriends) {
      _selectedMemberIds.add(friend.id);
    }
    debugPrint('Selected all ${_filteredFriends.length} visible friends');
    notifyListeners();
  }

  /// Clear all selected members
  void clearSelectedMembers() {
    final count = _selectedMemberIds.length;
    _selectedMemberIds.clear();
    debugPrint('Cleared $count selected members');
    notifyListeners();
  }

  /// Check if member is selected
  bool isMemberSelected(String memberId) {
    return _selectedMemberIds.contains(memberId);
  }

  // =============== MEMBER MANAGEMENT ACTIONS ===============

  /// Add selected members to community
  Future<void> addSelectedMembers() async {
    if (_selectedMemberIds.isEmpty || _currentCommunityId == null) {
      AppUtils.showWarningSnackBar('Please select members to add');
      return;
    }

    try {
      _setRequestStatus(RequestStatus.loading);
      debugPrint('Adding ${_selectedMemberIds.length} members to community');

      final result = await addMembersUseCase(
        AddMembersParams(
          communityId: _currentCommunityId!,
          memberIds: _selectedMemberIds.toList(),
        ),
      );

      result.fold(
        (failure) {
          _setRequestStatus(RequestStatus.error);
          AppUtils.showErrorSnackBar(
            'Failed to add members: ${failure.message}',
          );
          debugPrint('Error adding members: ${failure.message}');
        },
        (_) {
          _setRequestStatus(RequestStatus.success);
          AppUtils.showSuccessSnackBar(
            '${_selectedMemberIds.length} member(s) added successfully',
          );
          clearSelectedMembers();

          // Refresh members list to show newly added members
          refreshMembers();
          debugPrint('Members added successfully');
        },
      );
    } catch (e) {
      _setRequestStatus(RequestStatus.error);
      AppUtils.showErrorSnackBar('Failed to add members: ${e.toString()}');
      debugPrint('Exception adding members: $e');
    }
  }

  /// Remove member from community
  Future<void> removeMemberFromCommunity(String userId, int index) async {
    if (_currentCommunityId == null) {
      AppUtils.showErrorSnackBar('Community not found');
      return;
    }

    try {
      final operationId = 'remove_$userId';
      _addLoadingOperation(operationId);

      debugPrint(
        'Removing member: $userId from community: $_currentCommunityId',
      );

      final result = await removeMemberUseCase(
        RemoveMemberParams(communityId: _currentCommunityId!, userId: userId),
      );

      result.fold(
        (failure) {
          AppUtils.showErrorSnackBar(
            'Failed to remove member: ${failure.message}',
          );
          debugPrint('Error removing member: ${failure.message}');
        },
        (_) {
          AppUtils.showSuccessSnackBar('Member removed successfully');

          // Optimistically update UI
          if (index >= 0 && index < _allMembers.length) {
            final removedMember = _allMembers[index];
            _allMembers.removeAt(index);

            // Update filtered list
            _filteredMembers.removeWhere((m) => m.id == userId);

            debugPrint(
              'Removed member: ${removedMember.name} (${removedMember.id})',
            );
            notifyListeners();
          }
        },
      );
    } catch (e) {
      AppUtils.showErrorSnackBar('Failed to remove member: ${e.toString()}');
      debugPrint('Exception removing member: $e');
    } finally {
      _removeLoadingOperation('remove_$userId');
    }
  }

  /// Send friend request to user
  Future<void> sendFriendRequestToUser(String userId, int index) async {
    try {
      final operationId = 'friend_request_$userId';
      _addLoadingOperation(operationId);

      debugPrint('Sending friend request to: $userId');

      final result = await sendFriendRequestUseCase(
        SendFriendRequestParams(userId: userId),
      );

      result.fold(
        (failure) {
          AppUtils.showErrorSnackBar(
            'Failed to send friend request: ${failure.message}',
          );
          debugPrint('Error sending friend request: ${failure.message}');
        },
        (_) {
          AppUtils.showSuccessSnackBar('Friend request sent successfully');

          // Optimistically update UI
          if (index >= 0 && index < _allMembers.length) {
            _allMembers[index] = _allMembers[index].copyWith(isRequested: true);

            // Update filtered list
            final filteredIndex = _filteredMembers.indexWhere(
              (m) => m.id == userId,
            );
            if (filteredIndex >= 0) {
              _filteredMembers[filteredIndex] = _filteredMembers[filteredIndex]
                  .copyWith(isRequested: true);
            }

            debugPrint('Updated member request status for: $userId');
            notifyListeners();
          }
        },
      );
    } catch (e) {
      AppUtils.showErrorSnackBar(
        'Failed to send friend request: ${e.toString()}',
      );
      debugPrint('Exception sending friend request: $e');
    } finally {
      _removeLoadingOperation('friend_request_$userId');
    }
  }

  // =============== REQUEST MANAGEMENT ACTIONS ===============

  /// Approve join request
  Future<void> approveJoinRequest(String requestId, int index) async {
    if (_currentCommunityId == null) {
      AppUtils.showErrorSnackBar('Community not found');
      return;
    }

    try {
      final operationId = 'approve_$requestId';
      _addLoadingOperation(operationId);

      debugPrint('Approving join request: $requestId');

      final result = await approveRequestUseCase(
        ApproveRequestParams(
          communityId: _currentCommunityId!,
          requestId: requestId,
        ),
      );

      result.fold(
        (failure) {
          AppUtils.showErrorSnackBar(
            'Failed to approve request: ${failure.message}',
          );
          debugPrint('Error approving request: ${failure.message}');
        },
        (_) {
          AppUtils.showSuccessSnackBar('Request approved successfully');

          // Optimistically update UI
          if (_memberRequests != null &&
              index >= 0 &&
              index < _memberRequests!.requests.length) {
            final approvedRequest = _memberRequests!.requests[index];
            final updatedRequests = List<MemberRequestEntity>.from(
              _memberRequests!.requests,
            );
            updatedRequests.removeAt(index);

            _memberRequests = MemberRequestsEntity(
              id: _memberRequests!.id,
              creator: _memberRequests!.creator,
              requests: updatedRequests,
            );

            debugPrint('Approved request for: ${approvedRequest.name}');
            notifyListeners();

            // Refresh members to show the newly added member
            refreshMembers();
          }
        },
      );
    } catch (e) {
      AppUtils.showErrorSnackBar('Failed to approve request: ${e.toString()}');
      debugPrint('Exception approving request: $e');
    } finally {
      _removeLoadingOperation('approve_$requestId');
    }
  }

  /// Reject join request
  Future<void> rejectJoinRequest(String requestId, int index) async {
    if (_currentCommunityId == null) {
      AppUtils.showErrorSnackBar('Community not found');
      return;
    }

    try {
      final operationId = 'reject_$requestId';
      _addLoadingOperation(operationId);

      debugPrint('Rejecting join request: $requestId');

      final result = await rejectRequestUseCase(
        RejectRequestParams(
          communityId: _currentCommunityId!,
          requestId: requestId,
        ),
      );

      result.fold(
        (failure) {
          AppUtils.showErrorSnackBar(
            'Failed to reject request: ${failure.message}',
          );
          debugPrint('Error rejecting request: ${failure.message}');
        },
        (_) {
          AppUtils.showSuccessSnackBar('Request rejected successfully');

          // Optimistically update UI
          if (_memberRequests != null &&
              index >= 0 &&
              index < _memberRequests!.requests.length) {
            final rejectedRequest = _memberRequests!.requests[index];
            final updatedRequests = List<MemberRequestEntity>.from(
              _memberRequests!.requests,
            );
            updatedRequests.removeAt(index);

            _memberRequests = MemberRequestsEntity(
              id: _memberRequests!.id,
              creator: _memberRequests!.creator,
              requests: updatedRequests,
            );

            debugPrint('Rejected request for: ${rejectedRequest.name}');
            notifyListeners();
          }
        },
      );
    } catch (e) {
      AppUtils.showErrorSnackBar('Failed to reject request: ${e.toString()}');
      debugPrint('Exception rejecting request: $e');
    } finally {
      _removeLoadingOperation('reject_$requestId');
    }
  }

  // =============== COMMUNITY ACTIONS ===============

  /// Leave community
  Future<void> leaveCommunityAction() async {
    if (_currentCommunityId == null) {
      AppUtils.showErrorSnackBar('Community not found');
      return;
    }

    try {
      _setRequestStatus(RequestStatus.loading);
      debugPrint('Leaving community: $_currentCommunityId');

      final result = await leaveCommunityUseCase(
        LeaveCommunityParams(communityId: _currentCommunityId!),
      );

      result.fold(
        (failure) {
          _setRequestStatus(RequestStatus.error);
          AppUtils.showErrorSnackBar(
            'Failed to leave community: ${failure.message}',
          );
          debugPrint('Error leaving community: ${failure.message}');
        },
        (_) {
          _setRequestStatus(RequestStatus.success);
          AppUtils.showSuccessSnackBar('Left community successfully');
          debugPrint('Successfully left community');

          // Clear local data after leaving
          _clearData();
        },
      );
    } catch (e) {
      _setRequestStatus(RequestStatus.error);
      AppUtils.showErrorSnackBar('Failed to leave community: ${e.toString()}');
      debugPrint('Exception leaving community: $e');
    }
  }

  // =============== REFRESH METHODS ===============

  /// Refresh community members
  Future<void> refreshMembers() async {
    if (_currentCommunityId == null) return;

    try {
      debugPrint('Refreshing community members...');
      await _loadCommunityMembers(_currentCommunityId!);
      AppUtils.showInfoSnackBar('Members refreshed');
    } catch (e) {
      AppUtils.showErrorSnackBar('Failed to refresh members');
      debugPrint('Error refreshing members: $e');
    }
  }

  /// Refresh member requests
  Future<void> refreshRequests() async {
    if (_currentCommunityId == null || !isCreator) return;

    try {
      debugPrint('Refreshing member requests...');
      await _loadMemberRequests(_currentCommunityId!);
      AppUtils.showInfoSnackBar('Requests refreshed');
    } catch (e) {
      AppUtils.showErrorSnackBar('Failed to refresh requests');
      debugPrint('Error refreshing requests: $e');
    }
  }

  /// Refresh friends list
  Future<void> refreshFriends() async {
    try {
      debugPrint('Refreshing friends list...');
      _allFriends.clear();
      _filteredFriends.clear();
      await loadFriends();
    } catch (e) {
      AppUtils.showErrorSnackBar('Failed to refresh friends');
      debugPrint('Error refreshing friends: $e');
    }
  }

  /// Refresh all data
  Future<void> refreshAll() async {
    if (_currentCommunityId == null) return;

    try {
      debugPrint('Refreshing all community data...');
      _setStatus(ChatProfileStatus.loading);

      await Future.wait([
        _loadCommunityInfo(_currentCommunityId!),
        _loadCommunityMembers(_currentCommunityId!),
        if (isCreator) _loadMemberRequests(_currentCommunityId!),
      ]);

      _setStatus(ChatProfileStatus.loaded);
      AppUtils.showSuccessSnackBar('Data refreshed successfully');
    } catch (e) {
      _setError('Failed to refresh data: ${e.toString()}');
      AppUtils.showErrorSnackBar('Failed to refresh data');
      debugPrint('Error refreshing all data: $e');
    }
  }

  // =============== HELPER METHODS ===============

  /// Get member by ID
  CommunityMemberEntity? getMemberById(String memberId) {
    try {
      return _allMembers.firstWhere((member) => member.id == memberId);
    } catch (e) {
      return null;
    }
  }

  /// Get friend by ID
  FriendEntity? getFriendById(String friendId) {
    try {
      return _allFriends.firstWhere((friend) => friend.id == friendId);
    } catch (e) {
      return null;
    }
  }

  /// Check if operation is loading
  bool isOperationLoading(String operationId) {
    return _loadingOperations.contains(operationId);
  }

  /// Check if specific member operation is loading
  bool isMemberOperationLoading(String userId, String operation) {
    return _loadingOperations.contains('${operation}_$userId');
  }

  // =============== PRIVATE HELPER METHODS ===============

  void _setStatus(ChatProfileStatus status) {
    _status = status;
    notifyListeners();
  }

  void _setRequestStatus(RequestStatus status) {
    _requestStatus = status;
    notifyListeners();
  }

  void _setError(String message) {
    _status = ChatProfileStatus.error;
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    if (_status == ChatProfileStatus.error) {
      _status = ChatProfileStatus.initial;
    }
    notifyListeners();
  }

  void _clearData() {
    _allMembers.clear();
    _filteredMembers.clear();
    _allFriends.clear();
    _filteredFriends.clear();
    _memberRequests = null;
    _selectedMemberIds.clear();
    _communityInfo = null;
    _loadingOperations.clear();
    notifyListeners();
  }

  void _addLoadingOperation(String operationId) {
    _loadingOperations.add(operationId);
    notifyListeners();
  }

  void _removeLoadingOperation(String operationId) {
    _loadingOperations.remove(operationId);
    notifyListeners();
  }

  // =============== LIFECYCLE MANAGEMENT ===============

  @override
  void dispose() {
    // Cancel timers
    _searchDebouncer?.cancel();

    // Dispose controllers
    memberSearchController.dispose();
    friendSearchController.dispose();

    // Clear data
    _clearData();

    debugPrint('ChatProfileProvider disposed');
    super.dispose();
  }
}

import 'package:flutter/material.dart';

import '../../domain/entities/community_entity.dart';
import '../../domain/usecases/accept_friend_request.dart';
import '../../domain/usecases/get_my_groups.dart';
import '../../domain/usecases/get_recommended_communities.dart';
import '../../domain/usecases/join_community.dart';
import '../../domain/usecases/reject_friend_request.dart';

enum VChatTab { explore, popular, myGroup }

enum MyGroupFilter { recently, joined, friendRequest, myFriends }

class VChatProvider extends ChangeNotifier {
  final GetRecommendedCommunities getRecommendedCommunities;
  final GetMyGroups getMyGroups;
  final JoinCommunity joinCommunity;
  final AcceptFriendRequest acceptFriendRequest;
  final RejectFriendRequest rejectFriendRequest;

  VChatProvider({
    required this.getRecommendedCommunities,
    required this.getMyGroups,
    required this.joinCommunity,
    required this.acceptFriendRequest,
    required this.rejectFriendRequest,
  });

  VChatTab _selectedTab = VChatTab.explore;
  MyGroupFilter _selectedFilter = MyGroupFilter.recently;
  List<CommunityEntity> _communities = [];
  List<CommunityEntity> _myGroups = [];
  bool _isLoading = false;
  String? _error;

  final Map<String, bool> _joiningStates = {};
  final Map<String, bool> _processingRequests = {};

  // Getters
  VChatTab get selectedTab => _selectedTab;
  MyGroupFilter get selectedFilter => _selectedFilter;
  List<CommunityEntity> get communities => _communities;
  List<CommunityEntity> get myGroups => _myGroups;
  bool get isLoading => _isLoading;
  String? get error => _error;

  bool isJoining(String communityId) => _joiningStates[communityId] ?? false;
  bool isProcessingRequest(String requestId) =>
      _processingRequests[requestId] ?? false;

  void changeTab(VChatTab tab) {
    _selectedTab = tab;
    notifyListeners();

    switch (tab) {
      case VChatTab.explore:
        fetchRecommendedCommunities();
        break;
      case VChatTab.popular:
        fetchPopularCommunities();
        break;
      case VChatTab.myGroup:
        fetchMyGroups();
        break;
    }
  }

  void changeFilter(MyGroupFilter filter) {
    _selectedFilter = filter;
    notifyListeners();
    fetchMyGroups();
  }

  Future<void> fetchRecommendedCommunities() async {
    _setLoading(true);
    _clearError();

    try {
      final result = await getRecommendedCommunities(
        GetRecommendedCommunitiesParams(type: 'recommended'),
      );

      result.fold((failure) => _setError(failure.message), (communities) {
        _communities = communities;
        notifyListeners();
      });
    } catch (e) {
      _setError(e.toString());
    }

    _setLoading(false);
  }

  Future<void> fetchPopularCommunities() async {
    _setLoading(true);
    _clearError();
    try {
      final result = await getRecommendedCommunities(
        GetRecommendedCommunitiesParams(type: 'popular'),
      );

      result.fold((failure) => _setError(failure.message), (communities) {
        _communities = communities;
        notifyListeners();
      });
    } catch (e) {
      _setError(e.toString());
    }
    _setLoading(false);
  }

  Future<void> fetchMyGroups() async {
    _setLoading(true);
    _clearError();
    try {
      final filterType = _getFilterType(_selectedFilter);
      final result = await getMyGroups(GetMyGroupsParams(type: filterType));

      result.fold((failure) => _setError(failure.message), (groups) {
        _myGroups = groups;
        notifyListeners();
      });
    } catch (e) {
      _setError(e.toString());
    }

    _setLoading(false);
  }

  Future<void> joinCommunityById(String communityId) async {
    _joiningStates[communityId] = true;
    notifyListeners();
    try {
      final result = await joinCommunity(
        JoinCommunityParams(communityId: communityId),
      );
      result.fold(
        (failure) {
          _setError(failure.message);
        },
        (_) {
          _updateCommunityJoinStatus(communityId, true);
          switch (_selectedTab) {
            case VChatTab.explore:
              fetchRecommendedCommunities();
              break;
            case VChatTab.popular:
              fetchPopularCommunities();
              break;
            case VChatTab.myGroup:
              fetchMyGroups();
              break;
          }
        },
      );
    } catch (e) {
      _setError(e.toString());
    } finally {
      _joiningStates[communityId] = false;
      notifyListeners();
    }
  }

  Future<void> acceptFriendRequestById(String requestId) async {
    _processingRequests[requestId] = true;
    notifyListeners();

    try {
      final result = await acceptFriendRequest(
        AcceptFriendRequestParams(requestId: requestId),
      );

      result.fold(
        (failure) {
          _setError(failure.message);
        },
        (_) {
          // Remove the request from the list
          if (_selectedFilter == MyGroupFilter.friendRequest) {
            _myGroups.removeWhere((request) {
              return request.id == requestId;
            });
          }

          // Refresh the current data
          fetchMyGroups();
        },
      );
    } catch (e) {
      _setError(e.toString());
    } finally {
      _processingRequests[requestId] = false;
      notifyListeners();
    }
  }

  Future<void> rejectFriendRequestById(String requestId) async {
    _processingRequests[requestId] = true;
    notifyListeners();

    try {
      final result = await rejectFriendRequest(
        RejectFriendRequestParams(requestId: requestId),
      );

      result.fold(
        (failure) {
          _setError(failure.message);
        },
        (_) {
          // Remove the request from the list
          if (_selectedFilter == MyGroupFilter.friendRequest) {
            _myGroups.removeWhere((request) {
              return request.id == requestId;
            });
          }

          // Refresh the current data
          fetchMyGroups();
        },
      );
    } catch (e) {
      _setError(e.toString());
    } finally {
      _processingRequests[requestId] = false;
      notifyListeners();
    }
  }

  void _updateCommunityJoinStatus(String communityId, bool isJoined) {
    final communityIndex = _communities.indexWhere((c) => c.id == communityId);
    if (communityIndex != -1) {
      final community = _communities[communityIndex];
      _communities[communityIndex] = CommunityEntity(
        id: community.id,
        name: community.name,
        image: community.image,
        memberCount: community.memberCount + (isJoined ? 1 : -1),
        profileImages: community.profileImages,
        isJoined: isJoined,
        isCreated: community.isCreated,
      );
    }
    final myGroupIndex = _myGroups.indexWhere((c) => c.id == communityId);
    if (myGroupIndex != -1) {
      final community = _myGroups[myGroupIndex];
      _myGroups[myGroupIndex] = CommunityEntity(
        id: community.id,
        name: community.name,
        image: community.image,
        memberCount: community.memberCount + (isJoined ? 1 : -1),
        profileImages: community.profileImages,
        isJoined: isJoined,
        isCreated: community.isCreated,
      );
    }
  }

  String _getFilterType(MyGroupFilter filter) {
    switch (filter) {
      case MyGroupFilter.recently:
        return 'recent';
      case MyGroupFilter.joined:
        return 'joined';
      case MyGroupFilter.friendRequest:
        return 'request';
      case MyGroupFilter.myFriends:
        return 'friends';
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  void clearError() {
    _clearError();
  }

  CommunityEntity? getCommunityById(String communityId) {
    try {
      return _communities.firstWhere((c) => c.id == communityId);
    } catch (e) {
      try {
        return _myGroups.firstWhere((c) => c.id == communityId);
      } catch (e) {
        return null;
      }
    }
  }

  void refreshCurrentData() {
    switch (_selectedTab) {
      case VChatTab.explore:
        fetchRecommendedCommunities();
        break;
      case VChatTab.popular:
        fetchPopularCommunities();
        break;
      case VChatTab.myGroup:
        fetchMyGroups();
        break;
    }
  }

  Future<void> refreshAllData() async {
    await Future.wait([
      fetchRecommendedCommunities(),
      fetchPopularCommunities(),
      fetchMyGroups(),
    ]);
  }

  void addNewCommunity(CommunityEntity community) {
    if (_selectedTab == VChatTab.myGroup) {
      _myGroups.insert(0, community);
    }
    final updatedCommunity = CommunityEntity(
      id: community.id,
      name: community.name,
      image: community.image,
      memberCount: community.memberCount,
      profileImages: community.profileImages,
      isJoined: true,
      isCreated: true,
    );

    _communities.insert(0, updatedCommunity);
    notifyListeners();
  }

  void removeCommunity(String communityId) {
    _communities.removeWhere((c) => c.id == communityId);
    _myGroups.removeWhere((c) => c.id == communityId);
    notifyListeners();
  }

  void updateCommunity(CommunityEntity updatedCommunity) {
    final communityIndex = _communities.indexWhere(
      (c) => c.id == updatedCommunity.id,
    );
    if (communityIndex != -1) {
      _communities[communityIndex] = updatedCommunity;
    }
    final myGroupIndex = _myGroups.indexWhere(
      (c) => c.id == updatedCommunity.id,
    );
    if (myGroupIndex != -1) {
      _myGroups[myGroupIndex] = updatedCommunity;
    }
    notifyListeners();
  }

  List<CommunityEntity> getCurrentList() {
    switch (_selectedTab) {
      case VChatTab.explore:
      case VChatTab.popular:
        return _communities;
      case VChatTab.myGroup:
        return _myGroups;
    }
  }

  /// Check if current list is empty
  bool get isCurrentListEmpty => getCurrentList().isEmpty;

  /// Get appropriate empty state message
  String get emptyStateMessage {
    switch (_selectedTab) {
      case VChatTab.explore:
        return 'No communities to explore';
      case VChatTab.popular:
        return 'No popular communities found';
      case VChatTab.myGroup:
        switch (_selectedFilter) {
          case MyGroupFilter.recently:
            return 'No recent activity';
          case MyGroupFilter.joined:
            return 'You haven\'t joined any communities yet';
          case MyGroupFilter.friendRequest:
            return 'No friend requests';
          case MyGroupFilter.myFriends:
            return 'No friends yet';
        }
    }
  }

  /// Force refresh specific data type
  Future<void> forceRefreshCurrentData() async {
    switch (_selectedTab) {
      case VChatTab.explore:
        await fetchRecommendedCommunities();
        break;
      case VChatTab.popular:
        await fetchPopularCommunities();
        break;
      case VChatTab.myGroup:
        await fetchMyGroups();
        break;
    }
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';

import '../../domain/entities/community_entity.dart';
import '../../domain/usecases/get_my_groups.dart';
import '../../domain/usecases/get_recommended_communities.dart';
import '../../domain/usecases/join_community.dart';

enum VChatTab { explore, popular, myGroup }

enum MyGroupFilter { recently, joined, friendRequest, myFriends }

class VChatProvider extends ChangeNotifier {
  final GetRecommendedCommunities getRecommendedCommunities;
  final GetMyGroups getMyGroups;
  final JoinCommunity joinCommunity;

  VChatProvider({
    required this.getRecommendedCommunities,
    required this.getMyGroups,
    required this.joinCommunity,
  });

  // State
  VChatTab _selectedTab = VChatTab.explore;
  MyGroupFilter _selectedFilter = MyGroupFilter.recently;
  List<CommunityEntity> _communities = [];
  List<CommunityEntity> _myGroups = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  VChatTab get selectedTab => _selectedTab;
  MyGroupFilter get selectedFilter => _selectedFilter;
  List<CommunityEntity> get communities => _communities;
  List<CommunityEntity> get myGroups => _myGroups;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Methods
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

      result.fold(
        (failure) => _setError(failure.message),
        (communities) => _communities = communities,
      );
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

      result.fold(
        (failure) => _setError(failure.message),
        (communities) => _communities = communities,
      );
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

      result.fold(
        (failure) => _setError(failure.message),
        (groups) => _myGroups = groups,
      );
    } catch (e) {
      _setError(e.toString());
    }

    _setLoading(false);
  }

  Future<void> joinCommunityById(String communityId) async {
    try {
      log('joinCommunityById: $communityId');
      final result = await joinCommunity(
        JoinCommunityParams(communityId: communityId),
      );
      result.fold((failure) => _setError(failure.message), (_) {
        fetchRecommendedCommunities();
      });
    } catch (e) {
      _setError(e.toString());
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
}

import 'package:flutter/material.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../../../core/utils/result.dart';
import '../../domain/entities/my_post_entity.dart';
import '../../domain/usecases/delete_post_usecase.dart';
import '../../domain/usecases/get_my_posts_usecase.dart';
import '../../domain/usecases/get_post_by_id_usecase.dart';
import '../../domain/usecases/get_post_stats_usecase.dart';
import '../../domain/usecases/like_post_usecase.dart';
import '../../domain/usecases/search_my_posts_usecase.dart';

enum MyPostStatus { initial, loading, loaded, error, loadingMore }

class MyPostProvider extends ChangeNotifier {
  final GetMyPostsUseCase _getMyPostsUseCase;
  final GetPostByIdUseCase _getPostByIdUseCase;
  final LikeMyPostUseCase _likePostUseCase;
  final DeleteMyPostUseCase _deletePostUseCase;
  final GetPostStatsUseCase _getPostStatsUseCase;
  final SearchMyPostsUseCase _searchMyPostsUseCase;

  MyPostProvider({
    required GetMyPostsUseCase getMyPostsUseCase,
    required GetPostByIdUseCase getPostByIdUseCase,
    required LikeMyPostUseCase likePostUseCase,
    required DeleteMyPostUseCase deletePostUseCase,
    required GetPostStatsUseCase getPostStatsUseCase,
    required SearchMyPostsUseCase searchMyPostsUseCase,
  }) : _getMyPostsUseCase = getMyPostsUseCase,
       _getPostByIdUseCase = getPostByIdUseCase,
       _likePostUseCase = likePostUseCase,
       _deletePostUseCase = deletePostUseCase,
       _getPostStatsUseCase = getPostStatsUseCase,
       _searchMyPostsUseCase = searchMyPostsUseCase;

  // State
  MyPostStatus _status = MyPostStatus.initial;
  List<MyPostEntity> _posts = [];
  MyPostEntity? _selectedPost;
  PostStatsEntity? _postStats;
  String _errorMessage = '';
  bool _hasMoreData = true;
  int _currentPage = 1;
  final int _itemsPerPage = 10;
  int _selectedPostIndex = -1;

  // Search state
  bool _isSearching = false;
  String _searchQuery = '';
  List<MyPostEntity> _searchResults = [];
  final TextEditingController _searchController = TextEditingController();

  // Getters
  MyPostStatus get status => _status;
  List<MyPostEntity> get posts => _isSearching ? _searchResults : _posts;
  MyPostEntity? get selectedPost => _selectedPost;
  PostStatsEntity? get postStats => _postStats;
  String get errorMessage => _errorMessage;
  bool get hasMoreData => _hasMoreData;
  bool get isLoading => _status == MyPostStatus.loading;
  bool get isLoadingMore => _status == MyPostStatus.loadingMore;
  bool get isEmpty => posts.isEmpty && _status == MyPostStatus.loaded;
  int get selectedPostIndex => _selectedPostIndex;
  bool get isSearching => _isSearching;
  String get searchQuery => _searchQuery;
  TextEditingController get searchController => _searchController;

  // Methods
  Future<void> getMyPosts({bool isLoadMore = false}) async {
    try {
      if (!isLoadMore) {
        _currentPage = 1;
        _posts.clear();
        _hasMoreData = true;
        _status = MyPostStatus.loading;
      } else {
        if (!_hasMoreData || _status == MyPostStatus.loadingMore) return;
        _status = MyPostStatus.loadingMore;
      }

      notifyListeners();

      final result = await _getMyPostsUseCase(
        GetMyPostsParams(page: _currentPage, limit: _itemsPerPage),
      );

      result.fold(
        (failure) {
          _errorMessage = _getFailureMessage(failure);
          _status = MyPostStatus.error;
        },
        (newPosts) {
          if (newPosts.isEmpty) {
            _hasMoreData = false;
          } else {
            _posts.addAll(newPosts);
            _currentPage++;
            if (newPosts.length < _itemsPerPage) {
              _hasMoreData = false;
            }
          }
          _status = MyPostStatus.loaded;
        },
      );
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: $e';
      _status = MyPostStatus.error;
    }

    notifyListeners();
  }

  Future<Result<void>> getPostById(String postId) async {
    try {
      _status = MyPostStatus.loading;
      notifyListeners();

      final result = await _getPostByIdUseCase(
        GetPostByIdParams(postId: postId),
      );

      return result.fold(
        (failure) {
          _errorMessage = _getFailureMessage(failure);
          _status = MyPostStatus.error;
          notifyListeners();
          return Error(message: _errorMessage);
        },
        (post) {
          _selectedPost = post;
          _status = MyPostStatus.loaded;
          notifyListeners();
          return const Success(null);
        },
      );
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: $e';
      _status = MyPostStatus.error;
      notifyListeners();
      return Error(message: _errorMessage);
    }
  }

  Future<Result<void>> likePost(String postId, int index) async {
    try {
      final result = await _likePostUseCase(LikeMyPostParams(postId: postId));

      return result.fold(
        (failure) => Error(message: _getFailureMessage(failure)),
        (success) {
          if (success) {
            // Update local state
            final updatedPosts = List<MyPostEntity>.from(_posts);
            if (index < updatedPosts.length) {
              final currentPost = updatedPosts[index];
              final newLikesCount = currentPost.isLiked
                  ? currentPost.likesCount - 1
                  : currentPost.likesCount + 1;

              updatedPosts[index] = currentPost.copyWith(
                isLiked: !currentPost.isLiked,
                likesCount: newLikesCount,
              );
              _posts = updatedPosts;
              notifyListeners();
            }
          }
          return const Success(null);
        },
      );
    } catch (e) {
      return Error(message: 'An unexpected error occurred: $e');
    }
  }

  Future<Result<void>> deletePost(String postId) async {
    try {
      _status = MyPostStatus.loading;
      notifyListeners();

      final result = await _deletePostUseCase(
        DeleteMyPostParams(postId: postId),
      );

      return result.fold(
        (failure) {
          _errorMessage = _getFailureMessage(failure);
          _status = MyPostStatus.error;
          notifyListeners();
          return Error(message: _errorMessage);
        },
        (success) {
          if (success) {
            // Remove from local state
            _posts.removeWhere((post) => post.id == postId);
            _searchResults.removeWhere((post) => post.id == postId);

            // Update stats if available
            if (_postStats != null) {
              _postStats = PostStatsEntity(
                totalPosts: _postStats!.totalPosts - 1,
                totalLikes: _postStats!.totalLikes,
                totalViews: _postStats!.totalViews,
                totalComments: _postStats!.totalComments,
              );
            }
          }
          _status = MyPostStatus.loaded;
          notifyListeners();
          return const Success(null);
        },
      );
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: $e';
      _status = MyPostStatus.error;
      notifyListeners();
      return Error(message: _errorMessage);
    }
  }

  Future<Result<void>> getPostStats() async {
    try {
      final result = await _getPostStatsUseCase(NoParams());

      return result.fold(
        (failure) => Error(message: _getFailureMessage(failure)),
        (stats) {
          _postStats = stats;
          notifyListeners();
          return const Success(null);
        },
      );
    } catch (e) {
      return Error(message: 'An unexpected error occurred: $e');
    }
  }

  Future<void> searchPosts(String query) async {
    if (query.trim().isEmpty) {
      _clearSearch();
      return;
    }

    try {
      _isSearching = true;
      _searchQuery = query;
      _status = MyPostStatus.loading;
      notifyListeners();

      final result = await _searchMyPostsUseCase(
        SearchMyPostsParams(query: query, page: 1, limit: 50),
      );

      result.fold(
        (failure) {
          _errorMessage = _getFailureMessage(failure);
          _status = MyPostStatus.error;
        },
        (searchResults) {
          _searchResults = searchResults;
          _status = MyPostStatus.loaded;
        },
      );
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: $e';
      _status = MyPostStatus.error;
    }

    notifyListeners();
  }

  void _clearSearch() {
    _isSearching = false;
    _searchQuery = '';
    _searchResults.clear();
    _searchController.clear();
    notifyListeners();
  }

  void clearSearch() {
    _clearSearch();
  }

  void setSelectedPostIndex(int index) {
    _selectedPostIndex = index;
    if (index >= 0 && index < posts.length) {
      _selectedPost = posts[index];
    }
    notifyListeners();
  }

  void refreshPosts() {
    _clearSearch();
    getMyPosts();
  }

  void reset() {
    _status = MyPostStatus.initial;
    _posts.clear();
    _searchResults.clear();
    _selectedPost = null;
    _postStats = null;
    _errorMessage = '';
    _hasMoreData = true;
    _currentPage = 1;
    _selectedPostIndex = -1;
    _isSearching = false;
    _searchQuery = '';
    _searchController.clear();
    notifyListeners();
  }

  String _getFailureMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure _:
        return failure.message.isNotEmpty
            ? failure.message
            : 'Server error occurred';
      case NetworkFailure _:
        return 'No internet connection';
      case CacheFailure _:
        return 'Cache error occurred';
      default:
        return 'An unexpected error occurred';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

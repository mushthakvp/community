import 'package:flutter/material.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/utils/result.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/usecases/get_posts_usecase.dart';
import '../../domain/usecases/like_post_usecase.dart';

enum PostsStatus { initial, loading, loaded, error, loadingMore }

class PostsProvider extends ChangeNotifier {
  final GetPostsUseCase _getPostsUseCase;
  final LikePostUseCase _likePostUseCase;

  PostsProvider({
    required GetPostsUseCase getPostsUseCase,
    required LikePostUseCase likePostUseCase,
  }) : _getPostsUseCase = getPostsUseCase,
       _likePostUseCase = likePostUseCase;

  // State
  PostsStatus _status = PostsStatus.initial;
  List<PostEntity> _posts = [];
  final List<PostEntity> _myPosts = [];
  String _errorMessage = '';
  bool _hasMoreData = true;
  int _currentPage = 1;
  final int _itemsPerPage = 10;
  bool _isPostViewMode = false;
  int _selectedPostIndex = -1;

  // Getters
  PostsStatus get status => _status;
  List<PostEntity> get posts => _posts;
  List<PostEntity> get myPosts => _myPosts;
  String get errorMessage => _errorMessage;
  bool get hasMoreData => _hasMoreData;
  bool get isLoading => _status == PostsStatus.loading;
  bool get isLoadingMore => _status == PostsStatus.loadingMore;
  bool get isEmpty => _posts.isEmpty && _status == PostsStatus.loaded;
  bool get isPostViewMode => _isPostViewMode;
  int get selectedPostIndex => _selectedPostIndex;

  // Methods
  Future<void> getPosts({bool isLoadMore = false}) async {
    try {
      if (!isLoadMore) {
        _currentPage = 1;
        _posts.clear();
        _hasMoreData = true;
        _status = PostsStatus.loading;
      } else {
        if (!_hasMoreData || _status == PostsStatus.loadingMore) return;
        _status = PostsStatus.loadingMore;
      }

      notifyListeners();

      final result = await _getPostsUseCase(
        GetPostsParams(page: _currentPage, limit: _itemsPerPage),
      );

      result.fold(
        (failure) {
          _errorMessage = _getFailureMessage(failure);
          _status = PostsStatus.error;
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
          _status = PostsStatus.loaded;
        },
      );
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: $e';
      _status = PostsStatus.error;
    }

    notifyListeners();
  }

  void setSelectedPostIndex(int index) {
    _selectedPostIndex = index;
    notifyListeners();
  }

  Future<Result<bool>> likePost(String postId, int index) async {
    try {
      final result = await _likePostUseCase(LikePostParams(postId: postId));

      return result.fold(
        (failure) => Error(message: _getFailureMessage(failure)),
        (success) {
          if (success) {
            // Update the post's like status locally
            final updatedPosts = List<PostEntity>.from(_posts);
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
          return Success(success);
        },
      );
    } catch (e) {
      return Error(message: 'An unexpected error occurred: $e');
    }
  }

  void toggleViewMode() {
    _isPostViewMode = !_isPostViewMode;
    notifyListeners();
  }

  void setPostViewMode(bool isPostMode) {
    _isPostViewMode = isPostMode;
    notifyListeners();
  }

  void reset() {
    _status = PostsStatus.initial;
    _posts.clear();
    _myPosts.clear();
    _errorMessage = '';
    _hasMoreData = true;
    _currentPage = 1;
    _isPostViewMode = false;
    _selectedPostIndex = -1;
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
}

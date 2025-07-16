import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/utils/result.dart';
import '../../domain/entities/create_post_entity.dart';
import '../../domain/usecases/create_post_usecase.dart';
import '../../domain/usecases/delete_post_usecase.dart';
import '../../domain/usecases/update_post_usecase.dart';
import '../../domain/usecases/upload_image_usecase.dart';

enum CreatePostStatus { initial, loading, success, error }

class CreatePostProvider extends ChangeNotifier {
  final CreatePostUseCase _createPostUseCase;
  final UpdatePostUseCase _updatePostUseCase;
  final UploadImageUseCase _uploadImageUseCase;
  final DeletePostUseCase _deletePostUseCase;

  CreatePostProvider({
    required CreatePostUseCase createPostUseCase,
    required UpdatePostUseCase updatePostUseCase,
    required UploadImageUseCase uploadImageUseCase,
    required DeletePostUseCase deletePostUseCase,
  }) : _createPostUseCase = createPostUseCase,
       _updatePostUseCase = updatePostUseCase,
       _uploadImageUseCase = uploadImageUseCase,
       _deletePostUseCase = deletePostUseCase;

  // Form controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // State
  CreatePostStatus _status = CreatePostStatus.initial;
  String _errorMessage = '';
  String? _selectedImagePath;
  String? _uploadedImageUrl;
  bool _isImageUploading = false;
  bool _isUpdateMode = false;
  String? _postId;
  bool _isPdf = false;

  // Getters
  CreatePostStatus get status => _status;
  String get errorMessage => _errorMessage;
  String? get selectedImagePath => _selectedImagePath;
  String? get uploadedImageUrl => _uploadedImageUrl;
  bool get isImageUploading => _isImageUploading;
  bool get isLoading => _status == CreatePostStatus.loading;
  bool get isUpdateMode => _isUpdateMode;
  String? get postId => _postId;
  bool get isPdf => _isPdf;
  bool get hasImage => _uploadedImageUrl != null;

  // Methods
  Future<Result<void>> createPost() async {
    if (!_validateForm()) {
      return const Error(message: 'Please fill all required fields');
    }

    try {
      _status = CreatePostStatus.loading;
      _errorMessage = '';
      notifyListeners();

      final request = CreatePostRequest(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        image: _uploadedImageUrl,
      );

      final result = await _createPostUseCase(
        CreatePostParams(request: request),
      );

      return result.fold(
        (failure) {
          _status = CreatePostStatus.error;
          _errorMessage = _getFailureMessage(failure);
          notifyListeners();
          return Error(message: _errorMessage);
        },
        (post) {
          _status = CreatePostStatus.success;
          notifyListeners();
          _clearForm();
          return const Success(null);
        },
      );
    } catch (e) {
      _status = CreatePostStatus.error;
      _errorMessage = 'An unexpected error occurred: $e';
      notifyListeners();
      return Error(message: _errorMessage);
    }
  }

  Future<Result<void>> updatePost() async {
    if (!_validateForm() || _postId == null) {
      return const Error(message: 'Please fill all required fields');
    }

    try {
      _status = CreatePostStatus.loading;
      _errorMessage = '';
      notifyListeners();

      final request = UpdatePostRequest(
        postId: _postId!,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        image: _uploadedImageUrl,
      );

      final result = await _updatePostUseCase(
        UpdatePostParams(request: request),
      );

      return result.fold(
        (failure) {
          _status = CreatePostStatus.error;
          _errorMessage = _getFailureMessage(failure);
          notifyListeners();
          return Error(message: _errorMessage);
        },
        (post) {
          _status = CreatePostStatus.success;
          notifyListeners();
          return const Success(null);
        },
      );
    } catch (e) {
      _status = CreatePostStatus.error;
      _errorMessage = 'An unexpected error occurred: $e';
      notifyListeners();
      return Error(message: _errorMessage);
    }
  }

  Future<Result<void>> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        _selectedImagePath = image.path;
        _isPdf = _isPdfFile(image.path);
        notifyListeners();

        // Auto-upload the image
        return await uploadImage();
      }

      return const Success(null);
    } catch (e) {
      return Error(message: 'Failed to pick image: $e');
    }
  }

  Future<Result<void>> uploadImage() async {
    if (_selectedImagePath == null) {
      return const Error(message: 'No image selected');
    }

    try {
      _isImageUploading = true;
      notifyListeners();

      final result = await _uploadImageUseCase(
        UploadImageParams(imagePath: _selectedImagePath!),
      );

      return result.fold(
        (failure) {
          _isImageUploading = false;
          notifyListeners();
          return Error(message: _getFailureMessage(failure));
        },
        (imageUrl) {
          _uploadedImageUrl = imageUrl;
          _isImageUploading = false;
          notifyListeners();
          return const Success(null);
        },
      );
    } catch (e) {
      _isImageUploading = false;
      notifyListeners();
      return Error(message: 'Failed to upload image: $e');
    }
  }

  Future<Result<void>> deletePost(String postId) async {
    try {
      _status = CreatePostStatus.loading;
      notifyListeners();

      final result = await _deletePostUseCase(DeletePostParams(postId: postId));

      return result.fold(
        (failure) {
          _status = CreatePostStatus.error;
          _errorMessage = _getFailureMessage(failure);
          notifyListeners();
          return Error(message: _errorMessage);
        },
        (success) {
          _status = CreatePostStatus.success;
          notifyListeners();
          return const Success(null);
        },
      );
    } catch (e) {
      _status = CreatePostStatus.error;
      _errorMessage = 'Failed to delete post: $e';
      notifyListeners();
      return Error(message: _errorMessage);
    }
  }

  void setUpdateMode(CreatePostEntity post) {
    _isUpdateMode = true;
    _postId = post.id;
    titleController.text = post.title;
    descriptionController.text = post.description;
    _uploadedImageUrl = post.image;
    _isPdf = post.image != null ? _isPdfFile(post.image!) : false;
    notifyListeners();
  }

  void clearUpdateMode() {
    _isUpdateMode = false;
    _postId = null;
    _clearForm();
  }

  void removeImage() {
    _selectedImagePath = null;
    _uploadedImageUrl = null;
    _isPdf = false;
    notifyListeners();
  }

  bool _validateForm() {
    return titleController.text.trim().isNotEmpty &&
        descriptionController.text.trim().isNotEmpty;
  }

  bool _isPdfFile(String path) {
    return path.toLowerCase().endsWith('.pdf');
  }

  void _clearForm() {
    titleController.clear();
    descriptionController.clear();
    _selectedImagePath = null;
    _uploadedImageUrl = null;
    _isPdf = false;
    _isUpdateMode = false;
    _postId = null;
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
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}

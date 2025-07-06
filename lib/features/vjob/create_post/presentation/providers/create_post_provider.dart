import 'dart:async';
import 'dart:developer' as dev;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/entities/create_post_entity.dart';
import '../../domain/usecases/create_post_usecase.dart';
import '../../domain/usecases/delete_post_usecase.dart';
import '../../domain/usecases/update_post_usecase.dart';
import '../../domain/usecases/upload_image_usecase.dart';

enum CreatePostStatus { initial, loading, success, error }

class CreatePostProvider extends ChangeNotifier {
  final CreatePostUseCase _createPostUseCase;
  final UpdatePostUseCase _updatePostUseCase;
  final DeletePostUseCase _deletePostUseCase;
  final UploadImageUseCase _uploadImageUseCase;

  CreatePostProvider({
    required CreatePostUseCase createPostUseCase,
    required UpdatePostUseCase updatePostUseCase,
    required DeletePostUseCase deletePostUseCase,
    required UploadImageUseCase uploadImageUseCase,
  }) : _createPostUseCase = createPostUseCase,
       _updatePostUseCase = updatePostUseCase,
       _deletePostUseCase = deletePostUseCase,
       _uploadImageUseCase = uploadImageUseCase;

  // Controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // State
  CreatePostStatus _status = CreatePostStatus.initial;
  String? _errorMessage;
  String? _successMessage;
  String _selectedImagePath = '';
  String _uploadedImageUrl = '';
  bool _isUpdate = false;
  String _postIdForUpdate = '';

  // Image picker
  final ImagePicker _imagePicker = ImagePicker();

  // Getters
  CreatePostStatus get status => _status;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  String get selectedImagePath => _selectedImagePath;
  String get uploadedImageUrl => _uploadedImageUrl;
  bool get isUpdate => _isUpdate;
  bool get isLoading => _status == CreatePostStatus.loading;
  bool get hasImage =>
      _selectedImagePath.isNotEmpty || _uploadedImageUrl.isNotEmpty;
  bool get isPdf =>
      _selectedImagePath.toLowerCase().endsWith('.pdf') ||
      _uploadedImageUrl.toLowerCase().endsWith('.pdf');

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  // Public Methods
  void clearForm() {
    titleController.clear();
    descriptionController.clear();
    _selectedImagePath = '';
    _uploadedImageUrl = '';
    _isUpdate = false;
    _postIdForUpdate = '';
    _status = CreatePostStatus.initial;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  void setUpdateMode({
    required String postId,
    required String title,
    required String description,
    required String imageUrl,
  }) {
    _isUpdate = true;
    _postIdForUpdate = postId;
    titleController.text = title;
    descriptionController.text = description;
    _uploadedImageUrl = imageUrl;
    _selectedImagePath = '';
    notifyListeners();
  }

  Future<void> pickImageFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        _selectedImagePath = image.path;
        _uploadedImageUrl = '';
        notifyListeners();
      }
    } catch (e) {
      dev.log('Error picking image from camera: $e');
      _showError('Failed to capture image. Please try again.');
    }
  }

  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        _selectedImagePath = image.path;
        _uploadedImageUrl = '';
        notifyListeners();
      }
    } catch (e) {
      dev.log('Error picking image from gallery: $e');
      _showError('Failed to pick image. Please try again.');
    }
  }

  Future<void> pickFile() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        _selectedImagePath = result.files.single.path!;
        _uploadedImageUrl = '';
        notifyListeners();
      }
    } catch (e) {
      dev.log('Error picking file: $e');
      _showError('Failed to pick file. Please try again.');
    }
  }

  void removeSelectedImage() {
    _selectedImagePath = '';
    _uploadedImageUrl = '';
    notifyListeners();
  }

  Future<void> createOrUpdatePost() async {
    if (!_validateForm()) return;

    _setLoading();

    try {
      // Upload image if a new one is selected
      String imageUrl = _uploadedImageUrl;
      if (_selectedImagePath.isNotEmpty) {
        final uploadResult = await _uploadImageUseCase(_selectedImagePath);

        final uploadSuccess = uploadResult.fold(
          (failure) {
            _setError(failure.userFriendlyMessage);
            return false;
          },
          (url) {
            imageUrl = url;
            return true;
          },
        );

        if (!uploadSuccess) return;
      }

      // Create post entity
      final postEntity = CreatePostEntity(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        image: imageUrl,
      );

      // Create or update post
      if (_isUpdate) {
        await _updatePost(postEntity);
      } else {
        await _createPost(postEntity);
      }
    } catch (e) {
      dev.log('Error in createOrUpdatePost: $e');
      _setError('An unexpected error occurred. Please try again.');
    }
  }

  Future<void> deletePost(String postId) async {
    _setLoading();

    try {
      final result = await _deletePostUseCase(postId);

      result.fold((failure) => _setError(failure.userFriendlyMessage), (
        success,
      ) {
        if (success) {
          _setSuccess('Post deleted successfully');
        } else {
          _setError('Failed to delete post');
        }
      });
    } catch (e) {
      dev.log('Error deleting post: $e');
      _setError('An unexpected error occurred while deleting post.');
    }
  }

  void showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildImagePickerBottomSheet(context),
    );
  }

  // Private Methods
  bool _validateForm() {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    if (!hasImage) {
      _showError('Please select an image or PDF file');
      return false;
    }

    return true;
  }

  Future<void> _createPost(CreatePostEntity postEntity) async {
    final result = await _createPostUseCase(postEntity);

    result.fold((failure) => _setError(failure.userFriendlyMessage), (
      response,
    ) {
      if (response.success) {
        _setSuccess(response.message);
        clearForm();
      } else {
        _setError(response.message);
      }
    });
  }

  Future<void> _updatePost(CreatePostEntity postEntity) async {
    final result = await _updatePostUseCase(
      postId: _postIdForUpdate,
      post: postEntity,
    );

    result.fold((failure) => _setError(failure.userFriendlyMessage), (
      response,
    ) {
      if (response.success) {
        _setSuccess(response.message);
      } else {
        _setError(response.message);
      }
    });
  }

  void _setLoading() {
    _status = CreatePostStatus.loading;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  void _setSuccess(String message) {
    _status = CreatePostStatus.success;
    _successMessage = message;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _status = CreatePostStatus.error;
    _errorMessage = message;
    _successMessage = null;
    dev.log('Create post provider error: $message');
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

  Widget _buildImagePickerBottomSheet(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Select Image or File',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPickerOption(
                icon: Icons.camera_alt,
                label: 'Camera',
                onTap: () {
                  Navigator.pop(context);
                  pickImageFromCamera();
                },
              ),
              _buildPickerOption(
                icon: Icons.photo_library,
                label: 'Gallery',
                onTap: () {
                  Navigator.pop(context);
                  pickImageFromGallery();
                },
              ),
              _buildPickerOption(
                icon: Icons.insert_drive_file,
                label: 'File',
                onTap: () {
                  Navigator.pop(context);
                  pickFile();
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPickerOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // Form validation methods
  String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Title is required';
    }
    if (value.trim().length < 3) {
      return 'Title must be at least 3 characters';
    }
    if (value.trim().length > 100) {
      return 'Title must be less than 100 characters';
    }
    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Description is required';
    }
    if (value.trim().length < 10) {
      return 'Description must be at least 10 characters';
    }
    if (value.trim().length > 1000) {
      return 'Description must be less than 1000 characters';
    }
    return null;
  }
}

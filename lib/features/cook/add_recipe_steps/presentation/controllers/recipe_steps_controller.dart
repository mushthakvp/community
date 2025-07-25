import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entities/recipe_step.dart';

class RecipeStepsController extends GetxController {
  final RxList<RecipeStep> _recipeSteps = <RecipeStep>[].obs;
  final RxBool _isLoading = false.obs;

  // Image upload properties
  final RxBool _isPictureLoading = false.obs;
  final RxDouble _uploadProgress = 0.0.obs;
  String _currentImageUrl = '';
  final Map<String, File> _files = {};
  final Map<String, String> _uploadedUrls = {};

  // Getters
  List<RecipeStep> get recipeSteps => _recipeSteps;
  bool get isLoading => _isLoading.value;
  bool get isPictureLoading => _isPictureLoading.value;
  double get uploadProgress => _uploadProgress.value;
  String get currentImageUrl => _currentImageUrl;
  bool get hasSteps => _recipeSteps.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    _simulateLoading();
  }

  void _simulateLoading() {
    _isLoading.value = true;
    Future.delayed(const Duration(seconds: 1), () {
      _isLoading.value = false;
    });
  }

  Future<File?> pickImageFromGallery(String imageId) async {
    log('Picking image for $imageId');
    _isPictureLoading.value = true;
    _uploadProgress.value = 0.0;

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpeg'],
      );

      var image = result?.files.first;
      if (image?.path == null) return null;

      final imageFile = File(image!.path!);
      log('Image picked successfully: ${image.path}');
      return imageFile;
    } catch (e) {
      log('Error picking image: $e');
      return null;
    } finally {
      _isPictureLoading.value = false;
    }
  }

  Future<void> uploadImage({
    required BuildContext context,
    required String imageId,
  }) async {
    log('Starting image upload for $imageId');
    File? tempImage = await pickImageFromGallery(imageId);

    if (tempImage != null) {
      _files[imageId] = tempImage;
      _isPictureLoading.value = true;
      _uploadProgress.value = 0.0;

      // Simulate upload progress
      await _simulateUploadProgress();

      // Simulate successful upload
      _currentImageUrl = 'https://example.com/uploaded-image-$imageId.jpg';
      _uploadedUrls[imageId] = _currentImageUrl;

      log('Image upload complete. URL: $_currentImageUrl');
      _isPictureLoading.value = false;
      _uploadProgress.value = 1.0;
    }
  }

  Future<void> _simulateUploadProgress() async {
    for (int i = 0; i <= 100; i += 10) {
      await Future.delayed(const Duration(milliseconds: 100));
      _uploadProgress.value = i / 100.0;
    }
  }

  void saveStep({
    required String title,
    required String description,
    int? editIndex,
    String? imageUrl,
  }) {
    log(
      'Saving step - Title: $title, Edit Index: $editIndex, Image URL: $imageUrl',
    );

    final finalImageUrl = imageUrl?.isNotEmpty == true
        ? imageUrl!
        : (_currentImageUrl.isNotEmpty ? _currentImageUrl : '');

    final step = RecipeStep(
      id:
          editIndex?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      imageUrl: finalImageUrl,
      order: editIndex ?? _recipeSteps.length,
    );

    if (editIndex != null && editIndex < _recipeSteps.length) {
      _recipeSteps[editIndex] = step;
      log('Step edited at index $editIndex');
    } else {
      _recipeSteps.add(step);
      log('New step added');
    }

    // Reset upload state
    _currentImageUrl = '';
    _files.clear();
    _uploadedUrls.clear();
  }

  void deleteStep(int index) {
    if (index >= 0 && index < _recipeSteps.length) {
      log('Deleting step at index $index');
      _recipeSteps.removeAt(index);

      // Reorder remaining steps
      for (int i = 0; i < _recipeSteps.length; i++) {
        _recipeSteps[i] = _recipeSteps[i].copyWith(order: i);
      }
    }
  }

  RecipeStep? getStepForEditing(int index) {
    if (index >= 0 && index < _recipeSteps.length) {
      return _recipeSteps[index];
    }
    return null;
  }

  List<Map<String, dynamic>> getStepsForBackend() {
    return _recipeSteps.map((step) => step.toMap()).toList();
  }

  void clearSteps() {
    _recipeSteps.clear();
    _currentImageUrl = '';
    _files.clear();
    _uploadedUrls.clear();
  }

  bool validateSteps() {
    if (_recipeSteps.isEmpty) {
      _showError('Please add at least one step');
      return false;
    }
    return true;
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}

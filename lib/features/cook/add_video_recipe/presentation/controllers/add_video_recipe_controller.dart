import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livera/core/services/cloudinary_service.dart';

class AddVideoRecipeController extends GetxController {
  // Form controllers
  final titleController = TextEditingController();
  final cookingTimeController = TextEditingController();
  final descriptionController = TextEditingController();

  // Validation states
  final RxBool _isTitleValid = false.obs;
  final RxBool _isCookingTimeValid = false.obs;
  final RxBool _isDescriptionValid = false.obs;

  // Upload states
  final RxBool _isVideoUploading = false.obs;
  final RxDouble _videoUploadProgress = 0.0.obs;
  final RxBool _isImageUploading = false.obs;
  final RxDouble _imageUploadProgress = 0.0.obs;

  // Upload URLs
  final RxString _videoUrl = ''.obs;
  final RxString _imageUrl = ''.obs;

  // Getters
  bool get isTitleValid => _isTitleValid.value;
  bool get isCookingTimeValid => _isCookingTimeValid.value;
  bool get isDescriptionValid => _isDescriptionValid.value;
  bool get isVideoUploading => _isVideoUploading.value;
  double get videoUploadProgress => _videoUploadProgress.value;
  bool get isImageUploading => _isImageUploading.value;
  double get imageUploadProgress => _imageUploadProgress.value;
  String get videoUrl => _videoUrl.value;
  String get imageUrl => _imageUrl.value;
  bool get hasVideo => _videoUrl.value.isNotEmpty;
  bool get hasImage => _imageUrl.value.isNotEmpty;

  bool get isFormValid =>
      isTitleValid &&
      isCookingTimeValid &&
      isDescriptionValid &&
      hasVideo &&
      hasImage;

  @override
  void onInit() {
    super.onInit();
    _setupValidation();
  }

  @override
  void onClose() {
    titleController.dispose();
    cookingTimeController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  void _setupValidation() {
    titleController.addListener(() => validateTitle(titleController.text));
    cookingTimeController.addListener(
      () => validateCookingTime(cookingTimeController.text),
    );
    descriptionController.addListener(
      () => validateDescription(descriptionController.text),
    );
  }

  // Validation methods
  void validateTitle(String value) {
    _isTitleValid.value = value.trim().isNotEmpty && value.length >= 3;
  }

  void validateCookingTime(String value) {
    _isCookingTimeValid.value =
        value.trim().isNotEmpty &&
        RegExp(
          r'^\d+(\s*(?:min|hrs?|hours?|minutes?)?)?$',
        ).hasMatch(value.toLowerCase());
  }

  void validateDescription(String value) {
    _isDescriptionValid.value = value.trim().isNotEmpty && value.length >= 10;
  }

  // Video upload methods
  Future<void> handleVideoUpload() async {
    if (_isVideoUploading.value) return;

    try {
      log('Starting video upload');
      _isVideoUploading.value = true;
      _videoUploadProgress.value = 0.0;
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
      );
      if (result?.files.first.path == null) {
        _isVideoUploading.value = false;
        return;
      }
      String? url = await CloudinaryService.uploadSingleImage(
        file: File(result!.files.first.path!),
        onProgress: (p0) => _videoUploadProgress.value = p0,
      );
      await _simulateUploadProgress((progress) {
        _videoUploadProgress.value = progress;
      });
      _videoUrl.value = url ?? '';
    } catch (e) {
      log('Video upload failed: $e');
      _showError('Failed to upload video. Please try again.');
    } finally {
      _isVideoUploading.value = false;
    }
  }

  // Image upload methods
  Future<void> handleImageUpload() async {
    if (_isImageUploading.value) return;

    try {
      log('Starting image upload');
      _isImageUploading.value = true;
      _imageUploadProgress.value = 0.0;

      // Pick image file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
        allowMultiple: false,
      );

      if (result?.files.first.path == null) {
        _isImageUploading.value = false;
        return;
      }
      String? url = await CloudinaryService.uploadSingleImage(
        file: File(result!.files.first.path!),
        onProgress: (p0) => _imageUploadProgress.value = p0,
      );
      _imageUrl.value = url ?? '';
    } catch (e) {
      log('Image upload failed: $e');
      _showError('Failed to upload image. Please try again.');
    } finally {
      _isImageUploading.value = false;
    }
  }

  Future<void> _simulateUploadProgress(Function(double) onProgress) async {
    for (int i = 0; i <= 100; i += 5) {
      await Future.delayed(const Duration(milliseconds: 100));
      onProgress(i / 100.0);
    }
  }

  // Submit recipe
  Future<void> submitRecipe() async {
    if (!isFormValid) {
      _showError('Please complete all required fields');
      return;
    }

    try {
      // Show loading dialog
      Get.dialog(
        const Center(child: CircularProgressIndicator(color: Colors.amber)),
        barrierDismissible: false,
      );

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Prepare data for submission
      final recipeData = {
        'title': titleController.text.trim(),
        'description': descriptionController.text.trim(),
        'cookingTime': cookingTimeController.text.trim(),
        'videoUrl': _videoUrl.value,
        'imageUrl': _imageUrl.value,
        'type': 'video',
      };

      log('Recipe data prepared: $recipeData');

      // Close loading dialog
      Get.back();

      // Show success message
      Get.snackbar(
        'Success',
        'Video recipe submitted successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      // Clear form
      clearForm();

      // Navigate back or to success page
      Get.back();
    } catch (e) {
      // Close loading dialog
      Get.back();

      log('Submit recipe error: $e');
      _showError('Failed to submit recipe. Please try again.');
    }
  }

  void clearForm() {
    titleController.clear();
    cookingTimeController.clear();
    descriptionController.clear();
    _isTitleValid.value = false;
    _isCookingTimeValid.value = false;
    _isDescriptionValid.value = false;
    _videoUrl.value = '';
    _imageUrl.value = '';
    _videoUploadProgress.value = 0.0;
    _imageUploadProgress.value = 0.0;
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }
}

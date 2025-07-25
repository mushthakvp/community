import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livera/core/services/cloudinary_service.dart';

class AddStepController extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // State management
  final RxBool _isPictureLoading = false.obs;
  final RxDouble _uploadProgress = 0.0.obs;
  final RxString _imageUrl = ''.obs;

  // Edit mode properties
  final RxBool _isEditMode = false.obs;
  int? _editIndex;
  String? _existingImageUrl;

  // Getters
  bool get isPictureLoading => _isPictureLoading.value;
  double get uploadProgress => _uploadProgress.value;
  String get imageUrl => _imageUrl.value;
  bool get isEditMode => _isEditMode.value;
  bool get hasImage =>
      _imageUrl.value.isNotEmpty || _existingImageUrl?.isNotEmpty == true;
  bool get isFormValid =>
      titleController.text.trim().isNotEmpty &&
      descriptionController.text.trim().isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    _initializeWithData();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  void _initializeWithData() {
    // Get data from arguments
    final Map<String, dynamic>? args = Get.arguments;
    _editIndex = args?['editIndex'];
    final Map<String, dynamic>? stepData = args?['stepData'];

    if (_editIndex != null && stepData != null) {
      _isEditMode.value = true;
      titleController.text = stepData['title'] ?? '';
      descriptionController.text = stepData['description'] ?? '';
      _existingImageUrl = stepData['image'];

      log('Edit mode initialized with index: $_editIndex');
    } else {
      _resetForm();
    }
  }

  void _resetForm() {
    _isEditMode.value = false;
    titleController.clear();
    descriptionController.clear();
    _imageUrl.value = '';
    _existingImageUrl = null;
    _editIndex = null;
  }

  Future<void> pickAndUploadImage() async {
    if (_isPictureLoading.value) return;
    try {
      _isPictureLoading.value = true;
      _uploadProgress.value = 0.0;
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpeg'],
      );
      if (result?.files.first.path == null) {
        _isPictureLoading.value = false;
        return;
      }
      String? url = await CloudinaryService.uploadSingleImage(
        file: File(result!.files.first.path!),
        onProgress: (p0) => _uploadProgress.value = p0 / 100.0,
      );
      if (url != null) {
        _imageUrl.value = url;
        log('Image uploaded successfully: $url');
      } else {
        _showError('Failed to upload image. Please try again.');
      }
    } catch (e) {
      log('Error in image upload: $e');
      _showError('Failed to upload image. Please try again.');
    } finally {
      _isPictureLoading.value = false;
    }
  }

  Future<void> saveStep() async {
    if (!_validateForm()) return;
    if (_isPictureLoading.value) {
      _showError('Please wait for image upload to complete');
      return;
    }
    try {
      final stepsController = Get.find<dynamic>();
      final imageToUse = _imageUrl.value.isNotEmpty
          ? _imageUrl.value
          : (_existingImageUrl ?? '');
      stepsController.saveStep(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        editIndex: _editIndex,
        imageUrl: imageToUse,
      );
      Get.back(result: true);
    } catch (e) {
      _showError('Failed to save step. Please try again.');
    }
  }

  bool _validateForm() {
    if (titleController.text.trim().isEmpty) {
      _showError('Please enter a title');
      return false;
    }

    if (descriptionController.text.trim().isEmpty) {
      _showError('Please enter a description');
      return false;
    }

    return true;
  }

  String get currentDisplayImage {
    if (_imageUrl.value.isNotEmpty) {
      return _imageUrl.value;
    }
    return _existingImageUrl ?? '';
  }

  String get stepTitle {
    if (_isEditMode.value && _editIndex != null) {
      return 'Edit Step ${_editIndex! + 1}';
    }
    return 'Add a Step';
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

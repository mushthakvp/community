import 'dart:io';

import 'package:get/get.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../domain/usecases/pick_media_usecase.dart';
import '../../domain/usecases/upload_media_usecase.dart';

class MediaUploadController extends GetxController {
  final PickImageUseCase pickImageUseCase;
  final PickVideoUseCase pickVideoUseCase;
  final UploadImageUseCase uploadImageUseCase;
  final UploadVideoUseCase uploadVideoUseCase;

  MediaUploadController({
    required this.pickImageUseCase,
    required this.pickVideoUseCase,
    required this.uploadImageUseCase,
    required this.uploadVideoUseCase,
  });

  final RxBool _isImageUploading = false.obs;
  final RxBool _isVideoUploading = false.obs;
  final RxDouble _imageUploadProgress = 0.0.obs;
  final RxDouble _videoUploadProgress = 0.0.obs;
  final RxString _uploadedImageUrl = ''.obs;
  final RxString _uploadedVideoUrl = ''.obs;

  bool get isImageUploading => _isImageUploading.value;
  bool get isVideoUploading => _isVideoUploading.value;
  double get imageUploadProgress => _imageUploadProgress.value;
  double get videoUploadProgress => _videoUploadProgress.value;
  String get uploadedImageUrl => _uploadedImageUrl.value;
  String get uploadedVideoUrl => _uploadedVideoUrl.value;

  Future<void> pickAndUploadImage() async {
    final pickResult = await pickImageUseCase(NoParams());

    pickResult.fold(
      (failure) =>
          Get.snackbar('Error', 'Failed to pick image: ${failure.message}'),
      (file) async {
        if (file != null) {
          await _uploadImage(file);
        }
      },
    );
  }

  Future<void> pickAndUploadVideo() async {
    final pickResult = await pickVideoUseCase(NoParams());

    pickResult.fold(
      (failure) =>
          Get.snackbar('Error', 'Failed to pick video: ${failure.message}'),
      (file) async {
        if (file != null) {
          await _uploadVideo(file);
        }
      },
    );
  }

  Future<void> _uploadImage(File imageFile) async {
    _isImageUploading.value = true;
    _imageUploadProgress.value = 0.0;

    final uploadResult = await uploadImageUseCase(
      UploadImageParams(
        imageFile: imageFile,
        onProgress: (progress) {
          _imageUploadProgress.value = progress;
        },
      ),
    );

    uploadResult.fold(
      (failure) {
        Get.snackbar('Error', 'Failed to upload image: ${failure.message}');
        _isImageUploading.value = false;
        _imageUploadProgress.value = 0.0;
      },
      (url) {
        _uploadedImageUrl.value = url;
        _isImageUploading.value = false;
        _imageUploadProgress.value = 1.0;
        Get.snackbar('Success', 'Image uploaded successfully');
      },
    );
  }

  Future<void> _uploadVideo(File videoFile) async {
    _isVideoUploading.value = true;
    _videoUploadProgress.value = 0.0;

    final uploadResult = await uploadVideoUseCase(
      UploadVideoParams(
        videoFile: videoFile,
        onProgress: (progress) {
          _videoUploadProgress.value = progress;
        },
      ),
    );

    uploadResult.fold(
      (failure) {
        Get.snackbar('Error', 'Failed to upload video: ${failure.message}');
        _isVideoUploading.value = false;
        _videoUploadProgress.value = 0.0;
      },
      (url) {
        _uploadedVideoUrl.value = url;
        _isVideoUploading.value = false;
        _videoUploadProgress.value = 1.0;
        Get.snackbar('Success', 'Video uploaded successfully');
      },
    );
  }

  void reset() {
    _isImageUploading.value = false;
    _isVideoUploading.value = false;
    _imageUploadProgress.value = 0.0;
    _videoUploadProgress.value = 0.0;
    _uploadedImageUrl.value = '';
    _uploadedVideoUrl.value = '';
  }
}

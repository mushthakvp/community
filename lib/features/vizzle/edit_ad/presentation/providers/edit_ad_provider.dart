import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/error/failures.dart';
import '../../../profile/domain/entities/advertisement_entity.dart';
import '../../domain/entities/edit_ad_request_entity.dart';
import '../../domain/usecases/edit_ad_usecase.dart';
import '../../domain/usecases/get_ad_details_usecase.dart';
import '../../domain/usecases/upload_ad_images_usecase.dart';

enum EditAdStatus { initial, loading, uploading, success, error }

class EditAdProvider with ChangeNotifier {
  final GetAdDetailsUseCase getAdDetailsUseCase;
  final EditAdUseCase editAdUseCase;
  final UploadAdImagesUseCase uploadAdImagesUseCase;

  EditAdProvider({
    required this.getAdDetailsUseCase,
    required this.editAdUseCase,
    required this.uploadAdImagesUseCase,
  });

  // State management
  EditAdStatus _status = EditAdStatus.initial;
  AdvertisementEntity? _advertisement;
  String? _errorMessage;
  double _uploadProgress = 0.0;

  // Form controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Image management
  final List<File> _newImages = [];
  final List<String> _existingImages = [];
  final List<String> _removedImages = [];

  // Location
  String _district = '';
  String _latitude = '';
  String _longitude = '';
  String _address = '';

  // Getters
  EditAdStatus get status => _status;
  AdvertisementEntity? get advertisement => _advertisement;
  String? get errorMessage => _errorMessage;
  double get uploadProgress => _uploadProgress;
  bool get isLoading => _status == EditAdStatus.loading;
  bool get isUploading => _status == EditAdStatus.uploading;
  bool get hasError => _status == EditAdStatus.error;
  List<File> get newImages => _newImages;
  List<String> get existingImages => _existingImages;
  List<String> get removedImages => _removedImages;
  String get district => _district;
  String get latitude => _latitude;
  String get longitude => _longitude;
  String get address => _address;

  int get totalImagesCount => _existingImages.length + _newImages.length;
  bool get canAddMoreImages => totalImagesCount < 10;

  // Methods
  Future<void> loadAdDetails(String adId) async {
    _status = EditAdStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await getAdDetailsUseCase(GetAdDetailsParams(adId: adId));

    result.fold(
      (failure) {
        _status = EditAdStatus.error;
        _errorMessage = _getFailureMessage(failure);
        debugPrint('Error loading ad details: $_errorMessage');
      },
      (advertisement) {
        _status = EditAdStatus.initial;
        _advertisement = advertisement;
        _initializeForm(advertisement);
        _errorMessage = null;
      },
    );

    notifyListeners();
  }

  void _initializeForm(AdvertisementEntity ad) {
    titleController.text = ad.title;
    descriptionController.text = ad.description;
    priceController.text = ad.price?.toString() ?? '';
    phoneController.text = ad.phone;

    _existingImages.clear();
    _existingImages.addAll(ad.images);

    _district = ad.district;
    _latitude = ad.latitude;
    _longitude = ad.longitude;
    _address = ad.address;
  }

  Future<void> addImages() async {
    if (!canAddMoreImages) {
      _errorMessage = 'Maximum 10 images allowed';
      notifyListeners();
      return;
    }

    try {
      final ImagePicker picker = ImagePicker();
      final int remainingSlots = 10 - totalImagesCount;

      final List<XFile> images = await picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (images.isNotEmpty) {
        final List<XFile> selectedImages = images.take(remainingSlots).toList();

        for (final XFile image in selectedImages) {
          _newImages.add(File(image.path));
        }

        if (images.length > remainingSlots) {
          _errorMessage = 'Only $remainingSlots images were added due to limit';
        }

        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to pick images: ${e.toString()}';
      notifyListeners();
    }
  }

  void removeNewImage(int index) {
    if (index >= 0 && index < _newImages.length) {
      _newImages.removeAt(index);
      notifyListeners();
    }
  }

  void removeExistingImage(int index) {
    if (index >= 0 && index < _existingImages.length) {
      final removedImage = _existingImages.removeAt(index);
      _removedImages.add(removedImage);
      notifyListeners();
    }
  }

  void updateLocation({
    required String district,
    required String latitude,
    required String longitude,
    required String address,
  }) {
    _district = district;
    _latitude = latitude;
    _longitude = longitude;
    _address = address;
    notifyListeners();
  }

  Future<bool> saveChanges() async {
    if (_advertisement == null) return false;

    if (!formKey.currentState!.validate()) return false;

    if (_existingImages.isEmpty && _newImages.isEmpty) {
      _errorMessage = 'At least one image is required';
      notifyListeners();
      return false;
    }

    _status = EditAdStatus.uploading;
    _uploadProgress = 0.0;
    _errorMessage = null;
    notifyListeners();

    try {
      // Upload new images if any
      List<String> uploadedUrls = [];
      if (_newImages.isNotEmpty) {
        final imagePaths = _newImages.map((file) => file.path).toList();
        final uploadResult = await uploadAdImagesUseCase(
          UploadAdImagesParams(imagePaths: imagePaths),
        );

        uploadResult.fold(
          (failure) {
            throw Exception(_getFailureMessage(failure));
          },
          (urls) {
            uploadedUrls = urls;
          },
        );
      }

      _uploadProgress = 0.5;
      notifyListeners();

      // Combine existing and new images
      final allImages = [..._existingImages, ...uploadedUrls];

      // Create edit request
      final request = EditAdRequestEntity(
        id: _advertisement!.id,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        phone: phoneController.text.trim(),
        price: double.tryParse(priceController.text.trim()),
        district: _district,
        latitude: _latitude,
        longitude: _longitude,
        address: _address,
        images: allImages,
        newImages: uploadedUrls,
        removedImages: _removedImages,
      );

      _uploadProgress = 0.8;
      notifyListeners();

      // Save changes
      final editResult = await editAdUseCase(EditAdParams(request: request));

      editResult.fold(
        (failure) {
          throw Exception(_getFailureMessage(failure));
        },
        (response) {
          _status = EditAdStatus.success;
          _uploadProgress = 1.0;
        },
      );

      notifyListeners();
      return true;
    } catch (e) {
      _status = EditAdStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _getFailureMessage(Failure failure) {
    switch (failure.runtimeType) {
      case const (NetworkFailure):
        return 'No internet connection. Please check your network.';
      case const (ServerFailure):
        return failure.message.isNotEmpty
            ? failure.message
            : 'Server error. Please try again later.';
      case const (CacheFailure):
        return 'Cache error. Please refresh the app.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}

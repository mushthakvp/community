import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vivera/core/utils/result.dart';

import '../../data/models/ad_creation_model.dart';
import '../../data/models/category_model.dart';
import '../../data/models/cities_response_model.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/usecases/create_ad_usecase.dart';
import '../../domain/usecases/get_cities_usecase.dart';
import '../../domain/usecases/upload_images_usecase.dart';

enum AddEditState { initial, loading, success, error }

class AddEditProvider extends ChangeNotifier {
  final GetCitiesUseCase getCitiesUseCase;
  final CreateAdUseCase createAdUseCase;
  final UploadImagesUseCase uploadImagesUseCase;

  AddEditProvider({
    required this.getCitiesUseCase,
    required this.createAdUseCase,
    required this.uploadImagesUseCase,
  });

  // State management
  AddEditState _state = AddEditState.initial;
  AddEditState get state => _state;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Data
  CitiesResponseModel? _citiesResponse;
  CitiesResponseModel? get citiesResponse => _citiesResponse;

  List<String> _cityList = [];
  List<String> get cityList => _cityList;

  CategoryModel? _selectedCategory;
  CategoryModel? get selectedCategory => _selectedCategory;

  // Form controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  // Images
  final List<File> _selectedImages = [];
  List<File> get selectedImages => _selectedImages;

  // Location
  LocationEntity? _currentLocation;
  LocationEntity? get currentLocation => _currentLocation;

  // Selected values
  String _selectedCity = '';
  String get selectedCity => _selectedCity;

  String _selectedCategoryId = '';
  String get selectedCategoryId => _selectedCategoryId;

  String _selectedSubcategoryId = '';
  String get selectedSubcategoryId => _selectedSubcategoryId;

  // Methods
  void _setState(AddEditState newState) {
    _state = newState;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _setState(AddEditState.error);
  }

  Future<void> getCitiesAndCategories() async {
    _setState(AddEditState.loading);

    final result = await getCitiesUseCase();

    result.fold(
      onSuccess: (data) {
        _citiesResponse = data;
        _cityList = data.cities ?? [];
        _setState(AddEditState.success);
      },
      onError: (error) => _setError(error),
    );
  }

  void searchCities(String query) {
    if (query.isEmpty || query.length < 2) {
      _cityList = _citiesResponse?.cities ?? [];
    } else {
      _cityList = (_citiesResponse?.cities ?? [])
          .where((city) => city.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void selectCity(String city) {
    _selectedCity = city;
    notifyListeners();
  }

  void selectCategory(CategoryModel category) {
    _selectedCategory = category;
    _selectedCategoryId = category.id ?? '';
    notifyListeners();
  }

  void selectSubcategory(String subcategoryId) {
    _selectedSubcategoryId = subcategoryId;
    notifyListeners();
  }

  Future<void> pickImages({required bool fromGallery}) async {
    try {
      if (_selectedImages.length >= 10) {
        _setError("You can't add more than 10 images");
        return;
      }
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: fromGallery ? ImageSource.gallery : ImageSource.camera,
      );
      if (image != null) {
        _selectedImages.add(File(image.path));
        notifyListeners();
      }
    } catch (e) {
      _setError("Failed to pick image: ${e.toString()}");
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < _selectedImages.length) {
      _selectedImages.removeAt(index);
      notifyListeners();
    }
  }

  Future<void> updateLocation(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        _currentLocation = LocationEntity(
          latitude: latitude,
          longitude: longitude,
          placeName: place.locality ?? "Unknown Location",
          address: "${place.street}, ${place.locality}, ${place.country}",
        );
        notifyListeners();
      }
    } catch (e) {
      _setError("Failed to get location: ${e.toString()}");
    }
  }

  Future<void> createAd() async {
    if (!_validateForm()) return;
    _setState(AddEditState.loading);
    try {
      List<String> imageUrls = [];
      if (_selectedImages.isNotEmpty) {
        final uploadResult = await uploadImagesUseCase(_selectedImages);
        uploadResult.fold(
          onSuccess: (urls) => imageUrls = urls,
          onError: (error) {
            _setError(error);
            return;
          },
        );
      }
      final adModel = AdCreationModel(
        district: _selectedCity.isEmpty ? 'Default City' : _selectedCity,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        images: imageUrls,
        category: _selectedCategoryId,
        subCategory: _selectedSubcategoryId,
        latitude: _currentLocation?.latitude?.toString(),
        longitude: _currentLocation?.longitude?.toString(),
        address: _currentLocation?.address ?? addressController.text.trim(),
        price: double.tryParse(priceController.text.trim()),
        phone: phoneController.text.trim(),
      );
      final result = await createAdUseCase(adModel);
      result.fold(
        onSuccess: (message) {
          _resetForm();
          _setState(AddEditState.success);
        },
        onError: (error) => _setError(error),
      );
    } catch (e) {
      _setError("Failed to create ad: ${e.toString()}");
    }
  }

  bool _validateForm() {
    if (titleController.text.trim().isEmpty) {
      _setError("Please enter a title");
      return false;
    }
    if (descriptionController.text.trim().isEmpty) {
      _setError("Please enter a description");
      return false;
    }
    if (phoneController.text.trim().isEmpty) {
      _setError("Please enter your phone number");
      return false;
    }
    if (_selectedImages.isEmpty) {
      _setError("Please add at least one image");
      return false;
    }
    if (_currentLocation == null || !_currentLocation!.isValid) {
      _setError("Please select a location");
      return false;
    }
    return true;
  }

  void _resetForm() {
    titleController.clear();
    descriptionController.clear();
    priceController.clear();
    phoneController.clear();
    addressController.clear();
    _selectedImages.clear();
    _currentLocation = null;
    _selectedCity = '';
    _selectedCategoryId = '';
    _selectedSubcategoryId = '';
    _selectedCategory = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    if (_state == AddEditState.error) {
      _setState(AddEditState.initial);
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }
}

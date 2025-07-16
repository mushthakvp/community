import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/utils/result.dart';
import '../../../../../core/utils/validators.dart';
import '../../domain/entities/company_entity.dart';
import '../../domain/usecases/create_company_usecase.dart';
import '../../domain/usecases/update_company_usecase.dart';
import '../../domain/usecases/upload_image_usecase.dart';

enum CreateCompanyStatus { initial, loading, success, error }

class CreateCompanyProvider extends ChangeNotifier {
  final CreateCompanyUseCase _createCompanyUseCase;
  final UpdateCompanyUseCase _updateCompanyUseCase;
  final UploadImageUseCase _uploadImageUseCase;

  CreateCompanyProvider({
    required CreateCompanyUseCase createCompanyUseCase,
    required UpdateCompanyUseCase updateCompanyUseCase,
    required UploadImageUseCase uploadImageUseCase,
  }) : _createCompanyUseCase = createCompanyUseCase,
       _updateCompanyUseCase = updateCompanyUseCase,
       _uploadImageUseCase = uploadImageUseCase;

  // Form Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  // State
  CreateCompanyStatus _status = CreateCompanyStatus.initial;
  String _errorMessage = '';
  String? _companyImage;
  String? _companyId;
  bool _isFromUpdate = false;
  double _imageUploadProgress = 0.0;
  bool _isUploadingImage = false;
  double? _lat;
  double? _lng;
  String? _placeName;

  // Getters
  CreateCompanyStatus get status => _status;
  String get errorMessage => _errorMessage;
  String? get companyImage => _companyImage;
  bool get isFromUpdate => _isFromUpdate;
  bool get isLoading => _status == CreateCompanyStatus.loading;
  double get imageUploadProgress => _imageUploadProgress;
  bool get isUploadingImage => _isUploadingImage;
  double? get lat => _lat;
  double? get lng => _lng;
  String? get placeName => _placeName;

  // Location methods
  void setLocation({
    required double lat,
    required double lng,
    String? placeName,
  }) {
    _lat = lat;
    _lng = lng;
    _placeName = placeName;
    locationController.text = placeName ?? 'Location Selected';
    notifyListeners();
  }

  // Image picker method
  Future<void> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        await _uploadImage(image.path);
      }
    } catch (e) {
      _errorMessage = 'Failed to pick image: $e';
      notifyListeners();
    }
  }

  Future<void> _uploadImage(String filePath) async {
    _isUploadingImage = true;
    _imageUploadProgress = 0.0;
    notifyListeners();

    final result = await _uploadImageUseCase(
      UploadImageParams(filePath: filePath),
    );

    result.fold(
      (failure) {
        _errorMessage = _getFailureMessage(failure);
        _isUploadingImage = false;
        _imageUploadProgress = 0.0;
        notifyListeners();
      },
      (imageUrl) {
        _companyImage = imageUrl;
        _isUploadingImage = false;
        _imageUploadProgress = 1.0;
        notifyListeners();
      },
    );
  }

  // Validation methods
  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter the company name';
    }
    if (value.trim().length < 2) {
      return 'Company name must be at least 2 characters';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter email address';
    }
    if (!Validators.isValidEmail(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter phone number';
    }
    if (!Validators.isValidPhone(value.trim())) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  String? validateWebsite(String? value) {
    if (value != null && value.trim().isNotEmpty) {
      if (!Validators.isValidUrl(value.trim())) {
        return 'Please enter a valid website URL';
      }
    }
    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter company description';
    }
    final wordCount = Validators.countWords(value.trim());
    if (wordCount < 20) {
      return 'Company description must be at least 50 words (currently $wordCount words)';
    }
    return null;
  }

  // Form validation
  bool _validateForm() {
    bool isValid = true;
    _errorMessage = '';

    // Validate all fields
    if (validateName(nameController.text) != null) {
      _errorMessage = validateName(nameController.text)!;
      isValid = false;
    } else if (validateEmail(emailController.text) != null) {
      _errorMessage = validateEmail(emailController.text)!;
      isValid = false;
    } else if (validatePhone(phoneController.text) != null) {
      _errorMessage = validatePhone(phoneController.text)!;
      isValid = false;
    } else if (validateWebsite(websiteController.text) != null) {
      _errorMessage = validateWebsite(websiteController.text)!;
      isValid = false;
    } else if (validateDescription(descriptionController.text) != null) {
      _errorMessage = validateDescription(descriptionController.text)!;
      isValid = false;
    }

    return isValid;
  }

  // Main create/update method
  Future<Result<CompanyEntity>> submitForm() async {
    if (!_validateForm()) {
      notifyListeners();
      return Error(message: _errorMessage);
    }

    _status = CreateCompanyStatus.loading;
    _errorMessage = '';
    notifyListeners();
    final company = CompanyEntity(
      id: _companyId,
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      website: websiteController.text.trim().isEmpty
          ? null
          : websiteController.text.trim(),
      description: descriptionController.text.trim(),
      image: _companyImage,
      lat: _lat,
      lng: _lng,
      location: _placeName,
      action: _isFromUpdate ? 'update' : 'create',
    );

    try {
      final result = _isFromUpdate
          ? await _updateCompanyUseCase(UpdateCompanyParams(company: company))
          : await _createCompanyUseCase(CreateCompanyParams(company: company));

      return result.fold(
        (failure) {
          _status = CreateCompanyStatus.error;
          _errorMessage = _getFailureMessage(failure);
          notifyListeners();
          return Error(message: _errorMessage);
        },
        (createdCompany) {
          _status = CreateCompanyStatus.success;
          notifyListeners();
          return Success(createdCompany);
        },
      );
    } catch (e) {
      _status = CreateCompanyStatus.error;
      _errorMessage = 'An unexpected error occurred: $e';
      notifyListeners();
      return Error(message: _errorMessage);
    }
  }

  // Set controllers for update mode
  void setUpdateMode(CompanyEntity company) {
    _isFromUpdate = true;
    _companyId = company.id;
    nameController.text = company.name;
    emailController.text = company.email;
    phoneController.text = company.phone;
    websiteController.text = company.website ?? '';
    descriptionController.text = company.description;
    _companyImage = company.image;
    _lat = company.lat;
    _lng = company.lng;
    _placeName = company.location;
    locationController.text = company.location ?? '';
    notifyListeners();
  }

  // Clear form
  void clearForm() {
    _isFromUpdate = false;
    _companyId = null;
    _companyImage = null;
    _lat = null;
    _lng = null;
    _placeName = null;
    _status = CreateCompanyStatus.initial;
    _errorMessage = '';
    _imageUploadProgress = 0.0;
    _isUploadingImage = false;

    nameController.clear();
    emailController.clear();
    phoneController.clear();
    websiteController.clear();
    descriptionController.clear();
    locationController.clear();

    notifyListeners();
  }

  // Helper methods
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
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    websiteController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    super.dispose();
  }
}

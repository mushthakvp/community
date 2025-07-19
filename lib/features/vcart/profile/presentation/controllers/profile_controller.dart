import 'package:get/get.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../domain/entities/profile_data.dart';
import '../../domain/usecases/get_profile_data.dart';

class VCartProfileController extends GetxController {
  final GetProfileData getProfileDataUseCase;

  VCartProfileController({required this.getProfileDataUseCase});

  // Observable variables
  final _isLoading = false.obs;
  final _profileData = Rxn<ProfileData>();
  final _errorMessage = ''.obs;
  final _hasError = false.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  ProfileData? get profileData => _profileData.value;
  String get errorMessage => _errorMessage.value;
  bool get hasError => _hasError.value;

  // Computed properties
  String get userName => profileData?.user.name ?? '';
  String get userEmail => profileData?.user.email ?? '';
  String get userPhone => profileData?.user.phone ?? '';
  String? get userProfilePicture => profileData?.user.profilePicture;
  String get userRole => profileData?.user.role ?? '';

  @override
  void onInit() {
    super.onInit();
    fetchProfileData();
  }

  Future<void> fetchProfileData({bool forceRefresh = false}) async {
    try {
      if (!forceRefresh && profileData != null) return;

      _setLoading(true);
      _clearError();

      final result = await getProfileDataUseCase(NoParams());

      result.fold((failure) => _handleFailure(failure), (data) {
        _profileData.value = data;
        _setLoading(false);
      });
    } catch (e) {
      _handleError('Unexpected error occurred: $e');
    }
  }

  Future<void> refreshData() async {
    await fetchProfileData(forceRefresh: true);
  }

  void _setLoading(bool value) {
    _isLoading.value = value;
  }

  void _clearError() {
    _hasError.value = false;
    _errorMessage.value = '';
  }

  void _handleFailure(Failure failure) {
    _setLoading(false);
    _handleError(failure.message);
  }

  void _handleError(String message) {
    _hasError.value = true;
    _errorMessage.value = message;
    _setLoading(false);
  }

  @override
  void onClose() {
    _profileData.close();
    _errorMessage.close();
    _hasError.close();
    _isLoading.close();
    super.onClose();
  }
}

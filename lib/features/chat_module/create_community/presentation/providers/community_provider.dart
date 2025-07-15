import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../vchat/presentation/providers/vchat_provider.dart';
import '../../domain/entities/community_entity.dart';
import '../../domain/usecases/create_community.dart';
import '../../domain/usecases/delete_community.dart';
import '../../domain/usecases/get_community_details.dart';
import '../../domain/usecases/join_community.dart';
import '../../domain/usecases/leave_community.dart';
import '../../domain/usecases/update_community.dart';
import '../../domain/usecases/upload_profile_image.dart';

enum CommunityState { initial, loading, success, error }

class CommunityProvider extends ChangeNotifier {
  final CreateCommunity createCommunityUseCase;
  final UpdateCommunity updateCommunityUseCase;
  final GetCommunityDetails getCommunityDetailsUseCase;
  final UploadProfileImage uploadProfileImageUseCase;
  final DeleteCommunity deleteCommunityUseCase;
  final JoinCommunity joinCommunityUseCase;
  final LeaveCommunity leaveCommunityUseCase;

  CommunityProvider({
    required this.createCommunityUseCase,
    required this.updateCommunityUseCase,
    required this.getCommunityDetailsUseCase,
    required this.uploadProfileImageUseCase,
    required this.deleteCommunityUseCase,
    required this.joinCommunityUseCase,
    required this.leaveCommunityUseCase,
  });

  // Controllers
  final TextEditingController communityNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // State management
  CommunityState _state = CommunityState.initial;
  String? _errorMessage;
  CommunityEntity? _currentCommunity;
  File? _selectedImage;
  String? _uploadedImageUrl;
  bool _isImageUploading = false;

  // Getters
  CommunityState get state => _state;
  String? get errorMessage => _errorMessage;
  CommunityEntity? get currentCommunity => _currentCommunity;
  File? get selectedImage => _selectedImage;
  String? get uploadedImageUrl => _uploadedImageUrl;
  bool get isImageUploading => _isImageUploading;
  bool get isLoading => _state == CommunityState.loading;
  bool get hasImage => _selectedImage != null || _uploadedImageUrl != null;

  // Image selection
  Future<void> selectImage({ImageSource source = ImageSource.gallery}) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 80,
      );
      if (image != null) {
        _selectedImage = File(image.path);
        _uploadedImageUrl = null;
        notifyListeners();
        await uploadImage();
      }
    } catch (e) {
      _setError('Failed to select image: ${e.toString()}');
    }
  }

  // Upload image
  Future<void> uploadImage() async {
    if (_selectedImage == null) return;

    _isImageUploading = true;
    notifyListeners();

    final result = await uploadProfileImageUseCase(
      UploadProfileImageParams(imagePath: _selectedImage!.path),
    );

    result.fold(
      (failure) {
        _setError('Failed to upload image: ${failure.message}');
        _isImageUploading = false;
        notifyListeners();
      },
      (imageUrl) {
        _uploadedImageUrl = imageUrl;
        _isImageUploading = false;
        notifyListeners();
      },
    );
  }

  // Create community
  Future<void> createCommunity({VChatProvider? vChatProvider}) async {
    if (!formKey.currentState!.validate()) return;

    _setState(CommunityState.loading);

    final result = await createCommunityUseCase(
      CreateCommunityParams(
        name: communityNameController.text.trim(),
        description: descriptionController.text.trim().isEmpty
            ? null
            : descriptionController.text.trim(),
        profileImage: _uploadedImageUrl,
      ),
    );

    result.fold((failure) => _setError(failure.message), (community) {
      _currentCommunity = community;
      _setState(CommunityState.success);

      // Notify VChat provider to refresh data
      if (vChatProvider != null) {
        // Convert to VChat CommunityEntity if needed
        final vChatCommunity = _convertToVChatEntity(community);
        vChatProvider.addNewCommunity(vChatCommunity);
      }

      _clearForm();
    });
  }

  // Update community
  Future<void> updateCommunity(
    String communityId, {
    VChatProvider? vChatProvider,
  }) async {
    if (!formKey.currentState!.validate()) return;

    _setState(CommunityState.loading);

    final result = await updateCommunityUseCase(
      UpdateCommunityParams(
        communityId: communityId,
        name: communityNameController.text.trim(),
        description: descriptionController.text.trim().isEmpty
            ? null
            : descriptionController.text.trim(),
        profileImage: _uploadedImageUrl,
      ),
    );

    result.fold((failure) => _setError(failure.message), (community) {
      _currentCommunity = community;
      _setState(CommunityState.success);

      // Notify VChat provider to update data
      if (vChatProvider != null) {
        final vChatCommunity = _convertToVChatEntity(community);
        vChatProvider.updateCommunity(vChatCommunity);
      }
    });
  }

  // Get community details
  Future<void> getCommunityDetails(String communityId) async {
    _setState(CommunityState.loading);

    final result = await getCommunityDetailsUseCase(
      GetCommunityDetailsParams(communityId: communityId),
    );

    result.fold((failure) => _setError(failure.message), (community) {
      _currentCommunity = community;
      _populateForm(community);
      _setState(CommunityState.success);
    });
  }

  // Delete community
  Future<void> deleteCommunity(
    String communityId, {
    VChatProvider? vChatProvider,
  }) async {
    _setState(CommunityState.loading);

    final result = await deleteCommunityUseCase(
      DeleteCommunityParams(communityId: communityId),
    );

    result.fold((failure) => _setError(failure.message), (_) {
      _currentCommunity = null;
      _setState(CommunityState.success);

      // Notify VChat provider to remove community
      if (vChatProvider != null) {
        vChatProvider.removeCommunity(communityId);
      }

      _clearForm();
    });
  }

  // Join community
  Future<void> joinCommunity(String communityId) async {
    final result = await joinCommunityUseCase(
      JoinCommunityParams(communityId: communityId),
    );

    result.fold((failure) => _setError(failure.message), (_) {
      // Update local state if needed
      if (_currentCommunity != null && _currentCommunity!.id == communityId) {
        _currentCommunity = _currentCommunity!.copyWith(
          isUserInGroup: true,
          isUserRequested: true,
        );
        notifyListeners();
      }
    });
  }

  // Leave community
  Future<void> leaveCommunity(String communityId) async {
    final result = await leaveCommunityUseCase(
      LeaveCommunityParams(communityId: communityId),
    );

    result.fold((failure) => _setError(failure.message), (_) {
      // Update local state if needed
      if (_currentCommunity != null && _currentCommunity!.id == communityId) {
        _currentCommunity = _currentCommunity!.copyWith(
          isUserInGroup: false,
          isUserRequested: false,
        );
        notifyListeners();
      }
    });
  }

  // Remove selected image
  void removeImage() {
    _selectedImage = null;
    _uploadedImageUrl = null;
    notifyListeners();
  }

  // Show image source selection
  Future<void> showImageSourceSelection(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Select Image Source',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ImageSourceOption(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(source: ImageSource.camera);
                  },
                ),
                _ImageSourceOption(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(source: ImageSource.gallery);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Convert create_community entity to vchat entity
  dynamic _convertToVChatEntity(CommunityEntity community) {
    // This is a placeholder - you'll need to implement the actual conversion
    // based on your VChat CommunityEntity structure
    return community;
  }

  // Private methods
  void _setState(CommunityState newState) {
    _state = newState;
    if (newState != CommunityState.error) {
      _errorMessage = null;
    }
    notifyListeners();
  }

  void _setError(String message) {
    _state = CommunityState.error;
    _errorMessage = message;
    notifyListeners();
  }

  void _populateForm(CommunityEntity community) {
    communityNameController.text = community.name;
    descriptionController.text = community.description ?? '';
    _uploadedImageUrl = community.profileImage;
    _selectedImage = null;
  }

  void _clearForm() {
    communityNameController.clear();
    descriptionController.clear();
    _selectedImage = null;
    _uploadedImageUrl = null;
  }

  void clearError() {
    _errorMessage = null;
    if (_state == CommunityState.error) {
      _state = CommunityState.initial;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    communityNameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}

// Helper widget for image source selection
class _ImageSourceOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ImageSourceOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

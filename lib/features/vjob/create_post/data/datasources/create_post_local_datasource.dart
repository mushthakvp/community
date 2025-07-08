import '../../../../../core/error/exceptions.dart';
import '../../../../../core/services/storage_service.dart';
import '../models/create_post_model.dart';

abstract class CreatePostLocalDataSource {
  Future<void> cacheDraftPost(CreatePostRequestModel request);
  Future<CreatePostRequestModel?> getCachedDraftPost();
  Future<void> clearDraftPost();
  Future<void> cacheUploadedImages(List<String> imageUrls);
  Future<List<String>> getCachedImages();
  Future<void> clearImageCache();
}

class CreatePostLocalDataSourceImpl implements CreatePostLocalDataSource {
  static const String _draftPostKey = 'draft_post';
  static const String _uploadedImagesKey = 'uploaded_images';

  @override
  Future<void> cacheDraftPost(CreatePostRequestModel request) async {
    try {
      await StorageService.setCacheWithExpiry(_draftPostKey, {
        'title': request.title,
        'description': request.description,
        'image': request.image,
      }, expiry: const Duration(hours: 24));
    } catch (e) {
      throw CacheException('Failed to cache draft post: $e');
    }
  }

  @override
  Future<CreatePostRequestModel?> getCachedDraftPost() async {
    try {
      final cachedData = StorageService.getCacheIfValid(_draftPostKey);
      if (cachedData != null) {
        return CreatePostRequestModel(
          title: cachedData['title'] ?? '',
          description: cachedData['description'] ?? '',
          image: cachedData['image'],
        );
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get cached draft post: $e');
    }
  }

  @override
  Future<void> clearDraftPost() async {
    try {
      await StorageService.remove(_draftPostKey);
    } catch (e) {
      throw CacheException('Failed to clear draft post: $e');
    }
  }

  @override
  Future<void> cacheUploadedImages(List<String> imageUrls) async {
    try {
      await StorageService.setCacheWithExpiry(_uploadedImagesKey, {
        'images': imageUrls,
      }, expiry: const Duration(hours: 1));
    } catch (e) {
      throw CacheException('Failed to cache uploaded images: $e');
    }
  }

  @override
  Future<List<String>> getCachedImages() async {
    try {
      final cachedData = StorageService.getCacheIfValid(_uploadedImagesKey);
      if (cachedData != null) {
        return List<String>.from(cachedData['images'] ?? []);
      }
      return [];
    } catch (e) {
      throw CacheException('Failed to get cached images: $e');
    }
  }

  @override
  Future<void> clearImageCache() async {
    try {
      await StorageService.remove(_uploadedImagesKey);
    } catch (e) {
      throw CacheException('Failed to clear image cache: $e');
    }
  }
}

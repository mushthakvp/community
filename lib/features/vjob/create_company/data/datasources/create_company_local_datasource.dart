import '../../../../../core/error/exceptions.dart';
import '../../../../../core/services/storage_service.dart';
import '../models/company_model.dart';

abstract class CreateCompanyLocalDataSource {
  Future<CompanyModel?> getCachedCompany();
  Future<void> cacheCompany(CompanyModel company);
  Future<void> clearCache();
}

class CreateCompanyLocalDataSourceImpl implements CreateCompanyLocalDataSource {
  static const String _companyKey = 'cached_company';

  @override
  Future<CompanyModel?> getCachedCompany() async {
    try {
      final cachedData = StorageService.getCacheIfValid(_companyKey);
      if (cachedData != null) {
        return CompanyModel.fromJson(cachedData);
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get cached company: $e');
    }
  }

  @override
  Future<void> cacheCompany(CompanyModel company) async {
    try {
      await StorageService.setCacheWithExpiry(
        _companyKey,
        company.toJson(),
        expiry: const Duration(hours: 24),
      );
    } catch (e) {
      throw CacheException('Failed to cache company: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await StorageService.remove(_companyKey);
    } catch (e) {
      throw CacheException('Failed to clear cache: $e');
    }
  }
}

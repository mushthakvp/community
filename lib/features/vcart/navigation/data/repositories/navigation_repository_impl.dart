import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/services/storage_service.dart';
import '../../../core/constants/vcart_constants.dart';
import '../../domain/entities/nav_item.dart';
import '../../domain/repositories/navigation_repository.dart';
import '../models/nav_item_model.dart';

class NavigationRepositoryImpl implements NavigationRepository {
  static const String _currentIndexKey =
      '${VCartConstants.cacheKeyPrefix}current_nav_index';

  @override
  Future<Either<Failure, List<NavItem>>> getNavigationItems() async {
    try {
      final items = [
        const NavItemModel(
          id: 0,
          label: 'Home',
          icon: '🏠',
          route: '/home',
          isActive: true,
        ),
        const NavItemModel(
          id: 1,
          label: 'Categories',
          icon: '📂',
          route: '/categories',
        ),
        const NavItemModel(id: 2, label: 'Cart', icon: '🛒', route: '/cart'),
        const NavItemModel(
          id: 3,
          label: 'Profile',
          icon: '👤',
          route: '/profile',
        ),
      ];

      return Right(items);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setCurrentIndex(int index) async {
    try {
      await StorageService.setInt(_currentIndexKey, index);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to save current index: $e'));
    }
  }

  @override
  Future<Either<Failure, int>> getCurrentIndex() async {
    try {
      final index = StorageService.getInt(_currentIndexKey);
      return Right(index);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get current index: $e'));
    }
  }
}

import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/nav_item.dart';

abstract class NavigationRepository {
  Future<Either<Failure, List<NavItem>>> getNavigationItems();
  Future<Either<Failure, void>> setCurrentIndex(int index);
  Future<Either<Failure, int>> getCurrentIndex();
}

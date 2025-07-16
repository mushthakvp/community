import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/home_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, UserDetailsEntity>> getUserDetails();
  Future<Either<Failure, List<NotificationEntity>>> getNotifications();
}

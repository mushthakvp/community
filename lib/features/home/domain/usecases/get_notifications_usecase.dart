// features/home/domain/usecases/get_notifications_usecase.dart
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/home_entity.dart';
import '../repositories/home_repository.dart';

class GetNotificationsUseCase {
  final HomeRepository repository;

  GetNotificationsUseCase(this.repository);

  Future<Either<Failure, List<NotificationEntity>>> call() async {
    return await repository.getNotifications();
  }
}

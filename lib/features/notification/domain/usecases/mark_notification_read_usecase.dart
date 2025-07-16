import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/notification_repository.dart';

class MarkNotificationReadUseCase {
  final NotificationRepository repository;

  MarkNotificationReadUseCase(this.repository);

  Future<Either<Failure, bool>> call(String notificationId) async {
    if (notificationId.trim().isEmpty) {
      return const Left(
        ValidationFailure(message: 'Notification ID cannot be empty'),
      );
    }

    return await repository.markNotificationAsRead(notificationId);
  }
}

class MarkAllNotificationsReadUseCase {
  final NotificationRepository repository;

  MarkAllNotificationsReadUseCase(this.repository);

  Future<Either<Failure, bool>> call() async {
    return await repository.markAllNotificationsAsRead();
  }
}

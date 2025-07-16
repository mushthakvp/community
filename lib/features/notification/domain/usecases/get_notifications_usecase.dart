import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

class GetNotificationsUseCase {
  final NotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  Future<Either<Failure, List<NotificationEntity>>> call({
    int? limit,
    int? offset,
    bool? unreadOnly,
    List<NotificationType>? types,
  }) async {
    return await repository.getNotifications(
      limit: limit,
      offset: offset,
      unreadOnly: unreadOnly,
      types: types,
    );
  }
}

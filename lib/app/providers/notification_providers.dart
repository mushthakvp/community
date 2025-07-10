import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../core/network/api_client.dart';
import '../../features/notification/data/datasources/notification_remote_datasource.dart';
import '../../features/notification/data/repositories/notification_repository_impl.dart';
import '../../features/notification/domain/repositories/notification_repository.dart';
import '../../features/notification/domain/usecases/get_notifications_usecase.dart';
import '../../features/notification/domain/usecases/mark_notification_read_usecase.dart';
import '../../features/notification/presentation/providers/notification_provider.dart';

/// Notification feature providers
class NotificationProviders {
  static List<SingleChildWidget> get providers => [
    // ========================================
    // NOTIFICATION DATA LAYER PROVIDERS
    // ========================================

    // Remote DataSource
    ProxyProvider<ApiClient, NotificationRemoteDataSource>(
      update: (_, apiClient, __) =>
          NotificationRemoteDataSourceImpl(apiClient: apiClient),
    ),

    // Repository
    ProxyProvider<NotificationRemoteDataSource, NotificationRepository>(
      update: (_, remoteDataSource, __) =>
          NotificationRepositoryImpl(remoteDataSource: remoteDataSource),
    ),

    // ========================================
    // NOTIFICATION DOMAIN LAYER PROVIDERS
    // ========================================

    // Use Cases
    ProxyProvider<NotificationRepository, GetNotificationsUseCase>(
      update: (_, repository, __) => GetNotificationsUseCase(repository),
    ),

    ProxyProvider<NotificationRepository, MarkNotificationReadUseCase>(
      update: (_, repository, __) => MarkNotificationReadUseCase(repository),
    ),

    ProxyProvider<NotificationRepository, MarkAllNotificationsReadUseCase>(
      update: (_, repository, __) =>
          MarkAllNotificationsReadUseCase(repository),
    ),

    // ========================================
    // NOTIFICATION PRESENTATION LAYER PROVIDERS
    // ========================================

    // Notification Provider
    ChangeNotifierProxyProvider<NotificationRepository, NotificationProvider>(
      create: (context) => NotificationProvider(
        repository: Provider.of<NotificationRepository>(context, listen: false),
      ),
      update: (context, repository, notificationProvider) =>
          notificationProvider ?? NotificationProvider(repository: repository),
    ),
  ];
}

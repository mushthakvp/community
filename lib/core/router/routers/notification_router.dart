import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../features/notification/presentation/pages/notification_page.dart';
import '../../constants/route_constants.dart';

class NotificationRouter {
  static List<RouteBase> get routes => [
    // Main notification page
    GoRoute(
      path: RouteConstants.notifications,
      name: 'notifications',
      pageBuilder: (context, state) =>
          const MaterialPage(child: NotificationPage()),
    ),
  ];

  // Helper methods for navigation
  static void goToNotifications(BuildContext context) {
    context.go(RouteConstants.notifications);
  }

  static void goToNotificationDetail(
    BuildContext context,
    String notificationId,
  ) {
    context.go('${RouteConstants.notifications}/detail/$notificationId');
  }

  static void goToNotificationSettings(BuildContext context) {
    context.go('${RouteConstants.notifications}/settings');
  }

  static void pushNotifications(BuildContext context) {
    context.push(RouteConstants.notifications);
  }

  static void pushNotificationDetail(
    BuildContext context,
    String notificationId,
  ) {
    context.push('${RouteConstants.notifications}/detail/$notificationId');
  }

  static void pushNotificationSettings(BuildContext context) {
    context.push('${RouteConstants.notifications}/settings');
  }
}

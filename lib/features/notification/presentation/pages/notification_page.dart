import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/widgets/common/app_bar.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../../../../core/widgets/loading/loading_widget.dart';
import '../../domain/entities/notification_entity.dart';
import '../providers/notification_provider.dart';
import '../widgets/notification_card.dart';
import '../widgets/notification_empty_widget.dart';
import '../widgets/notification_error_widget.dart';
import '../widgets/notification_group_header.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late ScrollController _scrollController;
  String? token;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      token = await StorageService.getToken();
      if (token != null) {
        context.read<NotificationProvider>().initialize();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<NotificationProvider>().loadMoreNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (token == null) {
      return _buildNotLoggedInWidget();
    }

    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: CommonAppBar(
        title: "Notifications",
        showBackButton: true,
        actions: [_buildAppBarActions()],
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.notifications.isEmpty) {
            return const Center(child: LoadingWidget());
          }

          if (provider.hasError && provider.notifications.isEmpty) {
            return NotificationErrorWidget(
              message: provider.errorMessage ?? 'Something went wrong',
              onRetry: () => provider.loadNotifications(forceRefresh: true),
            );
          }

          if (provider.isEmpty) {
            return NotificationEmptyWidget(
              message: provider.showUnreadOnly
                  ? 'No unread notifications'
                  : 'No notifications yet',
              onRefresh: () => provider.loadNotifications(forceRefresh: true),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.refreshNotifications(),
            child: _buildNotificationsList(provider),
          );
        },
      ),
    );
  }

  Widget _buildNotLoggedInWidget() {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: CommonAppBar(title: "Notifications", showBackButton: true),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.login_outlined, size: 64, color: AppConstants.white),
            SizedBox(height: 16),
            CommonTextWidget(
              text: 'Please login to view notifications',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppConstants.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBarActions() {
    return Consumer<NotificationProvider>(
      builder: (context, provider, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Filter button
            IconButton(
              onPressed: () => _showFilterBottomSheet(context),
              icon: Stack(
                children: [
                  const Icon(
                    Icons.filter_alt_outlined,
                    color: AppConstants.white,
                  ),
                  if (provider.selectedTypes.isNotEmpty ||
                      provider.showUnreadOnly)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppConstants.appPrimaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Mark all as read button
            if (provider.unreadCount > 0)
              IconButton(
                onPressed: () => _showMarkAllAsReadDialog(context),
                icon: const Icon(
                  Icons.mark_email_read_outlined,
                  color: AppConstants.white,
                ),
              ),
            // More options
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: AppConstants.white),
              color: AppConstants.black,
              onSelected: (value) => _handleMenuSelection(context, value),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'refresh',
                  child: Row(
                    children: [
                      Icon(Icons.refresh, color: AppConstants.white),
                      SizedBox(width: 8),
                      CommonTextWidget(
                        text: 'Refresh',
                        color: AppConstants.white,
                      ),
                    ],
                  ),
                ),
                if (provider.notifications.isNotEmpty)
                  const PopupMenuItem(
                    value: 'clear_all',
                    child: Row(
                      children: [
                        Icon(Icons.clear_all, color: Colors.red),
                        SizedBox(width: 8),
                        CommonTextWidget(text: 'Clear All', color: Colors.red),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildNotificationsList(NotificationProvider provider) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // Header with count
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CommonTextWidget(
                  text: "${provider.notifications.length}",
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: AppConstants.white,
                ),
                CommonTextWidget(
                  text: " ${provider.unreadCount} ",
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: AppConstants.appPrimaryColor,
                ),
                CommonTextWidget(
                  text: "You have ${provider.unreadCount} unread notifications",
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: AppConstants.appPrimaryColor,
                ),
                CommonTextWidget(
                  text: "Today",
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: AppConstants.appPrimaryColor,
                ),
              ],
            ),
          ),
        ),
        // Grouped notifications
        ...provider.groupedNotifications.entries.map((entry) {
          final dateTitle = entry.key;
          final notifications = entry.value;

          return SliverList(
            delegate: SliverChildListDelegate([
              NotificationGroupHeader(title: dateTitle),
              ...notifications.map((notification) {
                return NotificationCard(
                  notification: notification,
                  onTap: () => _handleNotificationTap(context, notification),
                  onMarkAsRead: () =>
                      provider.markNotificationAsRead(notification.id),
                  onDelete: () =>
                      _showDeleteConfirmation(context, notification.id),
                );
              }),
            ]),
          );
        }),
        // Loading more indicator
        if (provider.isLoadingMore)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: LoadingWidget()),
            ),
          ),
        // No more data indicator
        if (!provider.hasMoreData && provider.notifications.isNotEmpty)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: CommonTextWidget(
                  text: 'No more notifications',
                  fontSize: 12,
                  color: AppConstants.white,
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppConstants.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildFilterBottomSheet(),
    );
  }

  Widget _buildFilterBottomSheet() {
    return Consumer<NotificationProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CommonTextWidget(
                text: 'Filter Notifications',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppConstants.white,
              ),
              const SizedBox(height: 20),
              // Unread only filter
              CheckboxListTile(
                title: const CommonTextWidget(
                  text: 'Show unread only',
                  color: AppConstants.white,
                ),
                value: provider.showUnreadOnly,
                onChanged: (value) => provider.setUnreadFilter(value ?? false),
                activeColor: AppConstants.appPrimaryColor,
              ),
              const SizedBox(height: 16),
              // Clear filters button
              if (provider.selectedTypes.isNotEmpty || provider.showUnreadOnly)
                TextButton(
                  onPressed: () {
                    provider.clearFilters();
                    Navigator.pop(context);
                  },
                  child: const CommonTextWidget(
                    text: 'Clear Filters',
                    color: AppConstants.appPrimaryColor,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _showMarkAllAsReadDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.black,
        title: const CommonTextWidget(
          text: 'Mark All as Read',
          color: AppConstants.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        content: const CommonTextWidget(
          text: 'Are you sure you want to mark all notifications as read?',
          color: AppConstants.white,
          fontSize: 14,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const CommonTextWidget(
              text: 'Cancel',
              color: AppConstants.white,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<NotificationProvider>().markAllNotificationsAsRead();
            },
            child: const CommonTextWidget(
              text: 'Mark All',
              color: AppConstants.appPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String notificationId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.black,
        title: const CommonTextWidget(
          text: 'Delete Notification',
          color: AppConstants.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        content: const CommonTextWidget(
          text: 'Are you sure you want to delete this notification?',
          color: AppConstants.white,
          fontSize: 14,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const CommonTextWidget(
              text: 'Cancel',
              color: AppConstants.white,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<NotificationProvider>().deleteNotification(
                notificationId,
              );
            },
            child: const CommonTextWidget(text: 'Delete', color: Colors.red),
          ),
        ],
      ),
    );
  }

  void _handleMenuSelection(BuildContext context, String value) {
    final provider = context.read<NotificationProvider>();

    switch (value) {
      case 'refresh':
        provider.loadNotifications(forceRefresh: true);
        break;
      case 'clear_all':
        _showClearAllConfirmation(context);
        break;
    }
  }

  void _showClearAllConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.black,
        title: const CommonTextWidget(
          text: 'Clear All Notifications',
          color: AppConstants.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        content: const CommonTextWidget(
          text:
              'Are you sure you want to clear all notifications? This action cannot be undone.',
          color: AppConstants.white,
          fontSize: 14,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const CommonTextWidget(
              text: 'Cancel',
              color: AppConstants.white,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<NotificationProvider>().clearAllNotifications();
            },
            child: const CommonTextWidget(text: 'Clear All', color: Colors.red),
          ),
        ],
      ),
    );
  }

  void _handleNotificationTap(
    BuildContext context,
    NotificationEntity notification,
  ) {
    // Mark as read if not already read
    if (!notification.isRead) {
      context.read<NotificationProvider>().markNotificationAsRead(
        notification.id,
      );
    }

    // Handle deep link navigation if available
    if (notification.hasDeepLink) {
      _handleDeepLink(context, notification.deepLink!);
    }
  }

  void _handleDeepLink(BuildContext context, String deepLink) {
    // Implement deep link navigation logic here
    // This depends on your app's routing system
    // For example, using go_router:
    // context.go(deepLink);

    // Or using Navigator:
    // Navigator.pushNamed(context, deepLink);

    // For now, just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: CommonTextWidget(
          text: 'Deep link: $deepLink',
          color: AppConstants.white,
        ),
        backgroundColor: AppConstants.appPrimaryColor,
      ),
    );
  }
}

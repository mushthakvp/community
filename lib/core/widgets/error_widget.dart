import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  final String message;
  final String? title;
  final VoidCallback? onRetry;
  final IconData? icon;
  final Color? iconColor;
  final String? retryText;
  final Widget? customIcon;
  final bool showRetryButton;
  final EdgeInsets? padding;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final double iconSize;
  final TextStyle? titleStyle;
  final TextStyle? messageStyle;
  final Color? backgroundColor;
  final double? height;
  final double? width;

  const CustomErrorWidget({
    super.key,
    required this.message,
    this.title,
    this.onRetry,
    this.icon,
    this.iconColor,
    this.retryText,
    this.customIcon,
    this.showRetryButton = true,
    this.padding,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.iconSize = 64,
    this.titleStyle,
    this.messageStyle,
    this.backgroundColor,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      color: backgroundColor,
      padding: padding ?? const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: [
          // Error Icon
          _buildErrorIcon(context),

          const SizedBox(height: 16),

          // Title (if provided)
          if (title != null) ...[
            Text(
              title!,
              style:
                  titleStyle ??
                  Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
          ],

          // Error Message
          Text(
            message,
            style:
                messageStyle ??
                Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[300],
                  height: 1.5,
                ),
            textAlign: TextAlign.center,
          ),

          // Retry Button
          if (showRetryButton && onRetry != null) ...[
            const SizedBox(height: 24),
            _buildRetryButton(context),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorIcon(BuildContext context) {
    if (customIcon != null) {
      return customIcon!;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: (iconColor ?? Colors.red).withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon ?? Icons.error_outline,
        size: iconSize,
        color: iconColor ?? Colors.red.withOpacity(0.8),
      ),
    );
  }

  Widget _buildRetryButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onRetry,
      icon: const Icon(Icons.refresh, size: 18),
      label: Text(retryText ?? 'Retry'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 2,
      ),
    );
  }
}

// Specialized error widgets for different scenarios
class NetworkErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  final String? message;

  const NetworkErrorWidget({super.key, this.onRetry, this.message});

  @override
  Widget build(BuildContext context) {
    return CustomErrorWidget(
      title: 'No Internet Connection',
      message:
          message ?? 'Please check your internet connection and try again.',
      icon: Icons.wifi_off,
      iconColor: Colors.orange,
      onRetry: onRetry,
      retryText: 'Try Again',
    );
  }
}

class ServerErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  final String? message;

  const ServerErrorWidget({super.key, this.onRetry, this.message});

  @override
  Widget build(BuildContext context) {
    return CustomErrorWidget(
      title: 'Server Error',
      message:
          message ?? 'Something went wrong on our end. Please try again later.',
      icon: Icons.dns,
      iconColor: Colors.red,
      onRetry: onRetry,
      retryText: 'Retry',
    );
  }
}

class NotFoundErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  final String? message;
  final String? title;

  const NotFoundErrorWidget({
    super.key,
    this.onRetry,
    this.message,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return CustomErrorWidget(
      title: title ?? 'Not Found',
      message: message ?? 'The content you\'re looking for could not be found.',
      icon: Icons.search_off,
      iconColor: Colors.grey,
      onRetry: onRetry,
      retryText: 'Go Back',
      showRetryButton: onRetry != null,
    );
  }
}

class UnauthorizedErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  final String? message;

  const UnauthorizedErrorWidget({super.key, this.onRetry, this.message});

  @override
  Widget build(BuildContext context) {
    return CustomErrorWidget(
      title: 'Access Denied',
      message: message ?? 'You don\'t have permission to access this content.',
      icon: Icons.lock,
      iconColor: Colors.amber,
      onRetry: onRetry,
      retryText: 'Login',
    );
  }
}

class EmptyStateWidget extends StatelessWidget {
  final String message;
  final String? title;
  final IconData? icon;
  final Widget? action;
  final VoidCallback? onAction;
  final String? actionText;

  const EmptyStateWidget({
    super.key,
    required this.message,
    this.title,
    this.icon,
    this.action,
    this.onAction,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return CustomErrorWidget(
      title: title ?? 'Nothing Here Yet',
      message: message,
      icon: icon ?? Icons.inbox,
      iconColor: Colors.grey[600],
      onRetry: onAction,
      retryText: actionText ?? 'Add Item',
      showRetryButton: onAction != null,
    );
  }
}

// Chat-specific error widgets
class ChatErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final ChatErrorType errorType;

  const ChatErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.errorType = ChatErrorType.general,
  });

  @override
  Widget build(BuildContext context) {
    switch (errorType) {
      case ChatErrorType.loadMembers:
        return CustomErrorWidget(
          title: 'Failed to Load Members',
          message: message,
          icon: Icons.group_off,
          iconColor: Colors.orange,
          onRetry: onRetry,
        );

      case ChatErrorType.loadRequests:
        return CustomErrorWidget(
          title: 'Failed to Load Requests',
          message: message,
          icon: Icons.notification_important,
          iconColor: Colors.red,
          onRetry: onRetry,
        );

      case ChatErrorType.loadFriends:
        return CustomErrorWidget(
          title: 'Failed to Load Friends',
          message: message,
          icon: Icons.people,
          iconColor: Colors.blue,
          onRetry: onRetry,
        );

      case ChatErrorType.communityNotFound:
        return CustomErrorWidget(
          title: 'Community Not Found',
          message: message,
          icon: Icons.search_off,
          iconColor: Colors.grey,
          onRetry: onRetry,
          showRetryButton: false,
        );

      case ChatErrorType.accessDenied:
        return CustomErrorWidget(
          title: 'Access Denied',
          message: message,
          icon: Icons.lock,
          iconColor: Colors.amber,
          onRetry: onRetry,
          retryText: 'Request Access',
        );

      case ChatErrorType.general:
        return CustomErrorWidget(message: message, onRetry: onRetry);
    }
  }
}

enum ChatErrorType {
  general,
  loadMembers,
  loadRequests,
  loadFriends,
  communityNotFound,
  accessDenied,
}

// Animated error widget (requires lottie package)
class AnimatedErrorWidget extends StatelessWidget {
  final String message;
  final String? title;
  final VoidCallback? onRetry;
  final String? animationAsset;

  const AnimatedErrorWidget({
    super.key,
    required this.message,
    this.title,
    this.onRetry,
    this.animationAsset,
  });

  @override
  Widget build(BuildContext context) {
    return CustomErrorWidget(
      title: title,
      message: message,
      onRetry: onRetry,
      customIcon: SizedBox(
        height: 120,
        width: 120,
        child: const Icon(Icons.error_outline, size: 64, color: Colors.red),
      ),
    );
  }
}

// Compact error widget for small spaces
class CompactErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData? icon;

  const CompactErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon ?? Icons.error_outline, color: Colors.red, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.red, fontSize: 14),
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: 8),
            TextButton(
              onPressed: onRetry,
              child: const Text('Retry', style: TextStyle(color: Colors.red)),
            ),
          ],
        ],
      ),
    );
  }
}

// Inline error widget for forms
class InlineErrorWidget extends StatelessWidget {
  final String message;
  final IconData? icon;
  final Color? color;

  const InlineErrorWidget({
    super.key,
    required this.message,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final errorColor = color ?? Colors.red;

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon ?? Icons.error_outline, color: errorColor, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: errorColor, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

// Helper methods for common error scenarios
class ErrorWidgetHelper {
  static Widget buildNetworkError({VoidCallback? onRetry}) {
    return NetworkErrorWidget(onRetry: onRetry);
  }

  static Widget buildServerError({VoidCallback? onRetry, String? message}) {
    return ServerErrorWidget(onRetry: onRetry, message: message);
  }

  static Widget buildNotFound({VoidCallback? onRetry, String? message}) {
    return NotFoundErrorWidget(onRetry: onRetry, message: message);
  }

  static Widget buildUnauthorized({VoidCallback? onRetry}) {
    return UnauthorizedErrorWidget(onRetry: onRetry);
  }

  static Widget buildEmptyState({
    required String message,
    String? title,
    IconData? icon,
    VoidCallback? onAction,
    String? actionText,
  }) {
    return EmptyStateWidget(
      message: message,
      title: title,
      icon: icon,
      onAction: onAction,
      actionText: actionText,
    );
  }

  static Widget buildChatError({
    required String message,
    VoidCallback? onRetry,
    ChatErrorType errorType = ChatErrorType.general,
  }) {
    return ChatErrorWidget(
      message: message,
      onRetry: onRetry,
      errorType: errorType,
    );
  }

  static Widget buildCompactError({
    required String message,
    VoidCallback? onRetry,
    IconData? icon,
  }) {
    return CompactErrorWidget(message: message, onRetry: onRetry, icon: icon);
  }

  static Widget buildInlineError({
    required String message,
    IconData? icon,
    Color? color,
  }) {
    return InlineErrorWidget(message: message, icon: icon, color: color);
  }
}

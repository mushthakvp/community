import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationCard extends StatefulWidget {
  final NotificationEntity notification;
  final VoidCallback onTap;
  final VoidCallback onMarkAsRead;
  final VoidCallback onDelete;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onMarkAsRead,
    required this.onDelete,
  });

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: _buildCard(),
        );
      },
    );
  }

  Widget _buildCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: widget.notification.isRead
            ? const Color(0xFF1A1A1A)
            : const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.notification.isRead
              ? AppConstants.white.withOpacity(0.1)
              : AppConstants.appPrimaryColor.withOpacity(0.3),
          width: widget.notification.isRead ? 0.5 : 1.0,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleTap(),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 8),
                _buildContent(),
                const SizedBox(height: 12),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // Type icon
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: widget.notification.type.color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            widget.notification.type.icon,
            size: 20,
            color: widget.notification.type.color,
          ),
        ),
        const SizedBox(width: 12),
        // Title and unread indicator
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: CommonTextWidget(
                  text: widget.notification.displayTitle,
                  fontSize: 16,
                  fontWeight: widget.notification.isRead
                      ? FontWeight.w500
                      : FontWeight.w600,
                  color: AppConstants.white,
                  maxLines: 1,
                ),
              ),
              if (!widget.notification.isRead)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(left: 8),
                  decoration: const BoxDecoration(
                    color: AppConstants.appPrimaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
        // Actions
        PopupMenuButton<String>(
          icon: Icon(
            Icons.more_vert,
            color: AppConstants.white.withOpacity(0.7),
            size: 20,
          ),
          color: AppConstants.black,
          onSelected: _handleMenuSelection,
          itemBuilder: (context) => [
            if (!widget.notification.isRead)
              const PopupMenuItem(
                value: 'mark_read',
                child: Row(
                  children: [
                    Icon(Icons.mark_email_read, color: AppConstants.white),
                    SizedBox(width: 8),
                    CommonTextWidget(
                      text: 'Mark as Read',
                      color: AppConstants.white,
                    ),
                  ],
                ),
              ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  CommonTextWidget(text: 'Delete', color: Colors.red),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Message
        CommonTextWidget(
          text: widget.notification.displayMessage,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppConstants.white.withOpacity(0.9),
          maxLines: 3,
        ),
        // Image if available
        if (widget.notification.hasImage) ...[
          const SizedBox(height: 12),
          _buildNotificationImage(),
        ],
      ],
    );
  }

  Widget _buildNotificationImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: widget.notification.imageUrl!,
        height: 120,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          height: 120,
          color: const Color(0xFF2A2A2A),
          child: const Center(
            child: CircularProgressIndicator(
              color: AppConstants.appPrimaryColor,
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          height: 120,
          color: const Color(0xFF2A2A2A),
          child: const Center(
            child: Icon(
              Icons.image_not_supported,
              color: AppConstants.white,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Type label
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: widget.notification.type.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: CommonTextWidget(
            text: widget.notification.type.displayName,
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: widget.notification.type.color,
          ),
        ),
        // Time ago
        CommonTextWidget(
          text: widget.notification.timeAgo,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppConstants.white.withOpacity(0.6),
        ),
      ],
    );
  }

  void _handleTap() async {
    await _animationController.forward();
    widget.onTap();
    await _animationController.reverse();
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'mark_read':
        widget.onMarkAsRead();
        break;
      case 'delete':
        widget.onDelete();
        break;
    }
  }
}

import 'package:flutter/material.dart';

import '../../../shared/utils/date_utils.dart';
import '../../../shared/utils/message_utils.dart';
import '../../domain/entities/message_entity.dart';
import 'message_actions/message_actions_handler.dart';
import 'message_avatar/message_avatar_widget.dart';
import 'message_content/message_content_widget.dart';

class MessageBubble extends StatelessWidget {
  final MessageEntity message;
  final bool isGroup;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onRetry;
  final Function(String)? onHashtagTap;
  final Function(String)? onMentionTap;

  const MessageBubble({
    super.key,
    required this.message,
    this.isGroup = false,
    this.onTap,
    this.onLongPress,
    this.onRetry,
    this.onHashtagTap,
    this.onMentionTap,
  });

  @override
  Widget build(BuildContext context) {
    final isCurrentUser = message.isCurrentUser;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Row(
        mainAxisAlignment: isCurrentUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isCurrentUser && isGroup) ...[
            MessageAvatarWidget(message: message),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isCurrentUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (!isCurrentUser && isGroup) _buildSenderName(context),
                GestureDetector(
                  onTap: onTap ?? () => _handleMessageTap(context),
                  onLongPress: () => _handleLongPress(context),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                      minWidth: 80,
                    ),
                    padding: _getMessagePadding(),
                    decoration: _buildBubbleDecoration(context, isCurrentUser),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MessageContentWidget(
                          message: message,
                          onHashtagTap: onHashtagTap,
                          onMentionTap: onMentionTap,
                          onRetry: onRetry,
                        ),
                        const SizedBox(height: 4),
                        _buildMessageMetadata(context, isCurrentUser),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isCurrentUser && isGroup) ...[
            const SizedBox(width: 8),
            MessageAvatarWidget(message: message),
          ],
        ],
      ),
    );
  }

  Widget _buildSenderName(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 4),
      child: Text(
        message.senderName,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: _getSenderNameColor(context),
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Color _getSenderNameColor(BuildContext context) {
    final hash = message.senderName.hashCode;
    final colors = [
      Theme.of(context).colorScheme.primary,
      Theme.of(context).colorScheme.secondary,
      Theme.of(context).colorScheme.tertiary,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.indigo,
    ];
    return colors[hash.abs() % colors.length];
  }

  EdgeInsets _getMessagePadding() {
    if (MessageUtils.isMediaMessage(message)) {
      return const EdgeInsets.all(4);
    }
    return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
  }

  BoxDecoration _buildBubbleDecoration(
    BuildContext context,
    bool isCurrentUser,
  ) {
    return BoxDecoration(
      gradient: isCurrentUser
          ? LinearGradient(
              colors: [const Color(0xFF4CAF50), const Color(0xFF45A049)],
            )
          : null,
      color: isCurrentUser
          ? null
          : Theme.of(context).colorScheme.surfaceVariant,
      borderRadius: BorderRadius.only(
        topLeft: const Radius.circular(16),
        topRight: const Radius.circular(16),
        bottomLeft: Radius.circular(isCurrentUser ? 16 : 4),
        bottomRight: Radius.circular(isCurrentUser ? 4 : 16),
      ),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).shadowColor.withOpacity(0.1),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
      ],
    );
  }

  Widget _buildMessageMetadata(BuildContext context, bool isCurrentUser) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          ChatDateUtils.formatMessageTime(message.createdAt),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isCurrentUser
                ? Colors.white.withOpacity(0.7)
                : Theme.of(
                    context,
                  ).colorScheme.onSurfaceVariant.withOpacity(0.7),
            fontSize: 11,
          ),
          textAlign: TextAlign.end,
        ),
        if (isCurrentUser) ...[
          const SizedBox(width: 4),
          Icon(Icons.done_all, size: 14, color: Colors.white.withOpacity(0.7)),
        ],
      ],
    );
  }

  void _handleMessageTap(BuildContext context) {
    MessageActionsHandler.handleMessageTap(
      context: context,
      message: message,
      onRetry: onRetry,
    );
  }

  void _handleLongPress(BuildContext context) {
    if (onLongPress != null) {
      onLongPress!();
      return;
    }
    MessageActionsHandler.showMessageOptions(
      context: context,
      message: message,
    );
  }
}

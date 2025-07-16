import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../shared/utils/date_utils.dart';
import '../../../../shared/utils/message_utils.dart';
import '../../../domain/entities/message_entity.dart';

class MessageActionsHandler {
  static void handleMessageTap({
    required BuildContext context,
    required MessageEntity message,
    VoidCallback? onRetry,
  }) {
    if (MessageUtils.isMediaMessage(message)) {
      if (MessageUtils.isImageMessage(message) ||
          MessageUtils.isVideoMessage(message)) {
        // Open full screen media viewer
        _openFullScreenMedia(context, message);
      } else if (MessageUtils.isAudioMessage(message)) {
        // Voice messages are handled by the VoiceMessageView widget
        // No additional action needed here
      } else if (MessageUtils.isDocumentMessage(message)) {
        _handleDocumentTap(context, message);
      } else {
        _showUnsupportedMediaDialog(context, message);
      }
    } else {
      if (message.content.isNotEmpty) {
        _showTextMessageOptions(context, message);
      }
    }
  }

  static void showMessageOptions({
    required BuildContext context,
    required MessageEntity message,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _buildMessageOptionsSheet(context, message),
    );
  }

  static Widget _buildMessageOptionsSheet(
    BuildContext context,
    MessageEntity message,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // Copy text option (only for text messages)
          if (!MessageUtils.isMediaMessage(message) &&
              message.content.isNotEmpty)
            _buildOptionTile(
              context,
              icon: Icons.copy,
              title: 'Copy text',
              onTap: () {
                Clipboard.setData(ClipboardData(text: message.content));
                Navigator.pop(context);
                _showSuccessSnackBar(context, 'Text copied to clipboard');
              },
            ),

          // Save to gallery (for images and videos)
          if (MessageUtils.isImageMessage(message) ||
              MessageUtils.isVideoMessage(message))
            _buildOptionTile(
              context,
              icon: Icons.save_alt,
              title: 'Save to Gallery',
              onTap: () {
                Navigator.pop(context);
                _saveMediaToGallery(context, message);
              },
            ),

          // Download option (for all media)
          if (MessageUtils.isMediaMessage(message))
            _buildOptionTile(
              context,
              icon: Icons.download,
              title: 'Download',
              onTap: () {
                Navigator.pop(context);
                _downloadMedia(context, message);
              },
            ),

          // Share option
          _buildOptionTile(
            context,
            icon: Icons.share,
            title: 'Share',
            onTap: () {
              Navigator.pop(context);
              _shareMessage(context, message);
            },
          ),

          // Reply option
          _buildOptionTile(
            context,
            icon: Icons.reply,
            title: 'Reply',
            onTap: () {
              Navigator.pop(context);
              // Handle reply functionality
            },
          ),

          // Forward option
          _buildOptionTile(
            context,
            icon: Icons.forward,
            title: 'Forward',
            onTap: () {
              Navigator.pop(context);
              // Handle forward functionality
            },
          ),

          // Delete option (only for current user's messages)
          if (message.isCurrentUser)
            _buildOptionTile(
              context,
              icon: Icons.delete,
              title: 'Delete',
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(context, message);
              },
              isDestructive: true,
            ),

          // Info option
          _buildOptionTile(
            context,
            icon: Icons.info_outline,
            title: 'Info',
            onTap: () {
              Navigator.pop(context);
              _showMessageInfo(context, message);
            },
          ),
        ],
      ),
    );
  }

  static Widget _buildOptionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.onSurface,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).colorScheme.onSurface,
        ),
      ),
      onTap: onTap,
    );
  }

  static void _openFullScreenMedia(
    BuildContext context,
    MessageEntity message,
  ) {
    // Implementation for opening full screen media viewer
    // You can use your existing FullScreenMediaViewer here
  }

  static void _handleDocumentTap(BuildContext context, MessageEntity message) {
    // Implementation for handling document tap
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Document Options',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.download),
                    label: const Text('Download'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Open'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static void _showUnsupportedMediaDialog(
    BuildContext context,
    MessageEntity message,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsupported Media'),
        content: const Text('This media type is not supported for preview.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
          if (message.mediaUrl != null && message.mediaUrl!.isNotEmpty)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Launch URL externally
              },
              child: const Text('Open Externally'),
            ),
        ],
      ),
    );
  }

  static void _showTextMessageOptions(
    BuildContext context,
    MessageEntity message,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                message.content,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      Clipboard.setData(ClipboardData(text: message.content));
                      _showSuccessSnackBar(
                        context,
                        'Message copied to clipboard',
                      );
                    },
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _showMessageInfo(context, message);
                    },
                    icon: const Icon(Icons.info),
                    label: const Text('Info'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static void _saveMediaToGallery(BuildContext context, MessageEntity message) {
    _showSuccessSnackBar(context, 'Saving to gallery...');
    // Implementation for saving media to gallery
  }

  static void _downloadMedia(BuildContext context, MessageEntity message) {
    _showSuccessSnackBar(context, 'Downloading...');
    // Implementation for downloading media
  }

  static void _shareMessage(BuildContext context, MessageEntity message) {
    if (MessageUtils.isMediaMessage(message)) {
      if (message.mediaUrl != null) {
        Share.shareUri(Uri.parse(message.mediaUrl!));
      }
    } else {
      Share.share(message.content);
    }
  }

  static void _showDeleteConfirmation(
    BuildContext context,
    MessageEntity message,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete message'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle delete message
              _showSuccessSnackBar(context, 'Message deleted');
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  static void _showMessageInfo(BuildContext context, MessageEntity message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Message Info'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(context, 'Sender', message.senderName),
            _buildInfoRow(
              context,
              'Sent',
              ChatDateUtils.formatDetailedTimestamp(message.createdAt),
            ),
            if (MessageUtils.isMediaMessage(message))
              _buildInfoRow(context, 'Type', message.mediaType ?? 'Unknown'),
            _buildInfoRow(context, 'Message ID', message.id),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  static Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

  static void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

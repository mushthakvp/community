import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:livera/core/constants/app_constants.dart';
import 'package:voice_message_package/voice_message_package.dart';

import '../../../../shared/utils/message_utils.dart';
import '../../../domain/entities/message_entity.dart';
import '../message_text/message_text_widget.dart';

class MessageMediaWidget extends StatelessWidget {
  final MessageEntity message;
  final VoidCallback? onRetry;

  const MessageMediaWidget({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    if (MessageUtils.isImageMessage(message) ||
        MessageUtils.isVideoMessage(message)) {
      return _buildImageVideoContent(context);
    } else if (MessageUtils.isAudioMessage(message)) {
      return _buildVoiceMessageContent(context);
    } else if (MessageUtils.isDocumentMessage(message)) {
      return _buildDocumentContent(context);
    }

    return _buildUnknownMediaContent(context);
  }

  Widget _buildImageVideoContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {},
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 250, maxHeight: 300),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: message.mediaUrl!,
                    fit: BoxFit.cover,
                    progressIndicatorBuilder:
                        (context, child, loadingProgress) {
                          return Container(
                            width: 200,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.progress,
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        },
                    errorWidget: (context, error, stackTrace) {
                      return Container(
                        width: 200,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.broken_image,
                              size: 48,
                              color: Theme.of(
                                context,
                              ).colorScheme.onErrorContainer,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Failed to load media',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onErrorContainer,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            if (onRetry != null) ...[
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: onRetry,
                                child: const Text('Retry'),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                  if (MessageUtils.isVideoMessage(message))
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.play_circle_filled,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),
                      ),
                    ),
                  // Download/Save button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => _saveMediaToGallery(context),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.download,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (message.content.isNotEmpty) ...[
          const SizedBox(height: 8),
          MessageTextWidget(message: message),
        ],
      ],
    );
  }

  Widget _buildVoiceMessageContent(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 280),
      child: VoiceMessageView(
        backgroundColor: message.isCurrentUser
            ? AppConstants.cardColor
            : Theme.of(context).colorScheme.surface,
        activeSliderColor: message.isCurrentUser
            ? Colors.white
            : Theme.of(context).colorScheme.primary,
        notActiveSliderColor: message.isCurrentUser
            ? Colors.white.withOpacity(0.3)
            : Theme.of(context).colorScheme.outline.withOpacity(0.3),
        circlesColor: message.isCurrentUser
            ? Colors.white
            : Theme.of(context).colorScheme.primary,
        innerPadding: 16,
        cornerRadius: 20,
        size: 35,
        refreshIcon: Icon(
          Icons.refresh,
          color: message.isCurrentUser
              ? Colors.white
              : Theme.of(context).colorScheme.onSurface,
        ),
        playIcon: Icon(
          Icons.play_arrow,
          color: message.isCurrentUser
              ? Colors.white
              : Theme.of(context).colorScheme.onSurface,
          size: 20,
        ),
        pauseIcon: Icon(
          Icons.pause,
          color: message.isCurrentUser
              ? Colors.white
              : Theme.of(context).colorScheme.onSurface,
          size: 20,
        ),
        stopDownloadingIcon: Icon(
          Icons.close,
          color: message.isCurrentUser
              ? Colors.black
              : Theme.of(context).colorScheme.onSurface,
        ),
        playPauseButtonDecoration: BoxDecoration(
          color: message.isCurrentUser
              ? Colors.white.withOpacity(0.2)
              : Theme.of(context).colorScheme.primaryContainer,
          shape: BoxShape.circle,
        ),
        circlesTextStyle: TextStyle(
          color: message.isCurrentUser
              ? Colors.black.withOpacity(0.8)
              : Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
        counterTextStyle: TextStyle(
          color: message.isCurrentUser
              ? Colors.white.withOpacity(0.8)
              : Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
        controller: VoiceController(
          audioSrc: message.mediaUrl ?? "",
          maxDuration: const Duration(minutes: 10),
          isFile: false,
          onComplete: () {
            debugPrint('Voice message completed');
          },
          onPause: () {
            debugPrint('Voice message paused');
          },
          onPlaying: () {
            debugPrint('Voice message playing');
          },
          onError: (err) {
            debugPrint('Voice message error: $err');
          },
        ),
      ),
    );
  }

  Widget _buildDocumentContent(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleDocumentTap(context),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 250),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isCurrentUser
              ? Colors.white.withOpacity(0.1)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getDocumentIcon(),
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getDocumentName(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: message.isCurrentUser
                          ? Colors.white
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _getDocumentType(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: message.isCurrentUser
                          ? Colors.white.withOpacity(0.7)
                          : Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.download,
              size: 20,
              color: message.isCurrentUser
                  ? Colors.white.withOpacity(0.7)
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnknownMediaContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
          const SizedBox(width: 8),
          Text(
            'Unsupported media type',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onErrorContainer,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getDocumentIcon() {
    final extension = message.mediaType?.toLowerCase() ?? '';
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      case 'txt':
        return Icons.text_snippet;
      default:
        return Icons.attach_file;
    }
  }

  String _getDocumentName() {
    if (message.mediaUrl != null) {
      final uri = Uri.tryParse(message.mediaUrl!);
      if (uri != null) {
        final segments = uri.pathSegments;
        if (segments.isNotEmpty) {
          return segments.last;
        }
      }
    }
    return 'Document.${message.mediaType ?? 'file'}';
  }

  String _getDocumentType() {
    final extension = message.mediaType?.toUpperCase() ?? 'FILE';
    return '$extension Document';
  }

  void _saveMediaToGallery(BuildContext context) {
    // Implementation for saving media to gallery
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Saving to gallery...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleDocumentTap(BuildContext context) {
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
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  _getDocumentIcon(),
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getDocumentName(),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getDocumentType(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
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
}

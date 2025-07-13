import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloudinary/cloudinary.dart';
import 'package:fittor/fittor.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../shared/utils/date_utils.dart';
import '../../../shared/utils/message_utils.dart';
import '../../domain/entities/message_entity.dart';
import '../widgets/fullscreen_media_viewer.dart';

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
            _buildAvatar(context),
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
                        _buildMessageContent(context),
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
            _buildAvatar(context),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.primaryContainer,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: message.senderImage != null && message.senderImage!.isNotEmpty
          ? ClipOval(
              child: CachedNetworkImage(
                imageUrl: message.senderImage!,
                width: 32,
                height: 32,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            )
          : _buildDefaultAvatar(context),
    );
  }

  Widget _buildDefaultAvatar(BuildContext context) {
    return Icon(
      Icons.person,
      size: 18,
      color: Theme.of(context).colorScheme.onPrimaryContainer,
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
      color: isCurrentUser
          ? Theme.of(context).colorScheme.primary
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

  Widget _buildMessageContent(BuildContext context) {
    if (MessageUtils.isMediaMessage(message)) {
      return _buildMediaContent(context);
    }
    if (message.content.isEmpty) {
      return const SizedBox.shrink();
    }
    return _buildEnhancedTextContent(context);
  }

  Widget _buildEnhancedTextContent(BuildContext context) {
    final baseTextColor = message.isCurrentUser
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).colorScheme.onSurfaceVariant;

    return FitReadMore(
      message.content,
      trimLength: 500,
      style: Theme.of(
        context,
      ).textTheme.bodyMedium?.copyWith(color: baseTextColor, height: 1.4),
      colorClickableText: baseTextColor.withOpacity(0.7),
      trimMode: TrimMode.line,
      trimLines: 8,
      trimCollapsedText: ' Show more',
      trimExpandedText: ' Show less',
      annotations: [
        FitAnnotation(
          regExp: RegExp(
            r'((https?:\/\/)?(www\.)?[a-zA-Z0-9\-]+\.[a-zA-Z]{2,}(\S*)?)',
            caseSensitive: false,
          ),
          spanBuilder: ({required text, required textStyle}) => TextSpan(
            text: text,
            style: textStyle.copyWith(
              color: message.isCurrentUser
                  ? Colors.lightBlueAccent
                  : Colors.blue,
              decoration: TextDecoration.none,
              fontWeight: FontWeight.w500,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                _handleUrlTap(text);
              },
          ),
        ),
        FitAnnotation(
          regExp: RegExp(r'#\w+'),
          spanBuilder: ({required text, required textStyle}) => TextSpan(
            text: text,
            style: textStyle.copyWith(
              color: message.isCurrentUser
                  ? Colors.cyanAccent
                  : Colors.blueAccent,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                _handleHashtagTap(text);
              },
          ),
        ),
        FitAnnotation(
          regExp: RegExp(r'@\w+'),
          spanBuilder: ({required text, required textStyle}) => TextSpan(
            text: text,
            style: textStyle.copyWith(
              color: message.isCurrentUser
                  ? Colors.purpleAccent
                  : Colors.purple,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                _handleMentionTap(text);
              },
          ),
        ),
        FitAnnotation(
          regExp: RegExp(
            r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b',
          ),
          spanBuilder: ({required text, required textStyle}) => TextSpan(
            text: text,
            style: textStyle.copyWith(
              color: message.isCurrentUser
                  ? Colors.lightBlueAccent
                  : Colors.blue,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                _handleEmailTap(text);
              },
          ),
        ),
        FitAnnotation(
          regExp: RegExp(
            r'(?:(?:\+|00)[1-9]{1,4})?[\s\-.\(]?\(?\d{1,4}\)?[\s\-.\)]{0,2}\d{1,4}[\s\-.\)]{0,2}\d{1,9}',
          ),
          spanBuilder: ({required text, required textStyle}) => TextSpan(
            text: text,
            style: textStyle.copyWith(
              color: message.isCurrentUser ? Colors.greenAccent : Colors.green,
              fontWeight: FontWeight.w500,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                _handlePhoneTap(text);
              },
          ),
        ),
      ],
    );
  }

  Future<void> _handleUrlTap(String url) async {
    try {
      String finalUrl = url;
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        finalUrl = 'https://$url';
      }

      final uri = Uri.parse(finalUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showErrorSnackBar('Could not open URL: $url');
      }
    } catch (e) {
      _showErrorSnackBar('Error opening URL: $e');
    }
  }

  void _handleHashtagTap(String hashtag) {
    if (onHashtagTap != null) {
      onHashtagTap!(hashtag);
    } else {
      _showHashtagBottomSheet(hashtag);
    }
  }

  void _handleMentionTap(String mention) {
    if (onMentionTap != null) {
      onMentionTap!(mention);
    } else {
      _showMentionBottomSheet(mention);
    }
  }

  Future<void> _handleEmailTap(String email) async {
    try {
      final uri = Uri.parse('mailto:$email');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        await Clipboard.setData(ClipboardData(text: email));
        _showSuccessSnackBar('Email copied to clipboard');
      }
    } catch (e) {
      _showErrorSnackBar('Error handling email: $e');
    }
  }

  Future<void> _handlePhoneTap(String phone) async {
    try {
      final cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
      final uri = Uri.parse('tel:$cleanPhone');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        await Clipboard.setData(ClipboardData(text: phone));
        _showSuccessSnackBar('Phone number copied to clipboard');
      }
    } catch (e) {
      _showErrorSnackBar('Error handling phone: $e');
    }
  }

  void _showHashtagBottomSheet(String hashtag) {
    final context = navigatorKey.currentContext!;
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
                  Icons.tag,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  hashtag,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _copyToClipboard(hashtag);
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
                      _navigateToHashtagSearch(hashtag);
                    },
                    icon: const Icon(Icons.search),
                    label: const Text('Search'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showMentionBottomSheet(String mention) {
    final context = navigatorKey.currentContext!;
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
                  Icons.person,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  mention,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _copyToClipboard(mention);
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
                      _navigateToUserProfile(mention);
                    },
                    icon: const Icon(Icons.person_search),
                    label: const Text('Profile'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    _showSuccessSnackBar('Copied to clipboard');
  }

  void _navigateToHashtagSearch(String hashtag) {
    debugPrint('Navigating to hashtag search: $hashtag');
  }

  void _navigateToUserProfile(String mention) {
    debugPrint('Navigating to user profile: $mention');
  }

  void _showSuccessSnackBar(String message) {
    if (navigatorKey.currentContext != null) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showErrorSnackBar(String message) {
    if (navigatorKey.currentContext != null) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  Widget _buildMediaContent(BuildContext context) {
    if (MessageUtils.isImageMessage(message) ||
        MessageUtils.isVideoMessage(message)) {
      return _buildImageVideoContent(context);
    } else if (MessageUtils.isAudioMessage(message)) {
      return _buildAudioContent(context);
    } else if (MessageUtils.isDocumentMessage(message)) {
      return _buildDocumentContent(context);
    }

    return _buildUnknownMediaContent(context);
  }

  Widget _buildImageVideoContent(BuildContext context) {
    final heroTag =
        'media_${message.id}_${message.createdAt.millisecondsSinceEpoch}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _openFullScreenMedia(context, heroTag),
          child: Hero(
            tag: heroTag,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 250,
                  maxHeight: 300,
                ),
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
        ),
        if (message.content.isNotEmpty) ...[
          const SizedBox(height: 8),
          _buildEnhancedTextContent(context),
        ],
      ],
    );
  }

  Widget _buildAudioContent(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleAudioTap(context),
      child: Container(
        width: 250,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isCurrentUser
              ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.1)
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
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_arrow,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Voice message',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: message.isCurrentUser
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    height: 2,
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(1),
                    ),
                    child: LinearProgressIndicator(
                      value: 0.0,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '0:30',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: message.isCurrentUser
                    ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.7)
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
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
              ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.1)
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
                          ? Theme.of(context).colorScheme.onPrimary
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
                          ? Theme.of(
                              context,
                            ).colorScheme.onPrimary.withOpacity(0.7)
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
                  ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.7)
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

  Widget _buildMessageMetadata(BuildContext context, bool isCurrentUser) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          ChatDateUtils.formatMessageTime(message.createdAt),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isCurrentUser
                ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.7)
                : Theme.of(
                    context,
                  ).colorScheme.onSurfaceVariant.withOpacity(0.7),
            fontSize: 11,
          ),
          textAlign: TextAlign.end,
        ),
        if (isCurrentUser) ...[
          const SizedBox(width: 4),
          Icon(
            _getMessageStatusIcon(),
            size: 14,
            color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
          ),
        ],
      ],
    );
  }

  IconData _getMessageStatusIcon() {
    return Icons.done_all;
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

  void _handleMessageTap(BuildContext context) {
    if (MessageUtils.isMediaMessage(message)) {
      if (MessageUtils.isImageMessage(message) ||
          MessageUtils.isVideoMessage(message)) {
        final heroTag =
            'media_${message.id}_${message.createdAt.millisecondsSinceEpoch}';
        _openFullScreenMedia(context, heroTag);
      } else if (MessageUtils.isAudioMessage(message)) {
        _handleAudioTap(context);
      } else if (MessageUtils.isDocumentMessage(message)) {
        _handleDocumentTap(context);
      } else {
        _showUnsupportedMediaDialog(context);
      }
    } else {
      if (message.content.isNotEmpty) {
        _showTextMessageOptions(context);
      }
    }
  }

  void _handleLongPress(BuildContext context) {
    if (onLongPress != null) {
      onLongPress!();
      return;
    }
    _showMessageOptions(context);
  }

  void _openFullScreenMedia(BuildContext context, String heroTag) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            FullScreenMediaViewer(message: message, heroTag: heroTag),
      ),
    );
  }

  // Save media to gallery
  Future<void> _saveMediaToGallery(BuildContext context) async {
    if (message.mediaUrl == null || message.mediaUrl!.isEmpty) {
      _showErrorSnackBar('Media URL not available');
      return;
    }
    try {
      _showLoadingSnackBar('Saving to gallery...');
      final success = await _downloadAndSaveMedia();
      if (success) {
        _showSuccessSnackBar('Saved to gallery successfully');
      } else {
        _showErrorSnackBar('Failed to save media');
      }
    } catch (e) {
      _showErrorSnackBar('Error saving media: $e');
    }
  }

  Future<bool> _downloadAndSaveMedia() async {
    try {
      final dio = Dio();
      final tempDir = await getTemporaryDirectory();
      final fileName = _getFileName();
      final filePath = '${tempDir.path}/$fileName';
      await dio.download(message.mediaUrl!, filePath);
      if (MessageUtils.isImageMessage(message)) {
        return await GallerySaver.saveImage(filePath) ?? false;
      } else if (MessageUtils.isVideoMessage(message)) {
        return await GallerySaver.saveVideo(filePath) ?? false;
      } else {
        return await _saveToDownloads(filePath, fileName);
      }
    } catch (e) {
      debugPrint('Error downloading media: $e');
      return false;
    }
  }

  Future<bool> _saveToDownloads(String filePath, String fileName) async {
    try {
      final downloadsDir = await getExternalStorageDirectory();
      if (downloadsDir != null) {
        final downloadPath = '${downloadsDir.path}/Download/$fileName';
        final file = File(filePath);
        await file.copy(downloadPath);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error saving to downloads: $e');
      return false;
    }
  }

  String _getFileName() {
    if (message.mediaUrl != null) {
      final uri = Uri.tryParse(message.mediaUrl!);
      if (uri != null) {
        final segments = uri.pathSegments;
        if (segments.isNotEmpty) {
          return segments.last;
        }
      }
    }
    final extension = message.mediaType ?? 'file';
    final timestamp = message.createdAt.millisecondsSinceEpoch;
    return 'media_$timestamp.$extension';
  }

  void _showLoadingSnackBar(String message) {
    if (navigatorKey.currentContext != null) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 12),
              Text(message),
            ],
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // Document handling
  void _handleDocumentTap(BuildContext context) {
    if (message.mediaUrl == null || message.mediaUrl!.isEmpty) {
      _showErrorSnackBar('Document URL not available');
      return;
    }

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
                    onPressed: () => _downloadDocument(context),
                    icon: const Icon(Icons.download),
                    label: const Text('Download'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _openDocument(context),
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Open'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _shareDocument(context),
                icon: const Icon(Icons.share),
                label: const Text('Share'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.secondaryContainer,
                  foregroundColor: Theme.of(
                    context,
                  ).colorScheme.onSecondaryContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Audio handling
  void _handleAudioTap(BuildContext context) {
    if (message.mediaUrl == null || message.mediaUrl!.isEmpty) {
      _showErrorSnackBar('Audio URL not available');
      return;
    }

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
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.volume_up,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Voice Message',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'From ${message.senderName}',
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () => _playAudio(context),
                  icon: const Icon(Icons.play_arrow),
                  iconSize: 32,
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                IconButton(
                  onPressed: () => _downloadAudio(context),
                  icon: const Icon(Icons.download),
                  iconSize: 24,
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.secondaryContainer,
                    foregroundColor: Theme.of(
                      context,
                    ).colorScheme.onSecondaryContainer,
                  ),
                ),
                IconButton(
                  onPressed: () => _shareAudio(context),
                  icon: const Icon(Icons.share),
                  iconSize: 24,
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.tertiaryContainer,
                    foregroundColor: Theme.of(
                      context,
                    ).colorScheme.onTertiaryContainer,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadDocument(BuildContext context) async {
    Navigator.pop(context);
    try {
      _showLoadingSnackBar('Downloading ${_getDocumentName()}...');

      final dio = Dio();
      final tempDir = await getTemporaryDirectory();
      final fileName = _getDocumentName();
      final filePath = '${tempDir.path}/$fileName';

      await dio.download(message.mediaUrl!, filePath);

      // Save to downloads folder
      await _saveToDownloads(filePath, fileName);

      _showSuccessSnackBar('Document downloaded successfully');
    } catch (e) {
      _showErrorSnackBar('Failed to download document: $e');
    }
  }

  Future<void> _openDocument(BuildContext context) async {
    Navigator.pop(context);
    try {
      await _launchUrl(message.mediaUrl!);
    } catch (e) {
      _showErrorSnackBar('Failed to open document: $e');
    }
  }

  Future<void> _shareDocument(BuildContext context) async {
    Navigator.pop(context);
    try {
      await Share.shareUri(Uri.parse(message.mediaUrl!));
    } catch (e) {
      _showErrorSnackBar('Failed to share document: $e');
    }
  }

  Future<void> _playAudio(BuildContext context) async {
    Navigator.pop(context);
    try {
      _showSuccessSnackBar('Playing voice message...');
      await _launchUrl(message.mediaUrl!);
    } catch (e) {
      _showErrorSnackBar('Failed to play audio: $e');
    }
  }

  Future<void> _downloadAudio(BuildContext context) async {
    Navigator.pop(context);
    try {
      _showLoadingSnackBar('Downloading voice message...');

      final dio = Dio();
      final tempDir = await getTemporaryDirectory();
      final fileName =
          'voice_${message.createdAt.millisecondsSinceEpoch}.${message.mediaType ?? 'm4a'}';
      final filePath = '${tempDir.path}/$fileName';

      await dio.download(message.mediaUrl!, filePath);
      await _saveToDownloads(filePath, fileName);

      _showSuccessSnackBar('Voice message downloaded successfully');
    } catch (e) {
      _showErrorSnackBar('Failed to download audio: $e');
    }
  }

  Future<void> _shareAudio(BuildContext context) async {
    Navigator.pop(context);
    try {
      await Share.shareUri(Uri.parse(message.mediaUrl!));
    } catch (e) {
      _showErrorSnackBar('Failed to share audio: $e');
    }
  }

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      throw 'Error launching URL: $e';
    }
  }

  void _showUnsupportedMediaDialog(BuildContext context) {
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
                _launchUrl(message.mediaUrl!);
              },
              child: const Text('Open Externally'),
            ),
        ],
      ),
    );
  }

  void _showTextMessageOptions(BuildContext context) {
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
                      _showSuccessSnackBar('Message copied to clipboard');
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
                      _showMessageInfo(context);
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

  void _showMessageOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _buildMessageOptionsSheet(context),
    );
  }

  Widget _buildMessageOptionsSheet(BuildContext context) {
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
                _showSuccessSnackBar('Text copied to clipboard');
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
                _saveMediaToGallery(context);
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
                if (MessageUtils.isDocumentMessage(message)) {
                  _downloadDocument(context);
                } else if (MessageUtils.isAudioMessage(message)) {
                  _downloadAudio(context);
                } else {
                  _saveMediaToGallery(context);
                }
              },
            ),

          // Share option
          _buildOptionTile(
            context,
            icon: Icons.share,
            title: 'Share',
            onTap: () {
              Navigator.pop(context);
              if (MessageUtils.isMediaMessage(message)) {
                if (MessageUtils.isDocumentMessage(message)) {
                  _shareDocument(context);
                } else if (MessageUtils.isAudioMessage(message)) {
                  _shareAudio(context);
                } else {
                  Share.shareUri(Uri.parse(message.mediaUrl!));
                }
              } else {
                Share.share(message.content);
              }
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
                _showDeleteConfirmation(context);
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
              _showMessageInfo(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile(
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

  void _showDeleteConfirmation(BuildContext context) {
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

  void _showMessageInfo(BuildContext context) {
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

  Widget _buildInfoRow(BuildContext context, String label, String value) {
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
}

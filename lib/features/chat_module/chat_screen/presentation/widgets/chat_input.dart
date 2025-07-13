import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/chat_provider.dart';

class ChatInput extends StatefulWidget {
  final String chatId;
  final bool isBotChat;

  const ChatInput({super.key, required this.chatId, this.isBotChat = false});

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> with TickerProviderStateMixin {
  bool _isTyping = false;
  late AnimationController _recordingAnimationController;
  late Animation<double> _recordingAnimation;

  @override
  void initState() {
    super.initState();
    _recordingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _recordingAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: _recordingAnimationController,
        curve: Curves.elasticInOut,
      ),
    );
  }

  @override
  void dispose() {
    _recordingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, provider, _) {
        final inputType = _determineInputType(provider);
        switch (inputType) {
          case ChatInputType.hidden:
            return const SizedBox.shrink();
          case ChatInputType.requestSent:
            return _buildRequestSentWidget(context);
          case ChatInputType.joinRequest:
            return _buildJoinRequestWidget(context, provider);
          case ChatInputType.normal:
            return _buildNormalChatInput(context, provider);
        }
      },
    );
  }

  ChatInputType _determineInputType(ChatProvider provider) {
    final chat = provider.currentChat;

    if (chat == null || chat.isBot) return ChatInputType.hidden;

    if (chat.isCreator || chat.isUserInGroup) {
      return ChatInputType.normal;
    }

    if (chat.isUserRequested && !chat.isUserInGroup) {
      return ChatInputType.requestSent;
    }

    if (!chat.isUserInGroup) {
      return ChatInputType.joinRequest;
    }

    return ChatInputType.normal;
  }

  Widget _buildRequestSentWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Icon(Icons.pending, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Request Sent',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Waiting for approval to join this group',
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
      ),
    );
  }

  Widget _buildJoinRequestWidget(BuildContext context, ChatProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    provider.currentChat?.isBot == true
                        ? 'Bot Channel'
                        : 'Join Group',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    provider.currentChat?.isBot == true
                        ? 'Request to join this bot channel'
                        : 'Request to join this group to start chatting',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: provider.isLoading
                  ? null
                  : () => _handleJoinRequest(context, provider),
              icon: provider.isLoading
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    )
                  : Icon(
                      provider.currentChat?.isBot == true
                          ? Icons.smart_toy
                          : Icons.group_add,
                    ),
              label: Text(
                provider.currentChat?.isBot == true ? 'Join Bot' : 'Join Group',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNormalChatInput(BuildContext context, ChatProvider provider) {
    if (provider.isRecording && !_recordingAnimationController.isAnimating) {
      _recordingAnimationController.repeat(reverse: true);
    } else if (!provider.isRecording &&
        _recordingAnimationController.isAnimating) {
      _recordingAnimationController.stop();
      _recordingAnimationController.reset();
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surface.withOpacity(0.95),
          ],
        ),
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            if (provider.isRecording)
              _buildRecordingIndicator(context, provider),
            Row(
              children: [
                if (!provider.isRecording)
                  _buildAttachmentButton(context, provider),
                const SizedBox(width: 8),
                Expanded(
                  child: provider.isRecording
                      ? _buildRecordingContainer(context, provider)
                      : _buildTextInput(context, provider),
                ),
                const SizedBox(width: 8),
                _buildActionButton(context, provider),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordingIndicator(BuildContext context, ChatProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.withOpacity(0.1), Colors.red.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _recordingAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _recordingAnimation.value,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 12),
          Icon(Icons.mic, color: Colors.red, size: 18),
          const SizedBox(width: 8),
          Text(
            'Recording ${_formatDuration(provider.recordingDuration)}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentButton(BuildContext context, ChatProvider provider) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.8),
            Theme.of(context).colorScheme.primary,
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: () => _showAttachmentOptions(context, provider),
        icon: const Icon(Icons.add),
        style: IconButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          padding: const EdgeInsets.all(12),
        ),
      ),
    );
  }

  Widget _buildTextInput(BuildContext context, ChatProvider provider) {
    return Container(
      constraints: const BoxConstraints(minHeight: 48, maxHeight: 120),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        controller: provider.messageController,
        focusNode: provider.focusNode,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        textCapitalization: TextCapitalization.sentences,
        textInputAction: TextInputAction.newline,
        decoration: InputDecoration(
          hintText: 'Type a message...',
          hintStyle: TextStyle(
            color: Theme.of(
              context,
            ).colorScheme.onSurfaceVariant.withOpacity(0.6),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
        ),
        style: Theme.of(context).textTheme.bodyMedium,
        onChanged: (value) {
          setState(() {
            _isTyping = value.trim().isNotEmpty;
          });
        },
        onSubmitted: (_) {
          if (_isTyping) {
            provider.sendTextMessage(widget.chatId);
            setState(() {
              _isTyping = false;
            });
          }
        },
      ),
    );
  }

  Widget _buildRecordingContainer(BuildContext context, ChatProvider provider) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.withOpacity(0.1), Colors.red.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 20),
          AnimatedBuilder(
            animation: _recordingAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _recordingAnimation.value,
                child: Icon(Icons.mic, color: Colors.red, size: 24),
              );
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Recording voice message...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _formatDuration(provider.recordingDuration),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.w600,
                fontFeatures: [const FontFeature.tabularFigures()],
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, ChatProvider provider) {
    if (provider.isRecording) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: IconButton(
              onPressed: provider.cancelRecording,
              icon: const Icon(Icons.close),
              style: IconButton.styleFrom(
                foregroundColor: Colors.red,
                padding: const EdgeInsets.all(12),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade400, Colors.green.shade600],
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () => provider.stopRecording(widget.chatId),
              icon: const Icon(Icons.send),
              style: IconButton.styleFrom(
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(12),
              ),
            ),
          ),
        ],
      );
    }

    if (provider.isSending || provider.isUploading) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isTyping
              ? [const Color(0xFF4CAF50), const Color(0xFF45A049)]
              : [
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.secondary.withOpacity(0.8),
                ],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color:
                (_isTyping
                        ? Colors.green
                        : Theme.of(context).colorScheme.secondary)
                    .withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: _isTyping
            ? () {
                provider.sendTextMessage(widget.chatId);
                setState(() {
                  _isTyping = false;
                });
              }
            : () => provider.startRecording(),
        icon: Icon(_isTyping ? Icons.send : Icons.mic),
        style: IconButton.styleFrom(
          foregroundColor: Colors.white,
          padding: const EdgeInsets.all(12),
        ),
      ),
    );
  }

  void _showAttachmentOptions(BuildContext context, ChatProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
            const SizedBox(height: 24),
            Text(
              'Share Media',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAttachmentOption(
                  context,
                  icon: Icons.photo_camera,
                  label: 'Camera',
                  color: Colors.pink,
                  onTap: () {
                    Navigator.pop(context);
                    provider.pickImage(widget.chatId, fromCamera: true);
                  },
                ),
                _buildAttachmentOption(
                  context,
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  color: Colors.purple,
                  onTap: () {
                    Navigator.pop(context);
                    provider.pickImage(widget.chatId);
                  },
                ),
                _buildAttachmentOption(
                  context,
                  icon: Icons.attach_file,
                  label: 'Document',
                  color: Colors.blue,
                  onTap: () {
                    Navigator.pop(context);
                    provider.pickFile(widget.chatId);
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [color.withOpacity(0.8), color]),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, size: 32, color: Colors.white),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _handleJoinRequest(BuildContext context, ChatProvider provider) {
    provider.joinGroupOrBot(widget.chatId);
  }
}

enum ChatInputType { hidden, requestSent, joinRequest, normal }

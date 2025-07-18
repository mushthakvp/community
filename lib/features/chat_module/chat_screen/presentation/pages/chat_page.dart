import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../shared/utils/message_utils.dart';
import '../../domain/entities/message_entity.dart';
import '../providers/chat_provider.dart';
import '../widgets/chat_appbar.dart';
import '../widgets/chat_input.dart';
import '../widgets/fullscreen_media_viewer.dart';
import '../widgets/message_bubble.dart';

class ChatPage extends StatefulWidget {
  final String chatId;
  final String chatName;
  final String? chatImage;
  final bool isGroup;
  final bool isPersonal;
  final ChatType? chatType;

  const ChatPage({
    super.key,
    required this.chatId,
    required this.chatName,
    this.chatImage,
    this.isGroup = false,
    this.isPersonal = false,
    this.chatType,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  bool isAppInForeground = true;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeChat();
  }

  void _initializeChat() {
    if (!_isInitialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final provider = context.read<ChatProvider>();
        provider.setLoading(true);

        // Determine chat type
        ChatType chatType =
            widget.chatType ??
            (widget.isPersonal
                ? ChatType.personal
                : widget.isGroup
                ? ChatType.group
                : ChatType.group);

        provider.initializeChat(widget.chatId, chatType: chatType).then((_) {
          if (mounted) {
            setState(() {
              _isInitialized = true;
            });
          }
        });
      });
    }
  }

  @override
  void didUpdateWidget(ChatPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.chatId != widget.chatId ||
        oldWidget.isPersonal != widget.isPersonal ||
        oldWidget.chatType != widget.chatType) {
      _isInitialized = false;
      _initializeChat();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        isAppInForeground = true;
        _handleAppResumed();
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        isAppInForeground = false;
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        isAppInForeground = true;
        _handleAppResumed();
        break;
    }
  }

  void _handleAppResumed() {
    final provider = context.read<ChatProvider>();
    if (!provider.isSocketConnected &&
        provider.currentChatId == widget.chatId) {
      provider.reconnectAndRejoin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          final provider = context.read<ChatProvider>();
          provider.clearError();
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Consumer<ChatProvider>(
          builder: (context, provider, _) {
            if (!_isInitialized && provider.isLoading) {
              return _buildOptimizedLoadingState(context, provider);
            }
            final chatName = _getChatName(provider);
            final chatImage = _getChatImage(provider);
            final isBotChat = provider.isBotChat;
            final isPersonalChat = provider.isPersonalChat;

            return Column(
              children: [
                ChatAppBar(
                  chatName: chatName,
                  chatImage: chatImage,
                  isGroup: widget.isGroup && !isPersonalChat,
                  isBotChat: isBotChat,
                  chatId: widget.chatId,
                  onBackPressed: () => context.pop(),
                  onMenuPressed: () => _showChatMenu(context, provider),
                ),
                _buildConnectionStatus(provider),
                if (isBotChat) _buildBotChatBanner(context),
                if (isPersonalChat) _buildPersonalChatBanner(context, provider),
                Expanded(
                  child: _buildMessagesArea(context, provider, isBotChat),
                ),
                ChatInput(chatId: widget.chatId, isBotChat: isBotChat),
              ],
            );
          },
        ),
      ),
    );
  }

  String _getChatName(ChatProvider provider) {
    // Use provider's method to get the appropriate display name
    final displayName = provider.getChatDisplayName();
    return displayName.isNotEmpty ? displayName : widget.chatName;
  }

  String? _getChatImage(ChatProvider provider) {
    // Use provider's method to get the appropriate display image
    return provider.getChatDisplayImage() ?? widget.chatImage;
  }

  Widget _buildOptimizedLoadingState(
    BuildContext context,
    ChatProvider provider,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          ChatAppBar(
            chatName: widget.chatName,
            chatImage: widget.chatImage,
            isGroup: widget.isGroup,
            isBotChat: false,
            onBackPressed: () => context.pop(),
            onMenuPressed: () {},
            chatId: widget.chatId,
          ),
          Expanded(child: _buildLoadingMessages(context)),
          ChatInput(chatId: widget.chatId, isBotChat: false),
        ],
      ),
    );
  }

  Widget _buildLoadingMessages(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Loading messages...',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionStatus(ChatProvider provider) {
    if (provider.isConnecting) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1),
          border: Border(
            bottom: BorderSide(color: Colors.orange.withOpacity(0.3)),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Connecting...',
              style: TextStyle(
                color: Colors.orange,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (!provider.isSocketConnected) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          border: Border(
            bottom: BorderSide(color: Colors.red.withOpacity(0.3)),
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.cloud_off, color: Colors.red, size: 16),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Connection lost. Messages may not update.',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () => provider.reconnectAndRejoin(),
              child: const Text(
                'Reconnect',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildPersonalChatBanner(BuildContext context, ChatProvider provider) {
    final isOnline = provider.isPersonalChatOnline();
    final friendName = provider.getChatDisplayName();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.person,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Personal chat with $friendName',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isOnline ? Colors.green : Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            isOnline ? 'Online' : 'Offline',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onPrimaryContainer.withOpacity(0.7),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBotChatBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.7),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.smart_toy,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'This is an automated bot. You can only view messages.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Icon(
            Icons.info_outline,
            color: Theme.of(
              context,
            ).colorScheme.onPrimaryContainer.withOpacity(0.7),
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesArea(
    BuildContext context,
    ChatProvider provider,
    bool isBotChat,
  ) {
    if (provider.error != null && provider.messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                provider.error!,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              children: [
                ElevatedButton(
                  onPressed: () => provider.initializeChat(widget.chatId),
                  child: const Text('Retry'),
                ),
                if (!provider.isSocketConnected)
                  ElevatedButton(
                    onPressed: () => provider.reconnectAndRejoin(),
                    child: const Text('Reconnect'),
                  ),
              ],
            ),
          ],
        ),
      );
    }

    if (provider.messages.isEmpty && !provider.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getEmptyStateIcon(provider.currentChatType),
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              _getEmptyStateTitle(provider.currentChatType),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _getEmptyStateSubtitle(provider.currentChatType),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.5),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    final groupedMessages = MessageUtils.groupMessagesByDate(provider.messages);
    return RefreshIndicator(
      onRefresh: () async {
        await provider.refreshChat(widget.chatId);
      },
      child: ListView.builder(
        controller: provider.scrollController,
        padding: const EdgeInsets.only(top: 8, bottom: 30),
        itemCount: groupedMessages.length,
        itemBuilder: (context, index) {
          final group = groupedMessages[index];

          return Column(
            children: [
              // Date separator
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  MessageUtils.formatDateHeader(group.date),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              // Messages in this date group
              ...group.messages.map(
                (message) => MessageBubble(
                  message: message,
                  isGroup: widget.isGroup && !provider.isPersonalChat,
                  onTap: () => _handleMessageTap(context, message),
                  onLongPress: () => _handleMessageLongPress(context, message),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  IconData _getEmptyStateIcon(ChatType chatType) {
    switch (chatType) {
      case ChatType.personal:
        return Icons.chat_bubble_outline;
      case ChatType.bot:
        return Icons.smart_toy;
      case ChatType.group:
        return Icons.groups_outlined;
    }
  }

  String _getEmptyStateTitle(ChatType chatType) {
    switch (chatType) {
      case ChatType.personal:
        return 'No messages yet';
      case ChatType.bot:
        return 'No messages from this bot yet';
      case ChatType.group:
        return 'No messages yet';
    }
  }

  String _getEmptyStateSubtitle(ChatType chatType) {
    switch (chatType) {
      case ChatType.personal:
        return 'Start a conversation with your friend!';
      case ChatType.bot:
        return 'This bot will send you messages here';
      case ChatType.group:
        return 'Start a conversation with the group!';
    }
  }

  void _handleMessageTap(BuildContext context, MessageEntity message) {
    if (message.mediaUrl != null && message.mediaUrl!.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FullScreenMediaViewer(
            message: message,
            heroTag: 'message_${message.id}',
          ),
        ),
      );
    }
  }

  void _handleMessageLongPress(BuildContext context, MessageEntity message) {
    // Show message options
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _buildMessageOptionsSheet(context, message),
    );
  }

  Widget _buildMessageOptionsSheet(
    BuildContext context,
    MessageEntity message,
  ) {
    final provider = context.read<ChatProvider>();

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
          if (message.content.isNotEmpty && message.mediaUrl == null)
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copy text'),
              onTap: () {
                Navigator.pop(context);
                Clipboard.setData(ClipboardData(text: message.content));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Message copied to clipboard')),
                );
              },
            ),

          // Reply option
          ListTile(
            leading: const Icon(Icons.reply),
            title: const Text('Reply'),
            onTap: () {
              Navigator.pop(context);
            },
          ),

          // Forward option
          ListTile(
            leading: const Icon(Icons.forward),
            title: const Text('Forward'),
            onTap: () {
              Navigator.pop(context);
            },
          ),

          if (message.mediaUrl != null && message.mediaUrl!.isNotEmpty)
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Save'),
              onTap: () {
                Navigator.pop(context);
              },
            ),

          // Delete option (only for current user's messages)
          if (message.isCurrentUser)
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(context, message, provider);
              },
            ),

          // Info option
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Info'),
            onTap: () {
              Navigator.pop(context);
              _showMessageInfo(context, message);
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    MessageEntity message,
    ChatProvider provider,
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
              provider.deleteMessage(message.id);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Message deleted')));
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

  void _showMessageInfo(BuildContext context, MessageEntity message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Message Info'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Sender', message.senderName),
            _buildInfoRow('Sent', _formatDetailedTimestamp(message.createdAt)),
            if (message.mediaType != null)
              _buildInfoRow('Type', message.mediaType!.toUpperCase()),
            _buildInfoRow('Message ID', message.id),
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _formatDetailedTimestamp(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return 'Today at ${_formatTime(dateTime)}';
    } else if (difference.inDays == 1) {
      return 'Yesterday at ${_formatTime(dateTime)}';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${_formatTime(dateTime)}';
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }

  void _showChatMenu(BuildContext context, ChatProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
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

            if (provider.isPersonalChat) ...[
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('View Profile'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.call),
                title: const Text('Voice Call'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.videocam),
                title: const Text('Video Call'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.block, color: Colors.red),
                title: const Text(
                  'Block User',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showBlockUserConfirmation(context);
                },
              ),
            ],

            if (provider.isGroupChat) ...[
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('Group Info'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.people),
                title: const Text('View Members'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              if (provider.currentChat?.isCreator == true)
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Group Settings'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ListTile(
                leading: const Icon(Icons.exit_to_app, color: Colors.red),
                title: const Text(
                  'Leave Group',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showLeaveGroupConfirmation(context);
                },
              ),
            ],
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Search Messages'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.wallpaper),
              title: const Text('Change Wallpaper'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifications'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showBlockUserConfirmation(BuildContext context) {
    final provider = context.read<ChatProvider>();
    final userName = provider.getChatDisplayName();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Block User'),
        content: Text('Are you sure you want to block $userName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$userName has been blocked')),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Block'),
          ),
        ],
      ),
    );
  }

  void _showLeaveGroupConfirmation(BuildContext context) {
    final provider = context.read<ChatProvider>();
    final groupName = provider.getChatDisplayName();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Group'),
        content: Text('Are you sure you want to leave $groupName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Left $groupName')));
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }
}

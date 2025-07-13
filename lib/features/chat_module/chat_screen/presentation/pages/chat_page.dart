import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../shared/utils/message_utils.dart';
import '../providers/chat_provider.dart';
import '../widgets/chat_appbar.dart';
import '../widgets/chat_input.dart';
import '../widgets/message_bubble.dart';

class ChatPage extends StatefulWidget {
  final String chatId;
  final String chatName;
  final String? chatImage;
  final bool isGroup;

  const ChatPage({
    super.key,
    required this.chatId,
    required this.chatName,
    this.chatImage,
    this.isGroup = false,
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

        // Only initialize if we're switching to a different chat or not initialized
        if (provider.currentChatId != widget.chatId) {
          debugPrint('Initializing chat: ${widget.chatId}');
          provider.initializeChat(widget.chatId).then((_) {
            if (mounted) {
              setState(() {
                _isInitialized = true;
              });
            }
          });
        } else {
          setState(() {
            _isInitialized = true;
          });
        }
      });
    }
  }

  @override
  void didUpdateWidget(ChatPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If the chat ID changed, reinitialize
    if (oldWidget.chatId != widget.chatId) {
      debugPrint(
        'Chat ID changed from ${oldWidget.chatId} to ${widget.chatId}',
      );
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
      debugPrint('App resumed, reconnecting socket...');
      provider.reconnectAndRejoin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          // Clear any temporary state when leaving chat
          final provider = context.read<ChatProvider>();
          provider.clearError();
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Consumer<ChatProvider>(
          builder: (context, provider, _) {
            // Show loading only if we have no cached data and are loading
            if (!_isInitialized &&
                provider.isLoading &&
                provider.messages.isEmpty) {
              return _buildLoadingState(context);
            }

            // Get chat info - prioritize from provider, fallback to widget params
            final isBotChat = provider.isBotChat;
            final chatName = provider.currentChat?.users.isNotEmpty == true
                ? provider.currentChat!.users.first.name
                : widget.chatName;
            final chatImage = provider.currentChat?.users.isNotEmpty == true
                ? provider.currentChat!.users.first.profileImage
                : widget.chatImage;

            return Column(
              children: [
                ChatAppBar(
                  chatName: chatName,
                  chatImage: chatImage,
                  isGroup: widget.isGroup,
                  isBotChat: isBotChat,
                  onBackPressed: () => context.pop(),
                  onMenuPressed: () {},
                ),

                // Connection status indicator
                _buildConnectionStatus(provider),

                if (isBotChat) _buildBotChatBanner(context),

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

  Widget _buildLoadingState(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(widget.chatName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading chat...'),
          ],
        ),
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

    // Connected state - no indicator needed
    return const SizedBox.shrink();
  }

  Widget _buildMessagesArea(
    BuildContext context,
    ChatProvider provider,
    bool isBotChat,
  ) {
    // Show error only if we have no messages and there's an error
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
            Text(
              provider.error!,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => provider.initializeChat(widget.chatId),
                  child: const Text('Retry'),
                ),
                const SizedBox(width: 16),
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
              isBotChat ? Icons.smart_toy : Icons.chat_bubble_outline,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              isBotChat ? 'No messages from this bot yet' : 'No messages yet',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isBotChat
                  ? 'This bot will send you messages here'
                  : 'Start a conversation!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
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
              ...group.messages.map(
                (message) =>
                    MessageBubble(message: message, isGroup: widget.isGroup),
              ),
            ],
          );
        },
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
}

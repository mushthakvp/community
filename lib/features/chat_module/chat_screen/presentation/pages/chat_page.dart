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

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().initializeChat(widget.chatId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Consumer<ChatProvider>(
        builder: (context, provider, _) {
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
              if (isBotChat) _buildBotChatBanner(context),
              Expanded(child: _buildMessagesArea(context, provider, isBotChat)),
              ChatInput(chatId: widget.chatId, isBotChat: isBotChat),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMessagesArea(
    BuildContext context,
    ChatProvider provider,
    bool isBotChat,
  ) {
    if (provider.isLoading && provider.messages.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.error != null) {
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
            ElevatedButton(
              onPressed: () => provider.initializeChat(widget.chatId),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    if (provider.messages.isEmpty) {
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
    return ListView.builder(
      controller: provider.scrollController,
      padding: const EdgeInsets.only(top: 8, bottom: 30),
      itemCount: groupedMessages.length,
      itemBuilder: (context, index) {
        final group = groupedMessages[index];
        return Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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

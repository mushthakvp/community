import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String chatName;
  final String? chatImage;
  final bool isGroup;
  final bool isBotChat;
  final VoidCallback onBackPressed;
  final VoidCallback onMenuPressed;

  const ChatAppBar({
    super.key,
    required this.chatName,
    this.chatImage,
    this.isGroup = false,
    this.isBotChat = false,
    required this.onBackPressed,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 2,
      shadowColor: Theme.of(context).shadowColor.withOpacity(0.3),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFD700), Color(0xFF000000)],
          ),
        ),
      ),
      leading: IconButton(
        onPressed: onBackPressed,
        icon: const Icon(Icons.arrow_back),
        style: IconButton.styleFrom(foregroundColor: Colors.white),
      ),
      title: Row(
        children: [
          // Chat avatar
          Stack(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white.withOpacity(0.2),
                backgroundImage: chatImage != null
                    ? CachedNetworkImageProvider(chatImage!)
                    : null,
                child: chatImage == null
                    ? Icon(_getChatIcon(), color: Colors.white, size: 24)
                    : null,
              ),
              // Bot indicator
              if (isBotChat)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: const Icon(
                      Icons.smart_toy,
                      size: 10,
                      color: Colors.white,
                    ),
                  ),
                ),

              if (!isBotChat && !isGroup)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),

          // Chat info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        chatName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isBotChat) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.verified, color: Colors.blue, size: 16),
                    ],
                    if (isGroup && !isBotChat) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.group, color: Colors.white70, size: 16),
                    ],
                  ],
                ),
                Text(
                  _getSubtitleText(),
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getChatIcon() {
    if (isBotChat) return Icons.smart_toy;
    if (isGroup) return Icons.group;
    return Icons.person;
  }

  String _getSubtitleText() {
    if (isBotChat) {
      return 'Bot • Always available';
    } else if (isGroup) {
      return 'Group • Tap for group info';
    } else {
      return 'Online'; // This would be dynamic based on actual online status
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CompactChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String chatName;
  final String? chatImage;
  final bool isGroup;
  final bool isBotChat;
  final VoidCallback onBackPressed;
  final VoidCallback onMenuPressed;

  const CompactChatAppBar({
    super.key,
    required this.chatName,
    this.chatImage,
    this.isGroup = false,
    this.isBotChat = false,
    required this.onBackPressed,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 1,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFD700), // Gold
              Color(0xFF000000), // Black
            ],
          ),
        ),
      ),
      leading: IconButton(
        onPressed: onBackPressed,
        icon: const Icon(Icons.arrow_back, color: Colors.white),
      ),
      title: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white.withOpacity(0.2),
            backgroundImage: chatImage != null
                ? CachedNetworkImageProvider(chatImage!)
                : null,
            child: chatImage == null
                ? Icon(
                    isBotChat
                        ? Icons.smart_toy
                        : (isGroup ? Icons.group : Icons.person),
                    color: Colors.white,
                    size: 18,
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              chatName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

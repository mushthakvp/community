import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/chat_provider.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF25D366), Color(0xFF128C7E)],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              const Text(
                'Chat',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              _buildChatTypeDropdown(context),
              const SizedBox(width: 12),
              _buildChatButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatTypeDropdown(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: DropdownButton<String>(
            value: provider.chatType,
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
            underline: const SizedBox(),
            dropdownColor: const Color(0xFF128C7E),
            style: const TextStyle(color: Colors.white),
            items: ['Explore', 'Popular', 'My Group']
                .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                .toList(),
            onChanged: (type) {
              if (type != null) {
                provider.changeChatType(type);
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildChatButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: const Icon(Icons.chat, color: Colors.white),
        onPressed: () {
          // Navigate to personal chat
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

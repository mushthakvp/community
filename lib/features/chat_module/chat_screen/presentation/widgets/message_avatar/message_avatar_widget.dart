import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/message_entity.dart';

class MessageAvatarWidget extends StatelessWidget {
  final MessageEntity message;

  const MessageAvatarWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
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
                errorWidget: (context, url, error) =>
                    _buildDefaultAvatar(context),
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
}

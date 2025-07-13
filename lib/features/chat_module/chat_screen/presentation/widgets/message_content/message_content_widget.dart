import 'package:flutter/material.dart';

import '../../../../shared/utils/message_utils.dart';
import '../../../domain/entities/message_entity.dart';
import '../message_media/message_media_widget.dart';
import '../message_text/message_text_widget.dart';

class MessageContentWidget extends StatelessWidget {
  final MessageEntity message;
  final Function(String)? onHashtagTap;
  final Function(String)? onMentionTap;
  final VoidCallback? onRetry;

  const MessageContentWidget({
    super.key,
    required this.message,
    this.onHashtagTap,
    this.onMentionTap,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (MessageUtils.isMediaMessage(message)) {
      return MessageMediaWidget(message: message, onRetry: onRetry);
    }

    if (message.content.isEmpty) {
      return const SizedBox.shrink();
    }

    return MessageTextWidget(
      message: message,
      onHashtagTap: onHashtagTap,
      onMentionTap: onMentionTap,
    );
  }
}

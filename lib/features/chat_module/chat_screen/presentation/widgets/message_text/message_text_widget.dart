import 'package:fittor/fittor.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/message_entity.dart';
import '../message_actions/url_handlers.dart';

class MessageTextWidget extends StatelessWidget {
  final MessageEntity message;
  final Function(String)? onHashtagTap;
  final Function(String)? onMentionTap;

  const MessageTextWidget({
    super.key,
    required this.message,
    this.onHashtagTap,
    this.onMentionTap,
  });

  @override
  Widget build(BuildContext context) {
    final baseTextColor = message.isCurrentUser
        ? Colors.white
        : Theme.of(context).colorScheme.onSurfaceVariant;

    return FitReadMore(
      message.content,
      trimLength: 500,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: baseTextColor,
        height: 1.4,
        fontSize: 15,
      ),
      colorClickableText: baseTextColor.withOpacity(0.7),
      trimMode: TrimMode.line,
      trimLines: 8,
      trimCollapsedText: ' Show more',
      trimExpandedText: ' Show less',
      annotations: [
        // URL annotation
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
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w500,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => UrlHandlers.handleUrlTap(text),
          ),
        ),
        // Hashtag annotation
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
              ..onTap = () => _handleHashtagTap(text),
          ),
        ),
        // Mention annotation
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
              ..onTap = () => _handleMentionTap(text),
          ),
        ),
        // Email annotation
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
              ..onTap = () => UrlHandlers.handleEmailTap(text),
          ),
        ),
        // Phone annotation
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
              ..onTap = () => UrlHandlers.handlePhoneTap(text),
          ),
        ),
      ],
    );
  }

  void _handleHashtagTap(String hashtag) {
    if (onHashtagTap != null) {
      onHashtagTap!(hashtag);
    } else {
      // Show hashtag options
    }
  }

  void _handleMentionTap(String mention) {
    if (onMentionTap != null) {
      onMentionTap!(mention);
    } else {
      // Show mention options
    }
  }
}

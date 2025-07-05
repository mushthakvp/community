import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/buttons/primary_button.dart';
import '../../../../../core/widgets/common/text_widget.dart';

class EmptyIdeasWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRefresh;

  const EmptyIdeasWidget({super.key, required this.message, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardOpen = keyboardHeight > 0;
    final iconSize = isKeyboardOpen ? 60.0 : 80.0;
    final titleFontSize = isKeyboardOpen ? 16.0 : 20.0;
    final messageFontSize = isKeyboardOpen ? 12.0 : 14.0;
    final padding = isKeyboardOpen ? 16.0 : 32.0;
    final spacing = isKeyboardOpen ? 12.0 : 24.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(padding),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight - (padding * 2),
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Flexible spacer to push content to center
                  const Spacer(flex: 1),

                  // Icon container
                  Container(
                    width: iconSize,
                    height: iconSize,
                    decoration: BoxDecoration(
                      color: AppConstants.appPrimaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(iconSize / 2),
                    ),
                    child: Icon(
                      Icons.lightbulb_outline,
                      size: iconSize * 0.5,
                      color: AppConstants.appPrimaryColor.withOpacity(0.7),
                    ),
                  ),

                  SizedBox(height: spacing),

                  // Title
                  CommonTextWidget(
                    text: 'No Ideas Found',
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.white,
                    align: TextAlign.center,
                  ),

                  SizedBox(height: spacing / 2),

                  // Message
                  Flexible(
                    child: CommonTextWidget(
                      text: message,
                      fontSize: messageFontSize,
                      fontWeight: FontWeight.w400,
                      color: AppConstants.white.withOpacity(0.7),
                      align: TextAlign.center,
                      maxLines: isKeyboardOpen ? 1 : 2,
                    ),
                  ),

                  // Refresh button (if provided)
                  if (onRefresh != null) ...[
                    SizedBox(height: spacing),
                    PrimaryButton(
                      text: 'Refresh',
                      onPressed: onRefresh!,
                      backgroundColor: Colors.transparent,
                      borderColor: AppConstants.appPrimaryColor,
                      textColor: AppConstants.appPrimaryColor,
                      fontSize: isKeyboardOpen ? 14 : 16,
                      fontWeight: FontWeight.w500,
                      height: isKeyboardOpen ? 40 : 48,
                      width: isKeyboardOpen ? 100 : 120,
                      prefix: Icon(
                        Icons.refresh,
                        color: AppConstants.appPrimaryColor,
                        size: isKeyboardOpen ? 16 : 20,
                      ),
                    ),
                  ],
                  const Spacer(flex: 1),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

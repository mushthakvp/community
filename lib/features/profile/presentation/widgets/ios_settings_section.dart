import 'package:flutter/material.dart';

import '../../../../core/widgets/common/text_widget.dart';
import 'ios_settings_item.dart';

class IOSSettingsSection extends StatelessWidget {
  final String? title;
  final List<IOSSettingsItem> items;

  const IOSSettingsSection({super.key, this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 8),
              child: CommonTextWidget(
                text: title!.toUpperCase(),
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF8E8E93),
              ),
            ),
          ],
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                for (int i = 0; i < items.length; i++) ...[
                  items[i],
                  if (i < items.length - 1)
                    Container(
                      margin: const EdgeInsets.only(left: 60),
                      height: 0.5,
                      color: const Color(0xFF3A3A3C),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

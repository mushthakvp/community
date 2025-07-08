import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final VoidCallback onClear;
  final bool isSearching;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
    this.isSearching = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xff262626),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: AppConstants.white.withOpacity(0.7),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: const TextStyle(color: AppConstants.white, fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Search your posts...',
                hintStyle: TextStyle(
                  color: AppConstants.white.withOpacity(0.5),
                  fontSize: 16,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          if (isSearching) ...[
            GestureDetector(
              onTap: onClear,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.close,
                  color: AppConstants.white.withOpacity(0.7),
                  size: 18,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../providers/search_provider.dart';

class SearchFieldWidget extends StatelessWidget {
  const SearchFieldWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xff262626),
            borderRadius: BorderRadius.circular(8),
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
                  controller: provider.searchController,
                  onChanged: provider.onSearchChanged,
                  style: const TextStyle(
                    color: AppConstants.white,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search job, company, or city',
                    hintStyle: TextStyle(
                      color: AppConstants.white.withOpacity(0.7),
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              if (provider.searchController.text.isNotEmpty)
                GestureDetector(
                  onTap: provider.clearSearch,
                  child: Icon(
                    Icons.clear,
                    color: AppConstants.white.withOpacity(0.7),
                    size: 20,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

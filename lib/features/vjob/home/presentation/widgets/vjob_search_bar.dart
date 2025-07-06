import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/inputs/text_field.dart';
import '../providers/vjob_home_provider.dart';

class VJobSearchBar extends StatelessWidget {
  const VJobSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<VJobHomeProvider>(
      builder: (context, provider, child) {
        return CommonTextField(
          controller: provider.searchController,
          hintText: 'Search job, company, or city',
          prefixIcon: const Icon(Icons.search, color: AppConstants.white),
          suffixIcon: provider.searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    provider.searchController.clear();
                    provider.onSearchChanged('');
                  },
                  icon: const Icon(Icons.clear, color: AppConstants.white),
                )
              : null,
          onChanged: provider.onSearchChanged,
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/router/vcart_router.dart';
import '../../../core/widgets/vcart_text_field.dart';

class ProductSearchBar extends StatelessWidget {
  const ProductSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return VCartTextField(
      hintText: "Find Your Needed....",
      readOnly: true,
      onTap: () => VCartRouterG.toVCartSearch(),
      prefixIcon: const Icon(
        Icons.search,
        color: VCartColors.textSecondary,
        size: 20,
      ),
    );
  }
}

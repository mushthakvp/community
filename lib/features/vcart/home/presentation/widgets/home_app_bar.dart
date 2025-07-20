import 'package:flutter/material.dart';
import 'package:livera/features/vcart/core/router/v_cart_router_g.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/constants/vcart_constants.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../../../core/widgets/vcart_text_field.dart';

class VCartHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onSearchTap;
  final VoidCallback? onNotificationTap;

  const VCartHomeAppBar({super.key, this.onSearchTap, this.onNotificationTap});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      expandedHeight: 120,
      backgroundColor: VCartColors.background,
      elevation: 0,
      leading: const SizedBox.shrink(),
      leadingWidth: 0,
      centerTitle: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [VCartColors.background, Color(0xFF111111)],
            ),
          ),
        ),
      ),
      title: Row(
        children: [
          const Text(
            'VCart',
            style: TextStyle(
              color: VCartColors.primary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: Container(
          padding: context.horizontalPadding,
          margin: const EdgeInsets.only(bottom: VCartConstants.defaultPadding),
          child: VCartTextField(
            hintText: "Find your needed....",
            readOnly: true,
            onTap: () {
              VCartRouterClassG.toVCartSearch();
            },
            prefixIcon: const Icon(
              Icons.search,
              color: VCartColors.textSecondary,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(120);
}

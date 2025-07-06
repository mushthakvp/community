import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/constants/app_constants.dart';
import '../../../../../../core/widgets/common/text_widget.dart';
import '../../providers/posts_provider.dart';

class VJobHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onSearchTap;
  final VoidCallback onToggleView;

  const VJobHomeAppBar({
    super.key,
    required this.onSearchTap,
    required this.onToggleView,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppConstants.black,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppConstants.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: const CommonTextWidget(
        text: 'Jobs',
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppConstants.white,
      ),
      centerTitle: false,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: CircleAvatar(
            backgroundColor: AppConstants.appPrimaryColor,
            child: Icon(Icons.person, color: AppConstants.black),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(child: _buildSearchField()),
              const SizedBox(width: 16),
              _buildToggleButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return GestureDetector(
      onTap: onSearchTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
            CommonTextWidget(
              text: 'Search job, company, or city',
              color: AppConstants.white.withOpacity(0.7),
              fontSize: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton() {
    return Consumer<PostsProvider>(
      builder: (context, provider, _) {
        return GestureDetector(
          onTap: onToggleView,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xff0f0f0f),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CommonTextWidget(
                  text: provider.isPostViewMode ? 'Posts' : 'Jobs',
                  color: AppConstants.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.keyboard_arrow_down_sharp,
                  color: AppConstants.white,
                  size: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 65);
}

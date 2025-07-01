import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/utils/extensions.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../domain/entities/vizzle_entities.dart';
import 'sub_items_list_item.dart';

class SubItemsList extends StatelessWidget {
  final List<SubItemEntity> subItems;
  final Function(SubItemEntity) onSubItemTap;

  const SubItemsList({
    super.key,
    required this.subItems,
    required this.onSubItemTap,
  });

  @override
  Widget build(BuildContext context) {
    if (subItems.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      height: context.height,
      width: context.width,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: subItems.length,
              separatorBuilder: (context, index) => Divider(
                color: AppConstants.white.withOpacity(0.3),
                thickness: 1,
                height: 0,
              ),
              itemBuilder: (context, index) {
                final sortedSubItems = [...subItems];
                sortedSubItems.sort((a, b) => a.name.compareTo(b.name));
                final subItem = sortedSubItems[index];

                return SubItemsListItem(
                  subItem: subItem,
                  onTap: () => onSubItemTap(subItem),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: AppConstants.white.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const CommonTextWidget(
            text: 'No Sub Items Found',
            color: AppConstants.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            align: TextAlign.center,
          ),
          const SizedBox(height: 8),
          CommonTextWidget(
            text: 'No items found for this subcategory',
            color: AppConstants.white.withOpacity(0.7),
            fontSize: 14,
            align: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

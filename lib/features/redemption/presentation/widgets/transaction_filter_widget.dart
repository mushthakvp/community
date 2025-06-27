import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../providers/redemption_provider.dart';

class TransactionFilterWidget extends StatelessWidget {
  const TransactionFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RedemptionProvider>(
      builder: (context, provider, child) {
        return Row(
          children: [
            // Current Filter Chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppConstants.appPrimaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: CommonTextWidget(
                text: _getFilterDisplayText(provider.selectedFilter),
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppConstants.black,
              ),
            ),
            
            const Spacer(),
            
            // Date Range Button
            IconButton(
              onPressed: () => provider.setDateRange(context),
              icon: const Icon(
                Icons.date_range,
                color: AppConstants.appPrimaryColor,
                size: 24,
              ),
            ),
            
            const SizedBox(width: 8),
            
            // Filter Menu Button
            PopupMenuButton<String>(
              color: AppConstants.appPrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onSelected: provider.changeFilter,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: AppConstants.appPrimaryColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CommonTextWidget(
                      text: 'Filter',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppConstants.appPrimaryColor,
                    ),
                    const SizedBox(width: 4),
                    SvgPicture.string(
                      _filterIcon,
                      height: 16,
                      width: 16,
                      colorFilter: const ColorFilter.mode(
                        AppConstants.appPrimaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
              ),
              itemBuilder: (context) => [
                'All',
                'Recharge',
                'Claimed',
                'Purchase',
              ].map((filter) => PopupMenuItem<String>(
                value: filter,
                child: CommonTextWidget(
                  text: filter,
                  fontSize: 14,
                  color: AppConstants.black,
                ),
              )).toList(),
            ),
          ],
        );
      },
    );
  }

  String _getFilterDisplayText(String filter) {
    switch (filter) {
      case 'All':
        return 'All Transactions';
      case 'Recharge':
        return 'Recharge';
      case 'Claimed':
        return 'Claimed';
      case 'Purchase':
        return 'Purchase';
      default:
        return 'All Transactions';
    }
  }

  static const String _filterIcon = '''
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
      <polygon points="22,3 2,3 10,12.46 10,19 14,21 14,12.46 22,3"></polygon>
    </svg>
  ''';
}

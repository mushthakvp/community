import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
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
        return Column(
          children: [
            Row(
              children: [
                // Current Filter Chip
                _buildCurrentFilterChip(provider),

                const Spacer(),

                // Date Range Display and Clear Button
                if (provider.hasDateRange) ...[
                  _buildDateRangeDisplay(provider),
                  const SizedBox(width: 8),
                ],

                // Date Range Button
                IconButton(
                  onPressed: () => _showDateRangePicker(context, provider),
                  icon: const Icon(
                    Icons.date_range,
                    color: AppConstants.appPrimaryColor,
                    size: 24,
                  ),
                ),

                const SizedBox(width: 8),

                // Filter Menu Button
                _buildFilterMenuButton(provider),
              ],
            ),

            // Date Range Display Row (if selected)
            if (provider.hasDateRange) ...[
              const SizedBox(height: 8),
              _buildDateRangeRow(provider),
            ],
          ],
        );
      },
    );
  }

  Widget _buildCurrentFilterChip(RedemptionProvider provider) {
    return Container(
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
    );
  }

  Widget _buildDateRangeDisplay(RedemptionProvider provider) {
    if (!provider.hasDateRange) return const SizedBox.shrink();

    final startDate = DateFormat('MMM dd').format(provider.startDate!);
    final endDate = DateFormat('MMM dd').format(provider.endDate!);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppConstants.appPrimaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppConstants.appPrimaryColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CommonTextWidget(
            text: '$startDate - $endDate',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppConstants.appPrimaryColor,
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => provider.clearDateRange(),
            child: const Icon(
              Icons.close,
              size: 16,
              color: AppConstants.appPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRangeRow(RedemptionProvider provider) {
    final startDate = DateFormat('dd/MM/yyyy').format(provider.startDate!);
    final endDate = DateFormat('dd/MM/yyyy').format(provider.endDate!);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppConstants.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.calendar_today,
            size: 16,
            color: AppConstants.appPrimaryColor,
          ),
          const SizedBox(width: 8),
          CommonTextWidget(
            text: 'From: $startDate  To: $endDate',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppConstants.white,
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => provider.clearDateRange(),
            child: const Icon(Icons.clear, size: 18, color: AppConstants.white),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterMenuButton(RedemptionProvider provider) {
    return PopupMenuButton<String>(
      color: AppConstants.appPrimaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
      itemBuilder: (context) => ['All', 'Recharge', 'Claimed', 'Purchase']
          .map(
            (filter) => PopupMenuItem<String>(
              value: filter,
              child: Row(
                children: [
                  if (provider.selectedFilter == filter)
                    const Icon(
                      Icons.check,
                      size: 16,
                      color: AppConstants.black,
                    ),
                  if (provider.selectedFilter == filter)
                    const SizedBox(width: 8),
                  CommonTextWidget(
                    text: filter,
                    fontSize: 14,
                    color: AppConstants.black,
                    fontWeight: provider.selectedFilter == filter
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Future<void> _showDateRangePicker(
    BuildContext context,
    RedemptionProvider provider,
  ) async {
    DateTime? tempStartDate;
    DateTime? tempEndDate;

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: provider.hasDateRange
          ? DateTimeRange(start: provider.startDate!, end: provider.endDate!)
          : null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppConstants.appPrimaryColor,
              onPrimary: AppConstants.black,
              surface: AppConstants.black,
              onSurface: AppConstants.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      tempStartDate = picked.start;
      tempEndDate = picked.end;

      provider.setCustomDateRange(tempStartDate, tempEndDate);
    }
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

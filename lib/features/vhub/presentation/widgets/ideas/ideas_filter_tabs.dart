import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../providers/vhub_provider.dart';

class IdeasFilterTabs extends StatelessWidget {
  const IdeasFilterTabs({super.key});

  final List<FilterTab> _tabs = const [
    FilterTab(title: 'All', status: 'All', icon: Icons.apps),
    FilterTab(
      title: 'Accepted',
      status: 'Accepted',
      icon: Icons.check_circle_outline,
    ),
    FilterTab(
      title: 'Requested',
      status: 'Requested',
      icon: Icons.pending_outlined,
    ),
    FilterTab(
      title: 'Rejected',
      status: 'Rejected',
      icon: Icons.cancel_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<VHubProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _tabs.map((tab) {
              final isSelected = provider.selectedStatus == tab.status;
              return GestureDetector(
                onTap: () => provider.filterByStatus(tab.status),
                child: AnimatedContainer(
                  duration: AppConstants.defaultAnimationDuration,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [
                              AppConstants.appPrimaryColor,
                              AppConstants.appPrimaryColor.withOpacity(0.8),
                            ],
                          )
                        : null,
                    color: isSelected
                        ? null
                        : AppConstants.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppConstants.appPrimaryColor
                          : AppConstants.white.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        tab.icon,
                        size: 16,
                        color: isSelected
                            ? AppConstants.black
                            : AppConstants.white.withOpacity(0.7),
                      ),
                      const SizedBox(width: 6),
                      CommonTextWidget(
                        text: tab.title,
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: isSelected
                            ? AppConstants.black
                            : AppConstants.white.withOpacity(0.7),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class FilterTab {
  final String title;
  final String status;
  final IconData icon;

  const FilterTab({
    required this.title,
    required this.status,
    required this.icon,
  });
}

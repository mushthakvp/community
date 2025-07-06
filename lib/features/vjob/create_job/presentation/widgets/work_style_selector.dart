import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../providers/create_job_provider.dart';

class WorkStyleSelector extends StatelessWidget {
  const WorkStyleSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateJobProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CommonTextWidget(
              text: 'Choose Your Workstyle',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppConstants.white,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: AppConstants.black,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppConstants.white.withOpacity(0.2)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: provider.selectedWorkStyle.isEmpty
                      ? null
                      : provider.selectedWorkStyle,
                  hint: CommonTextWidget(
                    text: 'Ex: On Site',
                    fontSize: 14,
                    color: AppConstants.white.withOpacity(0.6),
                  ),
                  dropdownColor: AppConstants.black,
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: AppConstants.white,
                  ),
                  items: provider.workStyleOptions.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: CommonTextWidget(
                        text: item,
                        fontSize: 14,
                        color: AppConstants.white,
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    if (value != null) {
                      provider.setWorkStyle(value);
                    }
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

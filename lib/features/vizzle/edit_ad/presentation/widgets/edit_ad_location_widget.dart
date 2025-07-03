import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../providers/edit_ad_provider.dart';

class EditAdLocationWidget extends StatelessWidget {
  const EditAdLocationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EditAdProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CommonTextWidget(
              text: "Location",
              color: AppConstants.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF262626),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppConstants.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  // Map Preview (Placeholder)
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppConstants.white.withOpacity(0.05),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 32,
                            color: AppConstants.appPrimaryColor,
                          ),
                          const SizedBox(height: 8),
                          const CommonTextWidget(
                            text: "Map Preview",
                            fontSize: 12,
                            color: AppConstants.white,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Location Details
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_city,
                              size: 16,
                              color: AppConstants.appPrimaryColor,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: CommonTextWidget(
                                text: provider.district.isNotEmpty
                                    ? provider.district
                                    : "No location selected",
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppConstants.white,
                              ),
                            ),
                          ],
                        ),
                        if (provider.address.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 16,
                                color: AppConstants.white.withOpacity(0.6),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: CommonTextWidget(
                                  text: provider.address,
                                  fontSize: 12,
                                  color: AppConstants.white.withOpacity(0.6),
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Location picker coming soon!'),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppConstants.appPrimaryColor.withOpacity(
                                0.1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppConstants.appPrimaryColor.withOpacity(
                                  0.3,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.edit_location,
                                  size: 16,
                                  color: AppConstants.appPrimaryColor,
                                ),
                                const SizedBox(width: 8),
                                const CommonTextWidget(
                                  text: "Change Location",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppConstants.appPrimaryColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/card_widget.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../pages/location_picker_page.dart';
import '../providers/add_edit_provider.dart';

class LocationPickerWidget extends StatelessWidget {
  const LocationPickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddEditProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CommonTextWidget(
              text: "Location",
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppConstants.white,
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => _openLocationPicker(context, provider),
              child: CommonCard(
                child: Column(
                  children: [
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppConstants.surfaceContainer,
                        borderRadius: BorderRadius.circular(
                          AppConstants.defaultBorderRadius,
                        ),
                      ),
                      child: Center(
                        child: provider.currentLocation?.isValid == true
                            ? Icon(
                                Icons.location_on,
                                size: 48,
                                color: AppConstants.appPrimaryColor,
                              )
                            : Icon(
                                Icons.location_off,
                                size: 48,
                                color: AppConstants.white.withOpacity(0.4),
                              ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    CommonTextWidget(
                      text:
                          provider.currentLocation?.placeName ??
                          "No location selected",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      align: TextAlign.center,
                      maxLines: 2,
                    ),
                    if (provider.currentLocation?.address != null) ...[
                      const SizedBox(height: 4),
                      CommonTextWidget(
                        text: provider.currentLocation!.address!,
                        fontSize: 12,
                        color: AppConstants.white.withOpacity(0.6),
                        align: TextAlign.center,
                        maxLines: 2,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.edit_location,
                          size: 16,
                          color: AppConstants.appPrimaryColor,
                        ),
                        const SizedBox(width: 4),
                        CommonTextWidget(
                          text: "Tap to select location",
                          fontSize: 12,
                          color: AppConstants.appPrimaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _openLocationPicker(BuildContext context, AddEditProvider provider) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationSearchView(
          googleApiKey: "AIzaSyBOHuJ-4CqJBjmSi_RugeonwPU5cBVqbeA",
          onLocationSelected: (location) {
            provider.updateLocation(location.latitude, location.longitude);
          },
        ),
      ),
    );
  }
}

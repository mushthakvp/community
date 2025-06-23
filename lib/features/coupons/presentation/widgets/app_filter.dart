// lib/features/coupons/presentation/widgets/app_filter.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../data/models/coupon_model.dart';

class AppFilter extends StatelessWidget {
  final List<AppElement> apps;
  final String selectedAppId;
  final Function(String) onAppSelected;

  const AppFilter({
    super.key,
    required this.apps,
    required this.selectedAppId,
    required this.onAppSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: apps.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final app = apps[index];
          final isSelected = app.id == selectedAppId;

          return GestureDetector(
            onTap: () => onAppSelected(isSelected ? '' : app.id ?? ''),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 70,
              height: 70,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xff1A1A1A),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppConstants.appPrimaryColor
                      : AppConstants.white.withOpacity(0.2),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppConstants.appPrimaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 0,
                        ),
                      ]
                    : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: app.logo ?? '',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: const Color(0xff2A2A2A),
                    child: const CircularProgressIndicator(
                      color: AppConstants.appPrimaryColor,
                      strokeWidth: 2,
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: const Color(0xff2A2A2A),
                    child: const Icon(
                      Icons.image,
                      color: AppConstants.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

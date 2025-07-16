import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../../domain/entities/spin_history_entity.dart';
import '../providers/spin_provider.dart';

class SpinHistoryDateGroup extends StatelessWidget {
  final String dateKey;
  final List<SpinHistoryEntity> spins;

  const SpinHistoryDateGroup({
    super.key,
    required this.dateKey,
    required this.spins,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppConstants.appPrimaryColor.withOpacity(0.2),
                  AppConstants.appPrimaryColor.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppConstants.appPrimaryColor.withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CommonTextWidget(
                  text: dateKey,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.white,
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppConstants.appPrimaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: CommonTextWidget(
                    text: spins.length.toString(),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.black,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Spin Items
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: spins.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final spin = spins[index];
              return spin.couponCode != null
                  ? SpinHistoryCouponItem(spin: spin)
                  : SpinHistoryPointsItem(spin: spin);
            },
          ),
        ],
      ),
    );
  }
}

class SpinHistoryPointsItem extends StatelessWidget {
  final SpinHistoryEntity spin;

  const SpinHistoryPointsItem({super.key, required this.spin});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppConstants.black.withOpacity(0.4),
            AppConstants.black.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppConstants.appPrimaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              spin.isWin ? Icons.stars : Icons.sentiment_neutral,
              color: spin.isWin ? AppConstants.appPrimaryColor : Colors.orange,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonTextWidget(
                  text: spin.loyaltyPoint != null
                      ? '${spin.loyaltyPoint} Loyalty Points Earned'
                      : spin.displayResult,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppConstants.white,
                ),
                const SizedBox(height: 4),
                CommonTextWidget(
                  text: _formatTime(spin.date),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white60,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}

class SpinHistoryCouponItem extends StatelessWidget {
  final SpinHistoryEntity spin;

  const SpinHistoryCouponItem({super.key, required this.spin});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppConstants.appPrimaryColor.withOpacity(0.1),
            AppConstants.appPrimaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppConstants.appPrimaryColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppConstants.appPrimaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.local_offer,
                  color: AppConstants.appPrimaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CommonTextWidget(
                      text: 'You\'ve Won a Coupon!',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppConstants.white,
                    ),
                    const SizedBox(height: 4),
                    CommonTextWidget(
                      text: _formatTime(spin.date),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.white60,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Coupon Details
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppConstants.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppConstants.appPrimaryColor.withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonTextWidget(
                        text: spin.spinOption?.title ?? 'Coupon',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppConstants.white,
                      ),
                      const SizedBox(height: 4),
                      CommonTextWidget(
                        text: 'Code: ${spin.couponCode ?? 'N/A'}',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppConstants.appPrimaryColor,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _copyCouponCode(context),
                  icon: const Icon(
                    Icons.copy,
                    color: AppConstants.appPrimaryColor,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  void _copyCouponCode(BuildContext context) {
    if (spin.couponCode != null) {
      context.read<SpinProvider>().copyCouponCode(spin.couponCode!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Coupon code copied to clipboard!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

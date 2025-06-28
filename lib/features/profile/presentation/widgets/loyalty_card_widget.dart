import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../../domain/entities/loyalty_card_entity.dart';

class LoyaltyCardWidget extends StatelessWidget {
  final LoyaltyCardEntity? loyaltyCard;
  final VoidCallback? onClaimPressed;
  final bool isLoading;

  const LoyaltyCardWidget({
    super.key,
    this.loyaltyCard,
    this.onClaimPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF7742BA), Color(0xFF162287)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppConstants.appPrimaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardHeader(),
            const SizedBox(height: 20),
            _buildCardBody(),
            const SizedBox(height: 20),
            _buildCardFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildCardHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: AppConstants.white.withOpacity(0.2),
          backgroundImage: loyaltyCard?.profileImage.isNotEmpty == true
              ? NetworkImage(loyaltyCard!.profileImage)
              : null,
          child: loyaltyCard?.profileImage.isEmpty != false
              ? const Icon(Icons.person, color: AppConstants.white, size: 30)
              : null,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CommonTextWidget(
                text: 'LOYALTY CARD',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppConstants.white,
              ),
              const SizedBox(height: 4),
              CommonTextWidget(
                text: loyaltyCard?.communityId ?? 'COMM001',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppConstants.appPrimaryColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCardBody() {
    return Row(
      children: [
        Expanded(
          child: _buildInfoItem('Name', loyaltyCard?.name ?? 'User Name'),
        ),
        Expanded(
          child: _buildInfoItem(
            'Loyalty Points',
            '${loyaltyCard?.loyaltyPoints ?? 0}',
          ),
        ),
      ],
    );
  }

  Widget _buildCardFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonTextWidget(
                  text: '${loyaltyCard?.loyaltyPoints ?? 0}',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.white,
                ),
                const CommonTextWidget(
                  text: 'Loyalty Points',
                  fontSize: 12,
                  color: AppConstants.white,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CommonTextWidget(
                  text: '1000 points = 1 INR',
                  fontSize: 12,
                  color: AppConstants.white,
                ),
                const CommonTextWidget(
                  text: 'Min 5000 points to claim',
                  fontSize: 10,
                  color: AppConstants.white,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: isLoading ? null : onClaimPressed,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppConstants.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppConstants.black,
                        ),
                      ),
                    )
                  : const CommonTextWidget(
                      text: 'Claim',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.black,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonTextWidget(
          text: label,
          fontSize: 12,
          color: AppConstants.white.withOpacity(0.7),
        ),
        const SizedBox(height: 4),
        CommonTextWidget(
          text: value,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppConstants.white,
          maxLines: 1,
        ),
      ],
    );
  }
}

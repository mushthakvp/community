import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/common/image_widget.dart';
import '../../../../core/widgets/common/spacer_widget.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../../../../core/widgets/loading/shimmer_loading.dart';
import '../providers/redemption_provider.dart';

class RedemptionCardWidget extends StatelessWidget {
  const RedemptionCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RedemptionProvider>(
      builder: (context, provider, child) {
        return ShimmerLoading(
          isLoading: provider.isLoadingUserDetails,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF2A2A2A),
                  Color(0xFF1A1A1A),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppConstants.appPrimaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                _buildMainCard(context, provider),
                if (provider.isShowingCommunityId)
                  _buildCommunityIdSection(provider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainCard(BuildContext context, RedemptionProvider provider) {
    final user = provider.userDetails;
    
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Left Section - Profile & Recharge Button
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.32,
            child: Column(
              children: [
                // Profile Image
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppConstants.appPrimaryColor.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: AppConstants.appPrimaryColor.withOpacity(0.2),
                    child: CommonImageWidget(
                      imageUrl: user?.profileImage,
                      width: 60,
                      height: 60,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                
                AppSpacing.verticalMD,
                
                // Recharge Button
                PrimaryButton(
                  text: 'Recharge',
                  height: 32,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  onPressed: () => context.push('/redemption/recharge'),
                ),
              ],
            ),
          ),
          
          AppSpacing.horizontalMD,
          
          // Right Section - Wallet Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Wallet Balance
                const CommonTextWidget(
                  text: 'Wallet Balance',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppConstants.white,
                ),
                
                AppSpacing.verticalXS,
                
                CommonTextWidget(
                  text: '${user?.currencyCode ?? '₹'} ${user?.walletAmount?.toStringAsFixed(2) ?? '0.00'}',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppConstants.appPrimaryColor,
                ),
                
                AppSpacing.verticalMD,
                
                // User Details Grid
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoField(
                        'Name',
                        user?.name ?? 'N/A',
                      ),
                    ),
                    AppSpacing.horizontalSM,
                    Expanded(
                      child: _buildInfoField(
                        'Loyalty Points',
                        user?.loyaltyPoints?.toStringAsFixed(0) ?? '0',
                      ),
                    ),
                  ],
                ),
                
                AppSpacing.verticalSM,
                
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoField(
                        'Wallet Amount',
                        '${user?.currencyCode ?? '₹'} ${user?.walletAmount?.toStringAsFixed(2) ?? '0.00'}',
                      ),
                    ),
                    AppSpacing.horizontalSM,
                    Expanded(
                      child: _buildInfoField(
                        'Join Date',
                        _formatDate(user?.joined),
                      ),
                    ),
                  ],
                ),
                
                AppSpacing.verticalSM,
                
                // Community ID Toggle
                InkWell(
                  onTap: provider.toggleCommunityIdVisibility,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CommonTextWidget(
                        text: 'Community ID',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppConstants.white,
                      ),
                      Icon(
                        provider.isShowingCommunityId
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        color: AppConstants.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityIdSection(RedemptionProvider provider) {
    final user = provider.userDetails;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppConstants.white.withOpacity(0.05),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CommonTextWidget(
            text: 'Community ID',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppConstants.appPrimaryColor,
          ),
          AppSpacing.verticalXS,
          CommonTextWidget(
            text: user?.communityId ?? 'N/A',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppConstants.appPrimaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonTextWidget(
          text: label,
          fontSize: 10,
          fontWeight: FontWeight.w400,
          color: AppConstants.white.withOpacity(0.7),
        ),
        AppSpacing.verticalXS,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppConstants.white.withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: CommonTextWidget(
            text: value,
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppConstants.white,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return 'N/A';
    }
  }
}

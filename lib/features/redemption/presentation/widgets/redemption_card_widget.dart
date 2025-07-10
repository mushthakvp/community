import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/route_constants.dart';
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
                colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppConstants.appPrimaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(children: [_buildMainCard(context, provider)]),
          ),
        );
      },
    );
  }

  Widget _buildMainCard(BuildContext context, RedemptionProvider provider) {
    final user = provider.userDetails;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppConstants.appPrimaryColor.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: AppConstants.appPrimaryColor.withOpacity(
                    0.2,
                  ),
                  child: CommonImageWidget(
                    imageUrl: user?.profileImage,
                    width: 70,
                    height: 70,
                    borderRadius: BorderRadius.circular(35),
                  ),
                ),
              ),

              AppSpacing.horizontalLG,

              // Wallet Balance Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CommonTextWidget(
                      text: 'Wallet Balance',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppConstants.white,
                    ),

                    AppSpacing.verticalXS,

                    CommonTextWidget(
                      text:
                          '${user?.currencyCode ?? '₹'} ${user?.walletAmount?.toStringAsFixed(2) ?? '0.00'}',
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppConstants.appPrimaryColor,
                    ),

                    AppSpacing.verticalSM,
                    SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                        text: 'Recharge Wallet',
                        height: 40,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        onPressed: () =>
                            context.push(RouteConstants.walletRecharge),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

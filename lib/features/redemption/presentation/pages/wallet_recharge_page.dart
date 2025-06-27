import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/common/app_bar.dart';
import '../../../../core/widgets/common/spacer_widget.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../../../../core/widgets/inputs/text_field.dart';
import '../providers/redemption_provider.dart';
import '../providers/wallet_recharge_provider.dart';

class WalletRechargePage extends StatefulWidget {
  const WalletRechargePage({super.key});

  @override
  State<WalletRechargePage> createState() => _WalletRechargePageState();
}

class _WalletRechargePageState extends State<WalletRechargePage> {
  @override
  void initState() {
    super.initState();
    context.read<WalletRechargeProvider>().initializeRazorpay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppConstants.black,
              Color(0xFF1A1A1A),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Bar
                CommonAppBar(
                  title: 'Recharge Wallet',
                  showBackButton: true,
                  backgroundColor: Colors.transparent,
                ),

                AppSpacing.verticalLG,

                // Amount Input Section
                const CommonTextWidget(
                  text: 'Enter Amount',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppConstants.white,
                ),

                AppSpacing.verticalSM,

                Consumer<WalletRechargeProvider>(
                  builder: (context, provider, child) {
                    return CommonTextField(
                      controller: provider.rechargeAmountController,
                      hintText: 'Enter recharge amount',
                      keyboardType: TextInputType.number,
                      prefixIcon: const Icon(
                        Icons.currency_rupee,
                        color: AppConstants.appPrimaryColor,
                      ),
                    );
                  },
                ),

                AppSpacing.verticalLG,

                // Quick Amount Selection
                const CommonTextWidget(
                  text: 'Quick Select',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppConstants.white,
                ),

                AppSpacing.verticalSM,

                Consumer<WalletRechargeProvider>(
                  builder: (context, provider, child) {
                    return SizedBox(
                      height: 60,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: provider.defaultAmounts.length,
                        separatorBuilder: (_, __) => AppSpacing.horizontalSM,
                        itemBuilder: (context, index) {
                          final amount = provider.defaultAmounts[index];
                          return _buildAmountChip(amount, provider);
                        },
                      ),
                    );
                  },
                ),

                const Spacer(),

                // Error Display
                Consumer<WalletRechargeProvider>(
                  builder: (context, provider, child) {
                    if (provider.error != null) {
                      return Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red),
                            AppSpacing.horizontalSM,
                            Expanded(
                              child: CommonTextWidget(
                                text: provider.error!,
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            ),
                            IconButton(
                              onPressed: provider.clearError,
                              icon: const Icon(Icons.close, color: Colors.red),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),

                // Recharge Button
                Consumer<WalletRechargeProvider>(
                  builder: (context, provider, child) {
                    return PrimaryButton(
                      text: 'Recharge Wallet',
                      isLoading: provider.isProcessingPayment,
                      onPressed: provider.isProcessingPayment 
                          ? null 
                          : () => _initiateRecharge(provider),
                      width: double.infinity,
                    );
                  },
                ),

                AppSpacing.verticalMD,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAmountChip(String amount, WalletRechargeProvider provider) {
    return InkWell(
      onTap: () => provider.selectAmount(amount),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppConstants.white.withOpacity(0.1),
          ),
        ),
        child: CommonTextWidget(
          text: '₹$amount',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppConstants.white,
        ),
      ),
    );
  }

  void _initiateRecharge(WalletRechargeProvider provider) {
    provider.initiatePayment(
      onSuccess: () {
        context.showSuccessSnackBar('Wallet recharged successfully!');
        context.read<RedemptionProvider>().refresh();
        context.pop();
      },
    );
  }
}

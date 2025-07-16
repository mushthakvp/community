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
import '../../../promos/presentation/animation/animated_promos_background.dart';
import '../providers/redemption_provider.dart';
import '../providers/wallet_recharge_provider.dart';
import '../widgets/animated_amount_selector.dart';
import '../widgets/animated_wallet_card.dart';

class WalletRechargePage extends StatefulWidget {
  const WalletRechargePage({super.key});

  @override
  State<WalletRechargePage> createState() => _WalletRechargePageState();
}

class _WalletRechargePageState extends State<WalletRechargePage>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _pulseController;

  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
        );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // FIXED: Safe initialization - use addPostFrameCallback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeProvider();
      _startAnimations();
    });
  }

  void _initializeProvider() {
    try {
      final provider = Provider.of<WalletRechargeProvider>(
        context,
        listen: false,
      );

      // FIXED: Only initialize if not already initialized
      if (!provider.isInitialized) {
        provider.initializeRazorpay();
      }

      // FIXED: Reset state safely after initialization
      provider.resetState();

      debugPrint('FIXED: WalletRechargeProvider initialized successfully');
    } catch (e) {
      debugPrint('FIXED: Error initializing WalletRechargeProvider: $e');
    }
  }

  void _startAnimations() {
    _fadeController.forward();
    _slideController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      body: AnimatedPromosBackground(
        child: SafeArea(
          child: SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  const CommonAppBar(
                    title: 'Recharge Wallet',
                    showBackButton: true,
                    backgroundColor: Colors.transparent,
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppSpacing.verticalLG,

                          // FIXED: Enhanced wallet card with pulse animation
                          AnimatedBuilder(
                            animation: _pulseAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _pulseAnimation.value,
                                child: const AnimatedWalletCard(),
                              );
                            },
                          ),

                          AppSpacing.verticalXL,

                          _buildAnimatedSection(
                            delay: 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            AppConstants.appPrimaryColor
                                                .withOpacity(0.3),
                                            AppConstants.appPrimaryColor
                                                .withOpacity(0.1),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.account_balance_wallet,
                                        color: AppConstants.appPrimaryColor,
                                        size: 20,
                                      ),
                                    ),
                                    AppSpacing.horizontalSM,
                                    const CommonTextWidget(
                                      text: 'Enter Amount',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: AppConstants.white,
                                    ),
                                  ],
                                ),

                                AppSpacing.verticalMD,

                                Consumer<WalletRechargeProvider>(
                                  builder: (context, provider, child) {
                                    return AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppConstants.appPrimaryColor
                                                .withOpacity(0.3),
                                            blurRadius: 20,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: CommonTextField(
                                        controller:
                                            provider.rechargeAmountController,
                                        hintText: 'Enter recharge amount',
                                        keyboardType:
                                            const TextInputType.numberWithOptions(
                                              decimal: true,
                                            ),
                                        borderRadius: 16,
                                        prefixIcon: Container(
                                          padding: const EdgeInsets.all(12),
                                          child: const Icon(
                                            Icons.currency_rupee,
                                            color: AppConstants.appPrimaryColor,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),

                          AppSpacing.verticalXL,

                          _buildAnimatedSection(
                            delay: 400,
                            child: const AnimatedAmountSelector(),
                          ),

                          AppSpacing.verticalXXL,

                          // Error display
                          Consumer<WalletRechargeProvider>(
                            builder: (context, provider, child) {
                              if (provider.error != null) {
                                return _buildAnimatedErrorContainer(provider);
                              }
                              return const SizedBox.shrink();
                            },
                          ),

                          // Recharge button
                          _buildAnimatedSection(
                            delay: 600,
                            child: Consumer<WalletRechargeProvider>(
                              builder: (context, provider, child) {
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  transform: Matrix4.identity()
                                    ..scale(
                                      provider.isProcessingPayment ? 0.95 : 1.0,
                                    ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppConstants.appPrimaryColor
                                              .withOpacity(0.4),
                                          blurRadius: 20,
                                          spreadRadius: 0,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: PrimaryButton(
                                      text: provider.isProcessingPayment
                                          ? 'Processing Payment...'
                                          : 'Recharge Wallet',
                                      isLoading: provider.isProcessingPayment,
                                      onPressed: provider.isProcessingPayment
                                          ? null
                                          : () => _initiateRecharge(provider),
                                      width: double.infinity,
                                      height: 56,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      borderRadius: 16,
                                      prefix: provider.isProcessingPayment
                                          ? null
                                          : const Icon(
                                              Icons.payment,
                                              color: AppConstants.black,
                                              size: 20,
                                            ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedSection({required Widget child, int delay = 0}) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: child,
    );
  }

  Widget _buildAnimatedErrorContainer(WalletRechargeProvider provider) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 400),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.red.withOpacity(0.2),
                  Colors.red.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.red.withOpacity(0.5), width: 1),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 24,
                  ),
                ),
                AppSpacing.horizontalMD,
                Expanded(
                  child: CommonTextWidget(
                    text: provider.error!,
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                IconButton(
                  onPressed: provider.clearError,
                  icon: const Icon(Icons.close, color: Colors.red),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _initiateRecharge(WalletRechargeProvider provider) {
    // Validate amount
    final amountText = provider.rechargeAmountController.text.trim();
    if (amountText.isEmpty) {
      context.showErrorSnackBar('Please enter an amount');
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      context.showErrorSnackBar('Please enter a valid amount');
      return;
    }

    if (amount < 10) {
      context.showErrorSnackBar('Minimum recharge amount is ₹10');
      return;
    }

    if (amount > 100000) {
      context.showErrorSnackBar('Maximum recharge amount is ₹1,00,000');
      return;
    }

    // Initiate payment
    provider.initiatePayment(
      onSuccess: () {
        context.showSuccessSnackBar('Wallet recharged successfully!');

        // FIXED: Refresh redemption data after successful recharge
        final redemptionProvider = Provider.of<RedemptionProvider>(
          context,
          listen: false,
        );
        redemptionProvider.refreshAfterWalletRecharge();

        context.pop();
      },
    );
  }
}

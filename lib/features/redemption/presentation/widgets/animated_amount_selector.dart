import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/spacer_widget.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../providers/wallet_recharge_provider.dart';

class AnimatedAmountSelector extends StatefulWidget {
  const AnimatedAmountSelector({super.key});

  @override
  State<AnimatedAmountSelector> createState() => _AnimatedAmountSelectorState();
}

class _AnimatedAmountSelectorState extends State<AnimatedAmountSelector>
    with TickerProviderStateMixin {
  late AnimationController _staggerController;
  late List<Animation<Offset>> _slideAnimations;
  late List<Animation<double>> _scaleAnimations;

  @override
  void initState() {
    super.initState();

    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    final amounts = context.read<WalletRechargeProvider>().defaultAmounts;
    _slideAnimations = [];
    _scaleAnimations = [];

    for (int i = 0; i < amounts.length; i++) {
      final delay = i * 0.1;

      _slideAnimations.add(
        Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _staggerController,
            curve: Interval(delay, 0.8 + delay, curve: Curves.elasticOut),
          ),
        ),
      );

      _scaleAnimations.add(
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _staggerController,
            curve: Interval(delay, 0.6 + delay, curve: Curves.easeOutBack),
          ),
        ),
      );
    }

    _staggerController.forward();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletRechargeProvider>(
      builder: (context, provider, child) {
        return SizedBox(
          height: 120,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2.2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: provider.defaultAmounts.length,
            itemBuilder: (context, index) {
              final amount = provider.defaultAmounts[index];
              final isSelected =
                  provider.rechargeAmountController.text == amount;

              return AnimatedBuilder(
                animation: Listenable.merge([
                  _slideAnimations[index],
                  _scaleAnimations[index],
                ]),
                builder: (context, child) {
                  return SlideTransition(
                    position: _slideAnimations[index],
                    child: ScaleTransition(
                      scale: _scaleAnimations[index],
                      child: _buildAmountChip(amount, isSelected, provider),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildAmountChip(
    String amount,
    bool isSelected,
    WalletRechargeProvider provider,
  ) {
    return GestureDetector(
      onTap: () {
        // Add selection animation
        provider.selectAmount(amount);
        _animateSelection();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppConstants.appPrimaryColor,
                    AppConstants.appPrimaryColor.withOpacity(0.8),
                  ],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [const Color(0xFF2A2A2A), const Color(0xFF1A1A1A)],
                ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppConstants.appPrimaryColor
                : AppConstants.white.withOpacity(0.1),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppConstants.appPrimaryColor.withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: AppConstants.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Stack(
          children: [
            // Ripple effect overlay when selected
            if (isSelected)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 600),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: Alignment.center,
                            radius: value * 2,
                            colors: [
                              AppConstants.appPrimaryColor.withOpacity(0.3),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

            // Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.currency_rupee,
                    color: isSelected
                        ? AppConstants.black
                        : AppConstants.appPrimaryColor,
                    size: 20,
                  ),
                  AppSpacing.verticalXS,
                  CommonTextWidget(
                    text: amount,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? AppConstants.black : AppConstants.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _animateSelection() {
    final controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    controller.forward().then((_) {
      controller.reverse().then((_) {
        controller.dispose();
      });
    });
  }
}

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
  late AnimationController _pulseController;
  late AnimationController _rippleController;
  late AnimationController _selectionController;

  late List<Animation<Offset>> _slideAnimations;
  late List<Animation<double>> _scaleAnimations;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rippleAnimation;
  late Animation<double> _selectionAnimation;

  int? _selectedIndex;
  int? _tappedIndex;

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _selectionController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _rippleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeOut),
    );
    _selectionAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _selectionController, curve: Curves.elasticOut),
    );
    final amounts = context.read<WalletRechargeProvider>().defaultAmounts;
    _slideAnimations = [];
    _scaleAnimations = [];
    for (int i = 0; i < amounts.length; i++) {
      final delay = (i * 0.1).clamp(0.0, 0.6);
      final endSlide = (0.7 + delay).clamp(0.0, 1.0);
      final endScale = (0.6 + delay).clamp(0.0, 1.0);
      _slideAnimations.add(
        Tween<Offset>(begin: const Offset(0, 1.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _staggerController,
            curve: Interval(delay, endSlide, curve: Curves.elasticOut),
          ),
        ),
      );
      _scaleAnimations.add(
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _staggerController,
            curve: Interval(delay, endScale, curve: Curves.easeOutBack),
          ),
        ),
      );
    }
    _staggerController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _staggerController.dispose();
    _pulseController.dispose();
    _rippleController.dispose();
    _selectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletRechargeProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            // Popular amounts header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppConstants.appPrimaryColor.withOpacity(0.3),
                        AppConstants.appPrimaryColor.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.star,
                    color: AppConstants.appPrimaryColor,
                    size: 16,
                  ),
                ),
                AppSpacing.horizontalSM,
                const CommonTextWidget(
                  text: 'Popular amounts',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppConstants.white,
                ),
                const Spacer(),
                // Clear selection button
                if (provider.rechargeAmountController.text.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      provider.rechargeAmountController.clear();
                      setState(() {
                        _selectedIndex = null;
                      });
                      _animateSelection(-1); // Animate deselection
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppConstants.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppConstants.white.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.clear,
                            color: AppConstants.white,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          const CommonTextWidget(
                            text: 'Clear',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppConstants.white,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

            AppSpacing.verticalMD,

            // Grid of amount chips - FIXED: Removed SizedBox height constraint
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.8, // FIXED: Better aspect ratio
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
                    _pulseAnimation,
                    _rippleAnimation,
                    _selectionAnimation,
                  ]),
                  builder: (context, child) {
                    final extraScale = _selectedIndex == index
                        ? _selectionAnimation.value
                        : 1.0;
                    return SlideTransition(
                      position: _slideAnimations[index],
                      child: ScaleTransition(
                        scale: _scaleAnimations[index],
                        child: Transform.scale(
                          scale: extraScale,
                          child: _buildEnhancedAmountChip(
                            amount,
                            isSelected,
                            index,
                            provider,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildEnhancedAmountChip(
    String amount,
    bool isSelected,
    int index,
    WalletRechargeProvider provider,
  ) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _tappedIndex = index;
        });
        _rippleController.forward();
      },
      onTapUp: (_) {
        setState(() {
          _tappedIndex = null;
        });
        _rippleController.reverse();
      },
      onTapCancel: () {
        setState(() {
          _tappedIndex = null;
        });
        _rippleController.reverse();
      },
      onTap: () {
        // FIXED: Added deselection functionality
        if (isSelected) {
          // Deselect if already selected
          provider.rechargeAmountController.clear();
          setState(() {
            _selectedIndex = null;
          });
        } else {
          // Select the amount
          provider.selectAmount(amount);
          _animateSelection(index);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()
          ..scale(_tappedIndex == index ? 0.95 : 1.0),
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
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? AppConstants.appPrimaryColor
                : AppConstants.white.withOpacity(0.1),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected) ...[
              BoxShadow(
                color: AppConstants.appPrimaryColor.withOpacity(0.4),
                blurRadius: 15,
                spreadRadius: 2,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: AppConstants.appPrimaryColor.withOpacity(0.2),
                blurRadius: 25,
                spreadRadius: 5,
                offset: const Offset(0, 8),
              ),
            ] else ...[
              BoxShadow(
                color: AppConstants.black.withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ],
        ),
        child: Stack(
          children: [
            // Animated background pattern for selected items
            if (isSelected)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: Alignment.topLeft,
                            radius: _pulseAnimation.value,
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

            // Ripple effect for tap animation
            if (_tappedIndex == index)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: AnimatedBuilder(
                    animation: _rippleAnimation,
                    builder: (context, child) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: Alignment.center,
                            radius: _rippleAnimation.value * 1.5,
                            colors: [
                              AppConstants.appPrimaryColor.withOpacity(0.4),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Currency icon with enhanced styling
                  Container(
                    padding: const EdgeInsets.all(6), // FIXED: Reduced padding
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppConstants.black.withOpacity(0.2)
                          : AppConstants.appPrimaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.currency_rupee,
                      color: isSelected
                          ? AppConstants.black
                          : AppConstants.appPrimaryColor,
                      size: 16, // FIXED: Smaller icon
                    ),
                  ),

                  const SizedBox(height: 4), // FIXED: Reduced spacing
                  // Amount text with enhanced styling
                  CommonTextWidget(
                    text: amount,
                    fontSize: 14, // FIXED: Smaller font
                    fontWeight: FontWeight.w800,
                    color: isSelected ? AppConstants.black : AppConstants.white,
                  ),

                  // Small indicator dot
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    width: 3,
                    height: 3,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppConstants.black.withOpacity(0.6)
                          : AppConstants.appPrimaryColor.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),

            // Selection checkmark or close icon
            Positioned(
              top: 6,
              right: 6,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: isSelected
                    ? Container(
                        key: const ValueKey('selected'),
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: AppConstants.black,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: AppConstants.black.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.close,
                          color: AppConstants.appPrimaryColor,
                          size: 10,
                        ),
                      )
                    : const SizedBox.shrink(key: ValueKey('unselected')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _animateSelection(int index) {
    setState(() {
      _selectedIndex = index;
    });

    _selectionController.forward().then((_) {
      _selectionController.reverse();
    });
  }
}

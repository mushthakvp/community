// lib/features/auth/presentation/widgets/terms_checkbox.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../providers/auth_provider.dart';

class TermsCheckbox extends StatefulWidget {
  final VoidCallback? onTermsPressed;
  final VoidCallback? onPrivacyPressed;

  const TermsCheckbox({super.key, this.onTermsPressed, this.onPrivacyPressed});

  @override
  State<TermsCheckbox> createState() => _TermsCheckboxState();
}

class _TermsCheckboxState extends State<TermsCheckbox>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTapDown: (_) => _animationController.forward(),
                    onTapUp: (_) => _animationController.reverse(),
                    onTapCancel: () => _animationController.reverse(),
                    onTap: () => _toggleTerms(authProvider),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 24,
                      height: 24,
                      margin: const EdgeInsets.only(top: 12),
                      decoration: BoxDecoration(
                        color: authProvider.agreeToTerms
                            ? AppConstants.appPrimaryColor
                            : Colors.transparent,
                        border: Border.all(
                          color: authProvider.agreeToTerms
                              ? AppConstants.appPrimaryColor
                              : AppConstants.white.withOpacity(0.5),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: authProvider.agreeToTerms
                            ? [
                                BoxShadow(
                                  color: AppConstants.appPrimaryColor
                                      .withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: authProvider.agreeToTerms
                          ? const Icon(
                              Icons.check,
                              color: AppConstants.black,
                              size: 16,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _toggleTerms(authProvider),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: RichText(
                          text: TextSpan(
                            text: 'I agree to the ',
                            style: TextStyle(
                              color: AppConstants.white.withOpacity(0.8),
                              fontSize: 14,
                              height: 1.4,
                            ),
                            children: [
                              WidgetSpan(
                                child: GestureDetector(
                                  onTap: widget.onTermsPressed,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 2,
                                      vertical: 1,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: AppConstants.appPrimaryColor
                                              .withOpacity(0.7),
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      'Terms of Service',
                                      style: TextStyle(
                                        color: AppConstants.appPrimaryColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              TextSpan(
                                text: ' and ',
                                style: TextStyle(
                                  color: AppConstants.white.withOpacity(0.8),
                                  fontSize: 14,
                                ),
                              ),

                              // Privacy Policy Link
                              WidgetSpan(
                                child: GestureDetector(
                                  onTap: widget.onPrivacyPressed,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 2,
                                      vertical: 1,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: AppConstants.appPrimaryColor
                                              .withOpacity(0.7),
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      'Privacy Policy',
                                      style: TextStyle(
                                        color: AppConstants.appPrimaryColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              TextSpan(
                                text: ' *',
                                style: TextStyle(
                                  color: Colors.red.withOpacity(0.8),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _toggleTerms(AuthProvider authProvider) {
    authProvider.setAgreeToTerms(!authProvider.agreeToTerms);

    // Add haptic feedback
    HapticFeedback.lightImpact();

    // Animate checkbox
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }
}

// lib/features/auth/presentation/pages/otp_verification_page.dart - FIXED
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:vivera/core/error/failures.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/common/app_bar.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../../../../core/widgets/loading/loading_widget.dart';
import '../providers/auth_provider.dart';

class OtpVerificationPage extends StatefulWidget {
  final String email;
  final bool isLogin;

  const OtpVerificationPage({
    super.key,
    required this.email,
    required this.isLogin,
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final TextEditingController _otpController = TextEditingController();
  bool _isResending = false;
  bool _hasNavigated = false; // Prevent multiple navigations

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      authProvider.clearError();
      authProvider.otpController.text = '';
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: CommonAppBar(
        title: 'Verify OTP',
        showBackButton: true,
        // Custom back button handling to prevent "nothing to pop" error
        leading: IconButton(
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              // If nothing to pop, navigate to login
              context.go(RouteConstants.login);
            }
          },
          icon: const Icon(Icons.arrow_back_ios, color: AppConstants.white),
        ),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          // Handle state changes
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!_hasNavigated) {
              if (authProvider.isAuthenticated) {
                _hasNavigated = true;
                // Clear all previous routes and go to home
                context.go(RouteConstants.home);
              } else if (authProvider.hasError) {
                ErrorHandler.showError(
                  context,
                  ServerFailure(message: authProvider.errorMessage ?? ""),
                );
              }
            }
          });

          // Show loading only when verifying OTP, not when resending
          if (authProvider.isLoading && !_isResending) {
            return const Center(
              child: LoadingWidget(message: 'Verifying OTP...'),
            );
          }

          return _buildOtpForm(authProvider);
        },
      ),
    );
  }

  Widget _buildOtpForm(AuthProvider authProvider) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            _buildHeader(),
            const SizedBox(height: 40),
            _buildOtpInput(authProvider),
            const SizedBox(height: 32),
            _buildVerifyButton(authProvider),
            const SizedBox(height: 24),
            _buildResendSection(authProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        _buildLogo(),
        const SizedBox(height: 20),
        const CommonTextWidget(
          text: 'Verify Your Account',
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppConstants.white,
          align: TextAlign.center,
        ),
        const SizedBox(height: 8),
        CommonTextWidget(
          text: 'We\'ve sent a 6-digit code to\n${widget.email}',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppConstants.white.withOpacity(0.7),
          align: TextAlign.center,
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildOtpInput(AuthProvider authProvider) {
    return Pinput(
      controller: authProvider.otpController,
      length: 6,
      showCursor: true,
      onCompleted: (pin) => _handleOtpComplete(authProvider, pin),
      defaultPinTheme: PinTheme(
        width: 56,
        height: 56,
        textStyle: const TextStyle(
          fontSize: 20,
          color: AppConstants.white,
          fontWeight: FontWeight.w600,
        ),
        decoration: BoxDecoration(
          color: AppConstants.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppConstants.white.withOpacity(0.3)),
        ),
      ),
      focusedPinTheme: PinTheme(
        width: 56,
        height: 56,
        textStyle: const TextStyle(
          fontSize: 20,
          color: AppConstants.white,
          fontWeight: FontWeight.w600,
        ),
        decoration: BoxDecoration(
          color: AppConstants.appPrimaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppConstants.appPrimaryColor, width: 2),
        ),
      ),
      submittedPinTheme: PinTheme(
        width: 56,
        height: 56,
        textStyle: const TextStyle(
          fontSize: 20,
          color: AppConstants.white,
          fontWeight: FontWeight.w600,
        ),
        decoration: BoxDecoration(
          color: AppConstants.appPrimaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppConstants.appPrimaryColor),
        ),
      ),
    );
  }

  Widget _buildVerifyButton(AuthProvider authProvider) {
    return PrimaryButton(
      text: 'Verify OTP',
      onPressed: () => _handleVerifyOtp(authProvider),
      isLoading: authProvider.isLoading && !_isResending,
      height: 56,
    );
  }

  Widget _buildResendSection(AuthProvider authProvider) {
    return Column(
      children: [
        CommonTextWidget(
          text: "Didn't receive the code?",
          fontSize: 14,
          color: AppConstants.white.withOpacity(0.7),
          align: TextAlign.center,
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: _isResending ? null : () => _handleResendOtp(authProvider),
          child: _isResending
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppConstants.appPrimaryColor,
                  ),
                )
              : const CommonTextWidget(
                  text: 'Resend Code',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.appPrimaryColor,
                ),
        ),
      ],
    );
  }

  void _handleOtpComplete(AuthProvider authProvider, String pin) {
    authProvider.otpController.text = pin;
  }

  void _handleVerifyOtp(AuthProvider authProvider) {
    if (authProvider.otpController.text.length == 6) {
      authProvider.verifyOtp(isLogin: widget.isLogin);
    } else {
      ErrorHandler.showError(
        context,
        ValidationFailure(message: 'Please enter a valid 6-digit OTP'),
      );
    }
  }

  Widget _buildLogo() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppConstants.appPrimaryColor.withOpacity(0.1),
        border: Border.all(
          color: AppConstants.appPrimaryColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/animation/vivera-animation.gif',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                color: AppConstants.appPrimaryColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.account_circle,
                size: 60,
                color: AppConstants.appPrimaryColor,
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleResendOtp(AuthProvider authProvider) async {
    setState(() => _isResending = true);

    // Clear OTP field when resending
    authProvider.otpController.clear();

    await authProvider.resendOtp();
    setState(() => _isResending = false);

    if (mounted && !authProvider.hasError) {
      ErrorHandler.showSuccess(context, 'OTP sent successfully');
    }
  }
}

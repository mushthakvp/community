// lib/features/auth/presentation/pages/register_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vivera/core/error/failures.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/common/app_bar.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../../../../core/widgets/inputs/text_field.dart';
import '../../../../core/widgets/loading/loading_widget.dart';
import '../providers/auth_provider.dart';
import '../widgets/gender_selection.dart';
import '../widgets/password_field.dart';
import '../widgets/profile_image_picker.dart';
import '../widgets/terms_checkbox.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().clearError();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: CommonAppBar(
        title: 'Create Account',
        showBackButton: true,
        actions: [
          TextButton(
            onPressed: () => context.go(RouteConstants.login),
            child: const CommonTextWidget(
              text: 'Sign In',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppConstants.appPrimaryColor,
            ),
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          // Handle state changes
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (authProvider.isOtpRequired) {
              context.go(
                '${RouteConstants.otpVerification}?email=${authProvider.emailController.text}&isLogin=false',
              );
            } else if (authProvider.hasError) {
              ErrorHandler.showError(context, authProvider.errorMessage!);
            }
          });

          if (authProvider.isLoading) {
            return const Center(
              child: LoadingWidget(message: 'Creating your account...'),
            );
          }

          return _buildRegisterForm(authProvider);
        },
      ),
    );
  }

  Widget _buildRegisterForm(AuthProvider authProvider) {
    return Column(
      children: [
        // Progress indicator
        _buildProgressIndicator(),
        // Form content
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (page) => setState(() => _currentPage = page),
            children: [
              _buildBasicInfoPage(authProvider),
              _buildPersonalInfoPage(authProvider),
              _buildAccountSetupPage(authProvider),
            ],
          ),
        ),
        // Navigation buttons
        _buildNavigationButtons(authProvider),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: List.generate(3, (index) {
          final isActive = index <= _currentPage;
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
              height: 4,
              decoration: BoxDecoration(
                color: isActive
                    ? AppConstants.appPrimaryColor
                    : AppConstants.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBasicInfoPage(AuthProvider authProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CommonTextWidget(
              text: 'Basic Information',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppConstants.white,
            ),
            const SizedBox(height: 8),
            CommonTextWidget(
              text: 'Let\'s start with the basics',
              fontSize: 16,
              color: AppConstants.white.withOpacity(0.7),
            ),
            const SizedBox(height: 32),
            const ProfileImagePicker(),
            const SizedBox(height: 24),
            CommonTextField(
              controller: authProvider.nameController,
              hintText: 'Full Name',
              prefixIcon: const Icon(
                Icons.person_outline,
                color: AppConstants.white,
              ),
              validator: (value) => Validators.required(value, 'name'),
            ),
            const SizedBox(height: 20),
            CommonTextField(
              controller: authProvider.emailController,
              hintText: 'Email Address',
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(
                Icons.email_outlined,
                color: AppConstants.white,
              ),
              validator: Validators.email,
            ),
            const SizedBox(height: 20),
            CommonTextField(
              controller: authProvider.phoneController,
              hintText: 'Phone Number',
              keyboardType: TextInputType.phone,
              prefixIcon: const Icon(
                Icons.phone_outlined,
                color: AppConstants.white,
              ),
              validator: Validators.phone,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoPage(AuthProvider authProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const CommonTextWidget(
            text: 'Personal Details',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppConstants.white,
          ),
          const SizedBox(height: 8),
          CommonTextWidget(
            text: 'Tell us more about yourself',
            fontSize: 16,
            color: AppConstants.white.withOpacity(0.7),
          ),
          const SizedBox(height: 32),
          const GenderSelection(),
          const SizedBox(height: 24),
          _buildDateOfBirthField(authProvider),
          const SizedBox(height: 20),
          _buildProfessionField(authProvider),
          const SizedBox(height: 20),
          _buildLocationFields(authProvider),
        ],
      ),
    );
  }

  Widget _buildAccountSetupPage(AuthProvider authProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const CommonTextWidget(
            text: 'Secure Your Account',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppConstants.white,
          ),
          const SizedBox(height: 8),
          CommonTextWidget(
            text: 'Create a strong password',
            fontSize: 16,
            color: AppConstants.white.withOpacity(0.7),
          ),
          const SizedBox(height: 32),
          PasswordField(
            controller: authProvider.passwordController,
            hintText: 'Create Password',
            isVisible: authProvider.isPasswordVisible,
            onToggleVisibility: authProvider.togglePasswordVisibility,
            validator: Validators.password,
          ),
          const SizedBox(height: 20),
          PasswordField(
            controller: authProvider.confirmPasswordController,
            hintText: 'Confirm Password',
            isVisible: authProvider.isConfirmPasswordVisible,
            onToggleVisibility: authProvider.toggleConfirmPasswordVisibility,
            validator: (value) => Validators.confirmPassword(
              value,
              authProvider.passwordController.text,
            ),
          ),
          const SizedBox(height: 20),
          CommonTextField(
            controller: authProvider.referralCodeController,
            hintText: 'Referral Code (Optional)',
            prefixIcon: const Icon(
              Icons.card_giftcard_outlined,
              color: AppConstants.white,
            ),
          ),
          const SizedBox(height: 32),
          const TermsCheckbox(),
        ],
      ),
    );
  }

  Widget _buildDateOfBirthField(AuthProvider authProvider) {
    return CommonTextField(
      controller: TextEditingController(
        text: authProvider.selectedDateOfBirth?.toString().split(' ')[0] ?? '',
      ),
      hintText: 'Date of Birth',
      readOnly: true,
      onTap: () => _selectDateOfBirth(authProvider),
      prefixIcon: const Icon(
        Icons.calendar_today_outlined,
        color: AppConstants.white,
      ),
      suffixIcon: const Icon(Icons.arrow_drop_down, color: AppConstants.white),
      validator: (value) => authProvider.selectedDateOfBirth == null
          ? 'Please select your date of birth'
          : null,
    );
  }

  Widget _buildProfessionField(AuthProvider authProvider) {
    return CommonTextField(
      controller: TextEditingController(text: authProvider.selectedProfession),
      hintText: 'Select Profession',
      readOnly: true,
      onTap: () => _showProfessionPicker(authProvider),
      prefixIcon: const Icon(Icons.work_outline, color: AppConstants.white),
      suffixIcon: const Icon(Icons.arrow_drop_down, color: AppConstants.white),
      validator: (value) => authProvider.selectedProfession.isEmpty
          ? 'Please select your profession'
          : null,
    );
  }

  Widget _buildLocationFields(AuthProvider authProvider) {
    return Column(
      children: [
        CommonTextField(
          controller: TextEditingController(text: authProvider.selectedCountry),
          hintText: 'Select Country',
          readOnly: true,
          onTap: () => _showCountryPicker(authProvider),
          prefixIcon: const Icon(Icons.public, color: AppConstants.white),
          suffixIcon: const Icon(
            Icons.arrow_drop_down,
            color: AppConstants.white,
          ),
          validator: (value) => authProvider.selectedCountry.isEmpty
              ? 'Please select your country'
              : null,
        ),
        const SizedBox(height: 20),
        CommonTextField(
          controller: TextEditingController(text: authProvider.selectedState),
          hintText: 'Select State',
          readOnly: true,
          onTap: () => _showStatePicker(authProvider),
          prefixIcon: const Icon(
            Icons.location_on_outlined,
            color: AppConstants.white,
          ),
          suffixIcon: const Icon(
            Icons.arrow_drop_down,
            color: AppConstants.white,
          ),
          validator: (value) => authProvider.selectedState.isEmpty
              ? 'Please select your state'
              : null,
        ),
      ],
    );
  }

  Widget _buildNavigationButtons(AuthProvider authProvider) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          if (_currentPage > 0)
            Expanded(
              child: PrimaryButton(
                text: 'Back',
                onPressed: () => _previousPage(),
                backgroundColor: Colors.transparent,
                borderColor: AppConstants.appPrimaryColor,
                textColor: AppConstants.appPrimaryColor,
                height: 56,
              ),
            ),
          if (_currentPage > 0) const SizedBox(width: 16),
          Expanded(
            child: PrimaryButton(
              text: _currentPage == 2 ? 'Create Account' : 'Next',
              onPressed: () => _currentPage == 2
                  ? _handleRegister(authProvider)
                  : _nextPage(),
              isLoading: authProvider.isLoading,
              height: 56,
            ),
          ),
        ],
      ),
    );
  }

  void _nextPage() {
    if (_validateCurrentPage()) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  bool _validateCurrentPage() {
    // Add validation logic for each page
    return true;
  }

  void _handleRegister(AuthProvider authProvider) {
    if (_formKey.currentState!.validate() && authProvider.agreeToTerms) {
      authProvider.register();
    } else if (!authProvider.agreeToTerms) {
      ErrorHandler.showError(
        context,
        ValidationFailure(
          message: 'Please agree to the terms and conditions',
          code: 400,
        ),
      );
    }
  }

  Future<void> _selectDateOfBirth(AuthProvider authProvider) async {
    final date = await showDatePicker(
      context: context,
      initialDate:
          authProvider.selectedDateOfBirth ??
          DateTime.now().subtract(const Duration(days: 18 * 365)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().subtract(const Duration(days: 13 * 365)),
    );
    if (date != null) {
      authProvider.setDateOfBirth(date);
    }
  }

  void _showProfessionPicker(AuthProvider authProvider) {
    // Implementation for profession picker
  }

  void _showCountryPicker(AuthProvider authProvider) {
    // Implementation for country picker
  }

  void _showStatePicker(AuthProvider authProvider) {
    // Implementation for state picker
  }
}

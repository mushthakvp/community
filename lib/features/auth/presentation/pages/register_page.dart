// lib/features/auth/presentation/pages/register_page.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
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

class _RegisterPageState extends State<RegisterPage>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Animation Controllers
  late AnimationController _slideAnimationController;
  late AnimationController _scaleAnimationController;

  // Data
  List<String> _professions = [];
  List<Map<String, dynamic>> _countries = [];
  List<Map<String, dynamic>> _states = [];
  List<Map<String, dynamic>> _districts = [];

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _loadData();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().clearError();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _slideAnimationController.dispose();
    _scaleAnimationController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      // Load professions
      final professionData = await rootBundle.loadString(
        'assets/data/profession.json',
      );
      final List<dynamic> professionList = json.decode(professionData);

      // Load countries and states
      final stateData = await rootBundle.loadString(
        'assets/data/state_and_district.json',
      );
      final List<dynamic> locationData = json.decode(stateData);

      setState(() {
        _professions = professionList.cast<String>();
        _countries = locationData.cast<Map<String, dynamic>>();
      });
    } catch (e) {
      debugPrint('Error loading data: $e');
    }
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
              ErrorHandler.showError(
                context,
                ServerFailure(message: authProvider.errorMessage ?? ""),
              );
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
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
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
            ProfileImagePicker(
              onImageSelected: (image) {
                authProvider.setProfileImage(image);
              },
            ),
            const SizedBox(height: 24),
            _buildAnimatedField(
              delay: 100,
              child: CommonTextField(
                controller: authProvider.nameController,
                hintText: 'Full Name *',
                prefixIcon: const Icon(
                  Icons.person_outline,
                  color: AppConstants.white,
                ),
                validator: (value) => Validators.required(value, 'name'),
              ),
            ),
            const SizedBox(height: 20),
            _buildAnimatedField(
              delay: 200,
              child: CommonTextField(
                controller: authProvider.emailController,
                hintText: 'Email Address *',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  color: AppConstants.white,
                ),
                validator: Validators.email,
              ),
            ),
            const SizedBox(height: 20),
            _buildAnimatedField(
              delay: 300,
              child: CommonTextField(
                controller: authProvider.phoneController,
                hintText: 'Phone Number *',
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(
                  Icons.phone_outlined,
                  color: AppConstants.white,
                ),
                validator: Validators.phone,
              ),
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
          _buildAnimatedField(delay: 100, child: const GenderSelection()),
          const SizedBox(height: 24),
          _buildAnimatedField(
            delay: 200,
            child: _buildDateOfBirthField(authProvider),
          ),
          const SizedBox(height: 20),
          _buildAnimatedField(
            delay: 300,
            child: _buildProfessionField(authProvider),
          ),
          const SizedBox(height: 20),
          _buildAnimatedField(
            delay: 400,
            child: _buildLocationFields(authProvider),
          ),
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
          _buildAnimatedField(
            delay: 100,
            child: PasswordField(
              controller: authProvider.passwordController,
              hintText: 'Create Password *',
              isVisible: authProvider.isPasswordVisible,
              onToggleVisibility: authProvider.togglePasswordVisibility,
              validator: Validators.password,
            ),
          ),
          const SizedBox(height: 20),
          _buildAnimatedField(
            delay: 200,
            child: PasswordField(
              controller: authProvider.confirmPasswordController,
              hintText: 'Confirm Password *',
              isVisible: authProvider.isConfirmPasswordVisible,
              onToggleVisibility: authProvider.toggleConfirmPasswordVisibility,
              validator: (value) => Validators.confirmPassword(
                value,
                authProvider.passwordController.text,
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildAnimatedField(
            delay: 300,
            child: CommonTextField(
              controller: authProvider.referralCodeController,
              hintText: 'Referral Code (Optional)',
              prefixIcon: const Icon(
                Icons.card_giftcard_outlined,
                color: AppConstants.white,
              ),
            ),
          ),
          const SizedBox(height: 32),
          _buildAnimatedField(
            delay: 400,
            child: TermsCheckbox(
              onTermsPressed: () => _openUrl('https://vivera.com/terms'),
              onPrivacyPressed: () => _openUrl('https://vivera.com/privacy'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedField({required int delay, required Widget child}) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, value, _) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
    );
  }

  Widget _buildDateOfBirthField(AuthProvider authProvider) {
    return CommonTextField(
      controller: TextEditingController(
        text: authProvider.selectedDateOfBirth?.toString().split(' ')[0] ?? '',
      ),
      hintText: 'Date of Birth *',
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
      hintText: 'Select Profession *',
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
          hintText: 'Select Country *',
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
          hintText: 'Select State *',
          readOnly: true,
          onTap: authProvider.selectedCountry.isEmpty
              ? null
              : () => _showStatePicker(authProvider),
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
        if (_districts.isNotEmpty) ...[
          const SizedBox(height: 20),
          CommonTextField(
            controller: TextEditingController(
              text: authProvider.selectedDistrict,
            ),
            hintText: 'Select District (Optional)',
            readOnly: true,
            onTap: () => _showDistrictPicker(authProvider),
            prefixIcon: const Icon(
              Icons.location_city_outlined,
              color: AppConstants.white,
            ),
            suffixIcon: const Icon(
              Icons.arrow_drop_down,
              color: AppConstants.white,
            ),
          ),
        ],
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
    final authProvider = context.read<AuthProvider>();

    switch (_currentPage) {
      case 0:
        return authProvider.nameController.text.trim().isNotEmpty &&
            authProvider.emailController.text.trim().isNotEmpty &&
            authProvider.phoneController.text.trim().isNotEmpty &&
            Validators.email(authProvider.emailController.text) == null &&
            Validators.phone(authProvider.phoneController.text) == null;
      case 1:
        return authProvider.selectedGender.isNotEmpty &&
            authProvider.selectedDateOfBirth != null &&
            authProvider.selectedProfession.isNotEmpty &&
            authProvider.selectedCountry.isNotEmpty &&
            authProvider.selectedState.isNotEmpty;
      case 2:
        return authProvider.passwordController.text.trim().length >= 6 &&
            authProvider.passwordController.text ==
                authProvider.confirmPasswordController.text &&
            authProvider.agreeToTerms;
      default:
        return true;
    }
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
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppConstants.appPrimaryColor,
              onPrimary: AppConstants.black,
              surface: AppConstants.black,
              onSurface: AppConstants.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (date != null) {
      authProvider.setDateOfBirth(date);
    }
  }

  void _showProfessionPicker(AuthProvider authProvider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppConstants.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppConstants.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const CommonTextWidget(
                text: 'Select Profession',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppConstants.white,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _professions.length,
                  itemBuilder: (context, index) {
                    final profession = _professions[index];
                    return ListTile(
                      title: CommonTextWidget(
                        text: profession,
                        fontSize: 16,
                        color: AppConstants.white,
                      ),
                      onTap: () {
                        authProvider.setProfession(profession);
                        Navigator.pop(context);
                      },
                      trailing: authProvider.selectedProfession == profession
                          ? const Icon(
                              Icons.check,
                              color: AppConstants.appPrimaryColor,
                            )
                          : null,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCountryPicker(AuthProvider authProvider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppConstants.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppConstants.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const CommonTextWidget(
                text: 'Select Country',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppConstants.white,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _countries.length,
                  itemBuilder: (context, index) {
                    final country = _countries[index];
                    final countryName = country['country'] as String;
                    return ListTile(
                      title: CommonTextWidget(
                        text: countryName,
                        fontSize: 16,
                        color: AppConstants.white,
                      ),
                      onTap: () {
                        authProvider.setLocation(country: countryName);
                        _loadStatesForCountry(country);
                        Navigator.pop(context);
                      },
                      trailing: authProvider.selectedCountry == countryName
                          ? const Icon(
                              Icons.check,
                              color: AppConstants.appPrimaryColor,
                            )
                          : null,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showStatePicker(AuthProvider authProvider) {
    if (_states.isEmpty) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppConstants.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppConstants.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const CommonTextWidget(
                text: 'Select State',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppConstants.white,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _states.length,
                  itemBuilder: (context, index) {
                    final state = _states[index];
                    final stateName = state['state'] as String;
                    return ListTile(
                      title: CommonTextWidget(
                        text: stateName,
                        fontSize: 16,
                        color: AppConstants.white,
                      ),
                      onTap: () {
                        authProvider.setLocation(state: stateName);
                        _loadDistrictsForState(state);
                        Navigator.pop(context);
                      },
                      trailing: authProvider.selectedState == stateName
                          ? const Icon(
                              Icons.check,
                              color: AppConstants.appPrimaryColor,
                            )
                          : null,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDistrictPicker(AuthProvider authProvider) {
    if (_districts.isEmpty) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppConstants.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppConstants.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const CommonTextWidget(
                text: 'Select District',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppConstants.white,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _districts.length,
                  itemBuilder: (context, index) {
                    final district = _districts[index];
                    final districtName = district['name'] as String;
                    return ListTile(
                      title: CommonTextWidget(
                        text: districtName,
                        fontSize: 16,
                        color: AppConstants.white,
                      ),
                      onTap: () {
                        authProvider.setLocation(district: districtName);
                        Navigator.pop(context);
                      },
                      trailing: authProvider.selectedDistrict == districtName
                          ? const Icon(
                              Icons.check,
                              color: AppConstants.appPrimaryColor,
                            )
                          : null,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _loadStatesForCountry(Map<String, dynamic> country) {
    setState(() {
      _states = (country['states'] as List<dynamic>)
          .cast<Map<String, dynamic>>();
      _districts.clear();
    });
  }

  void _loadDistrictsForState(Map<String, dynamic> state) {
    setState(() {
      _districts = (state['district'] as List<dynamic>)
          .cast<Map<String, dynamic>>();
    });
  }

  Future<void> _openUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open link: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

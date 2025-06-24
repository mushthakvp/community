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
  List<String> _filteredProfessions = [];
  List<Map<String, dynamic>> _countries = [];
  List<Map<String, dynamic>> _filteredCountries = [];
  List<Map<String, dynamic>> _states = [];
  List<Map<String, dynamic>> _filteredStates = [];
  List<Map<String, dynamic>> _districts = [];
  List<Map<String, dynamic>> _filteredDistricts = [];

  // Search Controllers
  final TextEditingController _professionSearchController =
      TextEditingController();
  final TextEditingController _countrySearchController =
      TextEditingController();
  final TextEditingController _stateSearchController = TextEditingController();
  final TextEditingController _districtSearchController =
      TextEditingController();

  // Form field keys for validation
  final GlobalKey<FormFieldState> _nameFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _emailFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _phoneFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _dobFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _professionFieldKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _countryFieldKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _stateFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _passwordFieldKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _confirmPasswordFieldKey =
      GlobalKey<FormFieldState>();

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
    _professionSearchController.dispose();
    _countrySearchController.dispose();
    _stateSearchController.dispose();
    _districtSearchController.dispose();
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
        _filteredProfessions = List.from(_professions);
        _countries = locationData.cast<Map<String, dynamic>>();
        _filteredCountries = List.from(_countries);
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
            physics: const NeverScrollableScrollPhysics(), // Disable swipe
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

            CommonTextField(
              key: _nameFieldKey,
              controller: authProvider.nameController,
              hintText: 'Full Name *',
              prefixIcon: const Icon(
                Icons.person_outline,
                color: AppConstants.white,
              ),
              validator: (value) => Validators.required(value, 'name'),
            ),

            const SizedBox(height: 20),
            CommonTextField(
              key: _emailFieldKey,
              controller: authProvider.emailController,
              hintText: 'Email Address *',
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(
                Icons.email_outlined,
                color: AppConstants.white,
              ),
              validator: Validators.email,
            ),
            const SizedBox(height: 20),
            CommonTextField(
              key: _phoneFieldKey,
              controller: authProvider.phoneController,
              hintText: 'Phone Number *',
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
            key: _passwordFieldKey,
            controller: authProvider.passwordController,
            hintText: 'Create Password *',
            isVisible: authProvider.isPasswordVisible,
            onToggleVisibility: authProvider.togglePasswordVisibility,
            validator: Validators.password,
          ),

          const SizedBox(height: 20),
          PasswordField(
            key: _confirmPasswordFieldKey,
            controller: authProvider.confirmPasswordController,
            hintText: 'Confirm Password *',
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
          TermsCheckbox(
            onTermsPressed: () => _openUrl('https://vivera.com/terms'),
            onPrivacyPressed: () => _openUrl('https://vivera.com/privacy'),
          ),
        ],
      ),
    );
  }

  Widget _buildDateOfBirthField(AuthProvider authProvider) {
    return CommonTextField(
      key: _dobFieldKey,
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
      key: _professionFieldKey,
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
          key: _countryFieldKey,
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
          key: _stateFieldKey,
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
      decoration: BoxDecoration(
        color: AppConstants.black,
        border: Border(
          top: BorderSide(color: AppConstants.white.withOpacity(0.1), width: 1),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentPage > 0) ...[
              Expanded(
                flex: 2,
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppConstants.appPrimaryColor,
                      width: 2,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => _previousPage(),
                      child: Container(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.arrow_back_ios,
                              color: AppConstants.appPrimaryColor,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            const CommonTextWidget(
                              text: 'Back',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppConstants.appPrimaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
            Expanded(
              flex: 3,
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [AppConstants.appPrimaryColor, Color(0xFF00D4AA)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppConstants.appPrimaryColor.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: authProvider.isLoading
                        ? null
                        : () => _currentPage == 2
                              ? _handleRegister(authProvider)
                              : _nextPage(authProvider),
                    child: Container(
                      alignment: Alignment.center,
                      child: authProvider.isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppConstants.black,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CommonTextWidget(
                                  text: _currentPage == 2
                                      ? 'Create Account'
                                      : 'Next',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppConstants.black,
                                ),
                                if (_currentPage != 2) ...[
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    color: AppConstants.black,
                                    size: 16,
                                  ),
                                ],
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _nextPage(AuthProvider authProvider) {
    if (_validateCurrentPage(authProvider)) {
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

  bool _validateCurrentPage(AuthProvider authProvider) {
    switch (_currentPage) {
      case 0:
        // Validate basic info page
        bool isValid = true;

        if (_nameFieldKey.currentState?.validate() == false) isValid = false;
        if (_emailFieldKey.currentState?.validate() == false) isValid = false;
        if (_phoneFieldKey.currentState?.validate() == false) isValid = false;

        if (!isValid) {
          _showValidationError('Please fill all required fields correctly.');
        }

        return isValid;

      case 1:
        // Validate personal info page
        bool isValid = true;
        String errorMessage = '';

        if (authProvider.selectedGender.isEmpty) {
          errorMessage = 'Please select your gender';
          isValid = false;
        } else if (authProvider.selectedDateOfBirth == null) {
          errorMessage = 'Please select your date of birth';
          isValid = false;
        } else if (authProvider.selectedProfession.isEmpty) {
          errorMessage = 'Please select your profession';
          isValid = false;
        } else if (authProvider.selectedCountry.isEmpty) {
          errorMessage = 'Please select your country';
          isValid = false;
        } else if (authProvider.selectedState.isEmpty) {
          errorMessage = 'Please select your state';
          isValid = false;
        }

        if (!isValid) {
          _showValidationError(errorMessage);
        }

        return isValid;

      case 2:
        // Validate account setup page
        bool isValid = true;
        String errorMessage = '';

        if (_passwordFieldKey.currentState?.validate() == false) {
          errorMessage = 'Please enter a valid password';
          isValid = false;
        } else if (_confirmPasswordFieldKey.currentState?.validate() == false) {
          errorMessage = 'Passwords do not match';
          isValid = false;
        } else if (!authProvider.agreeToTerms) {
          errorMessage = 'Please agree to the terms and conditions';
          isValid = false;
        }

        if (!isValid) {
          _showValidationError(errorMessage);
        }

        return isValid;

      default:
        return true;
    }
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: CommonTextWidget(
          text: message,
          fontSize: 14,
          color: AppConstants.white,
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _handleRegister(AuthProvider authProvider) {
    if (_validateCurrentPage(authProvider)) {
      authProvider.register();
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
      _dobFieldKey.currentState?.validate();
    }
  }

  void _showProfessionPicker(AuthProvider authProvider) {
    _professionSearchController.clear();
    _filteredProfessions = List.from(_professions);

    showModalBottomSheet(
      context: context,
      backgroundColor: AppConstants.black,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
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
                  // Search field
                  CommonTextField(
                    controller: _professionSearchController,
                    hintText: 'Search profession...',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppConstants.white,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _filteredProfessions = _professions
                            .where(
                              (profession) => profession.toLowerCase().contains(
                                value.toLowerCase(),
                              ),
                            )
                            .toList();
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _filteredProfessions.length,
                      itemBuilder: (context, index) {
                        final profession = _filteredProfessions[index];
                        return ListTile(
                          title: CommonTextWidget(
                            text: profession,
                            fontSize: 16,
                            color: AppConstants.white,
                          ),
                          onTap: () {
                            authProvider.setProfession(profession);
                            _professionFieldKey.currentState?.validate();
                            Navigator.pop(context);
                          },
                          trailing:
                              authProvider.selectedProfession == profession
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
      },
    );
  }

  void _showCountryPicker(AuthProvider authProvider) {
    _countrySearchController.clear();
    _filteredCountries = List.from(_countries);

    showModalBottomSheet(
      context: context,
      backgroundColor: AppConstants.black,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
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
                  // Search field
                  CommonTextField(
                    controller: _countrySearchController,
                    hintText: 'Search country...',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppConstants.white,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _filteredCountries = _countries
                            .where(
                              (country) => (country['country'] as String)
                                  .toLowerCase()
                                  .contains(value.toLowerCase()),
                            )
                            .toList();
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _filteredCountries.length,
                      itemBuilder: (context, index) {
                        final country = _filteredCountries[index];
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
                            _countryFieldKey.currentState?.validate();
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
      },
    );
  }

  void _showStatePicker(AuthProvider authProvider) {
    if (_states.isEmpty) return;

    _stateSearchController.clear();
    _filteredStates = List.from(_states);

    showModalBottomSheet(
      context: context,
      backgroundColor: AppConstants.black,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
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
                  // Search field
                  CommonTextField(
                    controller: _stateSearchController,
                    hintText: 'Search state...',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppConstants.white,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _filteredStates = _states
                            .where(
                              (state) => (state['state'] as String)
                                  .toLowerCase()
                                  .contains(value.toLowerCase()),
                            )
                            .toList();
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _filteredStates.length,
                      itemBuilder: (context, index) {
                        final state = _filteredStates[index];
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
                            _stateFieldKey.currentState?.validate();
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
      },
    );
  }

  void _showDistrictPicker(AuthProvider authProvider) {
    if (_districts.isEmpty) return;

    _districtSearchController.clear();
    _filteredDistricts = List.from(_districts);

    showModalBottomSheet(
      context: context,
      backgroundColor: AppConstants.black,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
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
                  // Search field
                  CommonTextField(
                    controller: _districtSearchController,
                    hintText: 'Search district...',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppConstants.white,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _filteredDistricts = _districts
                            .where(
                              (district) => (district['name'] as String)
                                  .toLowerCase()
                                  .contains(value.toLowerCase()),
                            )
                            .toList();
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _filteredDistricts.length,
                      itemBuilder: (context, index) {
                        final district = _filteredDistricts[index];
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
                          trailing:
                              authProvider.selectedDistrict == districtName
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
      },
    );
  }

  void _loadStatesForCountry(Map<String, dynamic> country) {
    setState(() {
      _states = (country['states'] as List<dynamic>)
          .cast<Map<String, dynamic>>();
      _districts.clear();
      _filteredStates = List.from(_states);
      _filteredDistricts.clear();
    });
  }

  void _loadDistrictsForState(Map<String, dynamic> state) {
    setState(() {
      _districts = (state['district'] as List<dynamic>)
          .cast<Map<String, dynamic>>();
      _filteredDistricts = List.from(_districts);
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

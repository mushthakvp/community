import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/widgets/common/app_bar.dart';
import '../../../../core/widgets/loading/loading_widget.dart';
import '../providers/auth_provider.dart';
import '../widgets/register/register_data_loader.dart';
import '../widgets/register/single_page_form.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isRegistering = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().clearError();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: const CommonAppBar(title: 'Create Account', showBackButton: true),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          _handleAuthStateChanges(authProvider);

          if (authProvider.isLoading && _isRegistering) {
            return const Center(
              child: LoadingWidget(message: 'Creating your account...'),
            );
          }

          return RegisterDataLoader(
            child: SinglePageForm(
              formKey: _formKey,
              onRegisterPressed: () => _handleRegister(authProvider),
              isLoading: authProvider.isLoading && _isRegistering,
            ),
          );
        },
      ),
    );
  }

  void _handleRegister(AuthProvider authProvider) {
    if (_formKey.currentState!.validate()) {
      setState(() => _isRegistering = true);
      authProvider.register();
    }
  }

  void _handleAuthStateChanges(AuthProvider authProvider) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (authProvider.isOtpRequired) {
        setState(() => _isRegistering = false);
        context.go(
          '${RouteConstants.otpVerification}?email=${authProvider.emailController.text}&isLogin=false',
        );
      } else if (authProvider.hasError) {
        setState(() => _isRegistering = false);
        ErrorHandler.showError(
          context,
          ServerFailure(
            message: authProvider.errorMessage ?? "Registration failed",
          ),
        );
      }
    });
  }
}

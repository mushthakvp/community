import 'package:go_router/go_router.dart';

import '../../../features/auth/presentation/pages/login_page.dart';
import '../../../features/auth/presentation/pages/otp_verification_page.dart';
import '../../../features/auth/presentation/pages/register_page.dart';
import '../../constants/route_constants.dart';

class AuthRouter {
  /// Authentication related routes
  static List<RouteBase> get routes => [
    // ==================== LOGIN ROUTE ====================
    GoRoute(
      path: RouteConstants.login,
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),

    // ==================== REGISTER ROUTE ====================
    GoRoute(
      path: RouteConstants.register,
      name: 'register',
      builder: (context, state) => const RegisterPage(),
    ),

    // ==================== OTP VERIFICATION ROUTE ====================
    GoRoute(
      path: RouteConstants.otpVerification,
      name: 'otpVerification',
      builder: (context, state) {
        final queryParams = state.uri.queryParameters;
        return OtpVerificationPage(
          email: queryParams['email'] ?? '',
          isLogin: queryParams['isLogin'] == 'true',
        );
      },
    ),
  ];

  /// Helper methods for auth navigation
  static const String loginPath = RouteConstants.login;
  static const String registerPath = RouteConstants.register;
  static const String otpVerificationPath = RouteConstants.otpVerification;

  /// Build OTP verification route with parameters
  static String buildOtpRoute({required String email, required bool isLogin}) {
    final encodedEmail = Uri.encodeComponent(email);
    return '$otpVerificationPath?email=$encodedEmail&isLogin=$isLogin';
  }
}

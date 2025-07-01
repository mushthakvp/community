import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/otp_verification_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/coupons/presentation/pages/coupon_home_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/profile/presentation/pages/about_app_page.dart';
import '../../features/profile/presentation/pages/change_password_page.dart';
import '../../features/profile/presentation/pages/contact_us_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/profile/presentation/pages/help_support_page.dart';
import '../../features/profile/presentation/pages/loyalty_points_page.dart';
import '../../features/profile/presentation/pages/notifications_page.dart';
import '../../features/profile/presentation/pages/privacy_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/terms_conditions_page.dart';
import '../../features/promos/presentation/pages/promos_page.dart';
import '../../features/redemption/presentation/pages/redemption_page.dart';
import '../../features/redemption/presentation/pages/wallet_recharge_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../constants/route_constants.dart';
import '../widgets/navigation/bottom_navigation.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>();

  static GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteConstants.splash,
    redirect: _redirect,
    routes: [
      // Splash route
      GoRoute(
        path: RouteConstants.splash,
        builder: (context, state) => const SplashPage(),
      ),

      // Auth routes (without bottom navigation)
      GoRoute(
        path: RouteConstants.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RouteConstants.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: RouteConstants.otpVerification,
        builder: (context, state) => OtpVerificationPage(
          email: state.uri.queryParameters['email'] ?? '',
          isLogin: state.uri.queryParameters['isLogin'] == 'true',
        ),
      ),

      // Standalone pages (without bottom navigation)
      GoRoute(
        path: RouteConstants.coupons,
        builder: (context, state) => const CouponHomePage(),
      ),

      // Redemption standalone pages
      GoRoute(
        path: RouteConstants.walletRecharge,
        builder: (context, state) => const WalletRechargePage(),
      ),

      // Profile standalone pages (without bottom navigation)
      GoRoute(
        path: RouteConstants.editProfile,
        builder: (context, state) => const EditProfilePage(),
      ),
      GoRoute(
        path: RouteConstants.loyaltyPoints,
        builder: (context, state) => const LoyaltyPointsPage(),
      ),
      GoRoute(
        path: RouteConstants.changePassword,
        builder: (context, state) => const ChangePasswordPage(),
      ),
      GoRoute(
        path: RouteConstants.notifications,
        builder: (context, state) => const NotificationsPage(),
      ),
      GoRoute(
        path: RouteConstants.privacy,
        builder: (context, state) => const PrivacyPage(),
      ),
      GoRoute(
        path: RouteConstants.termsConditions,
        builder: (context, state) => const TermsConditionsPage(),
      ),
      GoRoute(
        path: RouteConstants.aboutApp,
        builder: (context, state) => const AboutAppPage(),
      ),
      GoRoute(
        path: RouteConstants.helpSupport,
        builder: (context, state) => const HelpSupportPage(),
      ),
      GoRoute(
        path: RouteConstants.contactUs,
        builder: (context, state) => const ContactUsPage(),
      ),

      // Main app with bottom navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => BottomNavigation(child: child),
        routes: [
          GoRoute(
            path: RouteConstants.home,
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: RouteConstants.promos,
            builder: (context, state) => const PromosPage(),
          ),
          GoRoute(
            path: RouteConstants.redemption,
            builder: (context, state) => const RedemptionPage(),
          ),
          GoRoute(
            path: RouteConstants.profile,
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
    ],
  );

  static String? _redirect(BuildContext context, GoRouterState state) {
    final location = state.uri.toString();

    // Always allow splash screen
    if (location == RouteConstants.splash) {
      return null;
    }

    // Don't redirect during splash initialization
    final authProvider = context.read<AuthProvider>();

    // Allow access to auth routes when not authenticated
    if (!authProvider.isAuthenticated && _isProtectedRoute(location)) {
      return RouteConstants.login;
    }

    // Redirect to home if authenticated user tries to access auth routes
    if (authProvider.isAuthenticated && _isAuthRoute(location)) {
      return RouteConstants.home;
    }

    return null;
  }

  static bool _isProtectedRoute(String location) {
    const protectedRoutes = [
      RouteConstants.home,
      RouteConstants.promos,
      RouteConstants.redemption,
      RouteConstants.walletRecharge,
      RouteConstants.profile,
      RouteConstants.coupons,
      RouteConstants.vizzleHome,
      RouteConstants.createAd,
    ];
    return protectedRoutes.any((route) => location.startsWith(route));
  }

  static bool _isAuthRoute(String location) {
    const authRoutes = [
      RouteConstants.login,
      RouteConstants.register,
      RouteConstants.otpVerification,
    ];
    return authRoutes.any((route) => location.startsWith(route));
  }
}

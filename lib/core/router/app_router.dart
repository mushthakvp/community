import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/otp_verification_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/coupons/presentation/pages/coupon_home_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/promos/presentation/pages/promos_page.dart';
import '../../features/redemption/presentation/pages/redemption_page.dart';
import '../../features/redemption/presentation/pages/wallet_recharge_page.dart';
import '../constants/route_constants.dart';
import '../widgets/navigation/bottom_navigation.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>();

  static GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteConstants.home,
    redirect: _redirect,
    routes: [
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
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
    ],
  );

  static String? _redirect(BuildContext context, GoRouterState state) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final location = state.uri.toString();

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
      '/settings',
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

// Placeholder for settings page
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.go(RouteConstants.profile),
        ),
      ),
      body: const Center(
        child: Text(
          'Settings Page',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}
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
      // Auth Routes
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

      // Main App Shell
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) =>
            BottomNavigationScaffold(child: child),
        routes: [
          GoRoute(
            path: RouteConstants.home,
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: RouteConstants.coupons,
            builder: (context, state) => const CouponHomePage(),
          ),
          GoRoute(
            path: RouteConstants.profile,
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),

      // Standalone Routes
      // GoRoute(
      //   path: '${RouteConstants.couponDetail}/:id',
      //   builder: (context, state) =>
      //       CouponDetailPage(couponId: state.pathParameters['id']!),
      // ),
    ],
  );

  static String? _redirect(BuildContext context, GoRouterState state) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final location = state.uri.toString();

    // If user is not authenticated and trying to access protected routes
    if (!authProvider.isAuthenticated && _isProtectedRoute(location)) {
      return RouteConstants.login;
    }

    // If user is authenticated and trying to access auth routes
    if (authProvider.isAuthenticated && _isAuthRoute(location)) {
      return RouteConstants.home;
    }

    return null; // No redirect needed
  }

  static bool _isProtectedRoute(String location) {
    const protectedRoutes = [
      RouteConstants.home,
      RouteConstants.coupons,
      RouteConstants.profile,
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

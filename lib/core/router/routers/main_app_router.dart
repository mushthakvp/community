import 'package:go_router/go_router.dart';

import '../../../features/home/presentation/pages/home_page.dart';
import '../../../features/profile/presentation/pages/profile_page.dart';
import '../../../features/promos/presentation/pages/promos_page.dart';
import '../../../features/redemption/presentation/pages/redemption_page.dart';
import '../../../features/splash/presentation/pages/splash_page.dart';
import '../../../features/vizzle/home/presentation/pages/vizzle_home_page.dart';
import '../../constants/route_constants.dart';

class MainAppRouter {
  /// Splash and core app routes
  static List<RouteBase> get routes => [
    // ==================== SPLASH ROUTE ====================
    GoRoute(
      path: RouteConstants.splash,
      name: 'splash',
      builder: (context, state) => const SplashPage(),
    ),
  ];

  /// Shell routes (routes with bottom navigation)
  static List<RouteBase> get shellRoutes => [
    // ==================== HOME ROUTE ====================
    GoRoute(
      path: RouteConstants.home,
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),

    // ==================== PROMOS ROUTE ====================
    GoRoute(
      path: RouteConstants.promos,
      name: 'promos',
      builder: (context, state) => const PromosPage(),
    ),

    // ==================== REDEMPTION ROUTE ====================
    GoRoute(
      path: RouteConstants.redemption,
      name: 'redemption',
      builder: (context, state) => const RedemptionPage(),
    ),

    // ==================== PROFILE ROUTE ====================
    GoRoute(
      path: RouteConstants.profile,
      name: 'profile',
      builder: (context, state) => const ProfilePage(),
    ),

    // ==================== VIZZLE HOME ROUTE ====================
    GoRoute(
      path: RouteConstants.vizzleHome,
      name: 'vizzleHomeShell',
      builder: (context, state) => const VizzleHomePage(),
    ),

    // ==================== VJOB HOME ROUTE ====================
  ];

  /// Route paths constants
  static const String splashPath = RouteConstants.splash;
  static const String homePath = RouteConstants.home;
  static const String promosPath = RouteConstants.promos;
  static const String redemptionPath = RouteConstants.redemption;
  static const String profilePath = RouteConstants.profile;
  static const String vizzleHomePath = RouteConstants.vizzleHome;
}

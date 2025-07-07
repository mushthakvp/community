import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/route_constants.dart';
import '../widgets/navigation/bottom_navigation.dart';
import 'route_helper.dart';
import 'routers/auth_router.dart';
import 'routers/main_app_router.dart';
import 'routers/profile_router.dart';
import 'routers/spin_router.dart';
import 'routers/vhub_router.dart';
import 'routers/vizzle_router.dart';
import 'routers/vjob_router.dart';

class CoreRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>();

  /// Main GoRouter configuration
  static GoRouter get router => GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteConstants.splash,
    redirect: RouteHelper.redirect,
    routes: [
      // ==================== SPLASH ROUTE ====================
      ...MainAppRouter.routes,

      // ==================== AUTH ROUTES ====================
      ...AuthRouter.routes,

      // ==================== MAIN APP WITH BOTTOM NAVIGATION ====================
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => BottomNavigation(child: child),
        routes: MainAppRouter.shellRoutes,
      ),

      // ==================== FEATURE SPECIFIC ROUTES ====================
      ...SpinRouter.routes,
      ...VizzleRouter.routes,
      ...VHubRouter.routes,
      ...VJobRouter.routes,
      ...ProfileRouter.routes,
    ],
  );

  /// Get navigator keys for external access
  static GlobalKey<NavigatorState> get rootNavigatorKey => _rootNavigatorKey;
  static GlobalKey<NavigatorState> get shellNavigatorKey => _shellNavigatorKey;
}

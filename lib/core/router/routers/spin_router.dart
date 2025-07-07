// lib/core/router/routers/spin_router.dart
import 'package:go_router/go_router.dart';

import '../../../features/spin/presentation/pages/daily_spin_page.dart';
import '../../../features/spin/presentation/pages/spin_and_earn_page.dart';
import '../../../features/spin/presentation/pages/spin_history_page.dart';
import '../../constants/route_constants.dart';

class SpinRouter {
  /// Spin game related routes
  static List<RouteBase> get routes => [
    // ==================== DAILY SPIN ROUTE ====================
    GoRoute(
      path: RouteConstants.dailySpin,
      name: 'dailySpin',
      builder: (context, state) => const DailySpinPage(),
    ),

    // ==================== SPIN AND WIN ROUTE ====================
    GoRoute(
      path: RouteConstants.spinAndWin,
      name: 'spinAndWin',
      builder: (context, state) => const SpinAndEarnPage(),
    ),

    // ==================== SPIN HISTORY ROUTE ====================
    GoRoute(
      path: RouteConstants.spinHistory,
      name: 'spinHistory',
      builder: (context, state) => const SpinHistoryPage(),
    ),
  ];

  /// Route paths constants
  static const String dailySpinPath = RouteConstants.dailySpin;
  static const String spinAndWinPath = RouteConstants.spinAndWin;
  static const String spinHistoryPath = RouteConstants.spinHistory;
  static const String spinMainPath = RouteConstants.spinMain;

  /// Route names for named navigation
  static const String dailySpinName = 'dailySpin';
  static const String spinAndWinName = 'spinAndWin';
  static const String spinHistoryName = 'spinHistory';

  /// Navigation helper methods using paths
  static void navigateToDailySpin(context) {
    GoRouter.of(context).push(dailySpinPath);
  }

  static void navigateToSpinAndWin(context) {
    GoRouter.of(context).push(spinAndWinPath);
  }

  static void navigateToSpinHistory(context) {
    GoRouter.of(context).push(spinHistoryPath);
  }

  /// Navigation helper methods using named routes
  static void navigateToDailySpinNamed(context) {
    GoRouter.of(context).pushNamed(dailySpinName);
  }

  static void navigateToSpinAndWinNamed(context) {
    GoRouter.of(context).pushNamed(spinAndWinName);
  }

  static void navigateToSpinHistoryNamed(context) {
    GoRouter.of(context).pushNamed(spinHistoryName);
  }

  /// Check if route is a spin route
  static bool isSpinRoute(String route) {
    return route.startsWith('/spin') ||
        route == dailySpinPath ||
        route == spinAndWinPath ||
        route == spinHistoryPath;
  }

  /// Get spin route category for analytics
  static String getSpinRouteCategory(String route) {
    if (route == dailySpinPath) {
      return 'Daily Spin';
    } else if (route == spinAndWinPath) {
      return 'Spin and Win';
    } else if (route == spinHistoryPath) {
      return 'Spin History';
    } else if (route.startsWith('/spin')) {
      return 'Spin Game';
    }
    return 'Unknown';
  }

  /// Get all spin routes
  static List<String> get allSpinRoutes => [
    dailySpinPath,
    spinAndWinPath,
    spinHistoryPath,
  ];

  /// Get all spin route names
  static List<String> get allSpinRouteNames => [
    dailySpinName,
    spinAndWinName,
    spinHistoryName,
  ];

  /// Spin route information for debugging/logging
  static Map<String, String> get routeInfo => {
    'Daily Spin': dailySpinPath,
    'Spin and Win': spinAndWinPath,
    'Spin History': spinHistoryPath,
  };

  /// Validate if a given route is valid spin route
  static bool isValidSpinRoute(String route) {
    return allSpinRoutes.contains(route);
  }

  /// Get route display name from path
  static String getRouteDisplayName(String path) {
    switch (path) {
      case RouteConstants.dailySpin:
        return 'Daily Spin';
      case RouteConstants.spinAndWin:
        return 'Spin and Win';
      case RouteConstants.spinHistory:
        return 'Spin History';
      default:
        return 'Spin Game';
    }
  }

  /// Get route description for UI
  static String getRouteDescription(String path) {
    switch (path) {
      case RouteConstants.dailySpin:
        return 'Play your daily spin and win rewards';
      case RouteConstants.spinAndWin:
        return 'Spin the wheel and earn amazing prizes';
      case RouteConstants.spinHistory:
        return 'View your spin history and past winnings';
      default:
        return 'Spin games and rewards';
    }
  }

  /// Get route icon data for UI (you can customize these)
  static String getRouteIcon(String path) {
    switch (path) {
      case RouteConstants.dailySpin:
        return 'calendar_today'; // Material icon name
      case RouteConstants.spinAndWin:
        return 'casino'; // Material icon name
      case RouteConstants.spinHistory:
        return 'history'; // Material icon name
      default:
        return 'games'; // Material icon name
    }
  }

  /// Build spin navigation menu items
  static List<Map<String, dynamic>> getSpinMenuItems() {
    return [
      {
        'title': 'Daily Spin',
        'subtitle': 'Play your daily spin',
        'path': dailySpinPath,
        'icon': 'calendar_today',
        'enabled': true,
      },
      {
        'title': 'Spin and Win',
        'subtitle': 'Spin for amazing prizes',
        'path': spinAndWinPath,
        'icon': 'casino',
        'enabled': true,
      },
      {
        'title': 'Spin History',
        'subtitle': 'View your spin history',
        'path': spinHistoryPath,
        'icon': 'history',
        'enabled': true,
      },
    ];
  }

  /// Get breadcrumb for spin routes
  static List<Map<String, String>> getBreadcrumb(String currentPath) {
    final breadcrumbs = <Map<String, String>>[
      {'title': 'Home', 'path': '/home'},
      {'title': 'Games', 'path': '/games'},
    ];

    switch (currentPath) {
      case RouteConstants.dailySpin:
        breadcrumbs.add({'title': 'Daily Spin', 'path': dailySpinPath});
        break;
      case RouteConstants.spinAndWin:
        breadcrumbs.add({'title': 'Spin and Win', 'path': spinAndWinPath});
        break;
      case RouteConstants.spinHistory:
        breadcrumbs.add({'title': 'Spin History', 'path': spinHistoryPath});
        break;
    }

    return breadcrumbs;
  }
}

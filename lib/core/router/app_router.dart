import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core_router.dart';
class AppRouter {
  /// Private constructor to prevent instantiation
  AppRouter._();

  /// Main router instance
  static GoRouter get router => CoreRouter.router;

  /// Navigator keys for external access
  static GlobalKey<NavigatorState> get rootNavigatorKey =>
      CoreRouter.rootNavigatorKey;

  static GlobalKey<NavigatorState> get shellNavigatorKey =>
      CoreRouter.shellNavigatorKey;

  /// Router configuration details
  static String get initialLocation =>
      router.routerDelegate.currentConfiguration.uri.toString();

  /// Check if router can pop
  static bool get canPop => rootNavigatorKey.currentState?.canPop() ?? false;

  /// Go back if possible
  static void pop() {
    if (canPop) {
      rootNavigatorKey.currentState?.pop();
    }
  }

  /// Navigate to a specific route
  static void go(String location) {
    router.go(location);
  }

  /// Push a route onto the stack
  static void push(String location) {
    router.push(location);
  }

  /// Replace the current route
  static void replace(String location) {
    router.replace(location);
  }
}

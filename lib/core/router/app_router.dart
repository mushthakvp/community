import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core_router.dart';

class AppRouter {
  AppRouter._();
  static GoRouter get router => CoreRouter.router;
  static GlobalKey<NavigatorState> get rootNavigatorKey =>
      CoreRouter.rootNavigatorKey;
  static GlobalKey<NavigatorState> get shellNavigatorKey =>
      CoreRouter.shellNavigatorKey;
  static String get initialLocation =>
      router.routerDelegate.currentConfiguration.uri.toString();
  static bool get canPop => rootNavigatorKey.currentState?.canPop() ?? false;

  static void pop() {
    if (canPop) {
      rootNavigatorKey.currentState?.pop();
    }
  }

  static void go(String location) {
    router.go(location);
  }

  static void push(String location) {
    router.push(location);
  }

  static void replace(String location) {
    router.replace(location);
  }
}

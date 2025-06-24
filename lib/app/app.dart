import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_constants.dart';
import '../core/router/app_router.dart';
import '../features/auth/presentation/providers/auth_provider.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().checkAuthStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      routerConfig: AppRouter.router,
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppConstants.black,
      fontFamily: AppConstants.fontFamily,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppConstants.black,
        foregroundColor: AppConstants.black,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}

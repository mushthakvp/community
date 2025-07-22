import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_constants.dart';
import '../core/router/app_router.dart';
import '../features/auth/presentation/providers/auth_provider.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {}
  }

  Future<void> _initializeApp() async {
    try {
      final authProvider = context.read<AuthProvider>();
      await authProvider.checkAuthStatus();
    } catch (e) {
      debugPrint('Error initializing app: $e');
    }
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
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppConstants.white,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: AppConstants.white,
        ),
        surfaceTintColor: AppConstants.black,
        backgroundColor: AppConstants.black,
        foregroundColor: AppConstants.black,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:livera/features/vcart/core/router/v_cart_router_g.dart';

import '../../../../../core/constants/route_constants.dart';
import '../../../cart/presentation/controllers/cart_controller.dart';
import '../../../categories/presentation/controllers/categories_controller.dart';
import '../../../core/constants/vcart_colors.dart';
import '../../../core/di/vcart_dependency_injection.dart';
import '../../../home/presentation/controllers/home_controller.dart';
import '../../../profile/presentation/controllers/profile_controller.dart';
import '../controllers/bottom_nav_controller.dart';

class VCartMainNavigationPage extends StatefulWidget {
  final List<Widget> pages;
  final VoidCallback? onMarketplaceTap;

  const VCartMainNavigationPage({
    super.key,
    required this.pages,
    this.onMarketplaceTap,
  });

  @override
  State<VCartMainNavigationPage> createState() =>
      _VCartMainNavigationPageState();
}

class _VCartMainNavigationPageState extends State<VCartMainNavigationPage>
    with WidgetsBindingObserver {
  VCartBottomNavController? controller;
  bool _isInitializing = true;
  String? _initializationError;

  // Store the original status bar style to restore on dispose
  SystemUiOverlayStyle? _originalStatusBarStyle;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setStatusBarStyle();
    _initializeAsync();
  }

  void _setStatusBarStyle() {
    _originalStatusBarStyle = const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    );
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  void _restoreStatusBarStyle() {
    SystemChrome.setSystemUIOverlayStyle(
      _originalStatusBarStyle ??
          const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
    );
  }

  Future<void> _initializeAsync() async {
    try {
      setState(() {
        _isInitializing = true;
        _initializationError = null;
      });

      debugPrint('🚀 Starting VCart Main Navigation initialization...');

      // Step 1: Ensure core dependencies exist
      await _ensureCoreDependencies();

      // Step 2: Initialize VCart DI
      await _initializeVCartDI();

      // Step 3: Initialize navigation controller
      await _initializeNavigationController();

      // Step 4: Setup system back handler
      _setupSystemBackHandler();

      debugPrint('✅ VCart Main Navigation initialization completed');

      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    } catch (e, stackTrace) {
      debugPrint('❌ VCart Main Navigation initialization failed: $e');
      debugPrint('Stack trace: $stackTrace');

      if (mounted) {
        setState(() {
          _isInitializing = false;
          _initializationError = e.toString();
        });
      }
    }
  }

  Future<void> _ensureCoreDependencies() async {
    // Wait a bit for core dependencies to be available
    int attempts = 0;
    const maxAttempts = 10;

    while (attempts < maxAttempts) {
      if (VCartDI.areCoreDependenciesRegistered()) {
        debugPrint('✅ Core dependencies are available');
        return;
      }

      debugPrint(
        '⏳ Waiting for core dependencies... (attempt ${attempts + 1})',
      );
      await Future.delayed(const Duration(milliseconds: 100));
      attempts++;
    }

    throw Exception(
      'Core dependencies (NetworkInfo, ApiClient) not available after $maxAttempts attempts',
    );
  }

  Future<void> _initializeVCartDI() async {
    if (VCartDI.isInitialized) {
      debugPrint('✅ VCart DI already initialized');
      return;
    }

    if (VCartDI.isInitializing) {
      debugPrint('⏳ VCart DI initialization in progress, waiting...');
      int attempts = 0;
      const maxAttempts = 50; // 5 seconds max

      while (VCartDI.isInitializing && attempts < maxAttempts) {
        await Future.delayed(const Duration(milliseconds: 100));
        attempts++;
      }

      if (VCartDI.isInitialized) {
        debugPrint('✅ VCart DI initialization completed');
        return;
      }

      if (attempts >= maxAttempts) {
        throw Exception('VCart DI initialization timed out');
      }
    }

    debugPrint('🔄 Initializing VCart DI...');
    await VCartDI.init();
    debugPrint('✅ VCart DI initialization completed successfully');
  }

  Future<void> _initializeNavigationController() async {
    try {
      // Ensure navigation controller is available
      controller = await VCartDI.ensureNavigationController();
      debugPrint('✅ Navigation controller initialized successfully');

      // Schedule post-frame callback for initial setup
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controller != null && mounted) {
          controller!.resetToHome();
          VCartRouterClassG.resetNavigationFlags();

          // Pre-load home controller for better performance
          _preloadHomeController();
        }
      });
    } catch (e) {
      throw Exception('Failed to initialize navigation controller: $e');
    }
  }

  void _preloadHomeController() {
    try {
      if (Get.isRegistered<VCartHomeController>()) {
        Get.find<VCartHomeController>();
        debugPrint('✅ Home controller pre-loaded');
      }
    } catch (e) {
      debugPrint('⚠️ Failed to pre-load home controller: $e');
      // Not critical, continue
    }
  }

  void _setupSystemBackHandler() {
    SystemChannels.navigation.setMethodCallHandler((call) async {
      if (call.method == 'routePopped') {
        debugPrint('🔙 Main Navigation: System back detected');
        await _handleSystemBack();
        return true;
      }
      return null;
    });
  }

  Future<void> _handleSystemBack() async {
    if (controller != null) {
      if (controller!.currentIndex != 0) {
        debugPrint('🔙 Not on home tab, switching to home');
        controller!.setCurrentIndex(0);
      } else {
        debugPrint('🔙 On home tab, staying in VCart');
      }
    }
  }

  @override
  void dispose() {
    // Restore the original status bar style before disposing
    _restoreStatusBarStyle();

    WidgetsBinding.instance.removeObserver(this);
    SystemChannels.navigation.setMethodCallHandler(null);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      // Reapply white status bar when returning to this page
      _setStatusBarStyle();

      if (controller != null) {
        controller!.resetToHome();
      }
    }
  }

  void _onTabTapped(int index) {
    // Ensure controllers are available for each tab
    _ensureControllerForTab(index);

    controller?.setCurrentIndex(index);

    if (index == 0) {
      VCartRouterClassG.resetNavigationFlags();
    }
  }

  void _ensureControllerForTab(int index) {
    try {
      switch (index) {
        case 0: // Home
          if (Get.isRegistered<VCartHomeController>()) {
            Get.find<VCartHomeController>();
          }
          break;
        case 1: // Categories
          if (Get.isRegistered<VCartCategoriesController>()) {
            Get.find<VCartCategoriesController>();
          }
          break;
        case 2: // Cart
          if (Get.isRegistered<VCartCartController>()) {
            Get.find<VCartCartController>();
          }
          break;
        case 3: // Profile
          if (Get.isRegistered<VCartProfileController>()) {
            Get.find<VCartProfileController>();
          }
          break;
      }
    } catch (e) {
      debugPrint('⚠️ Failed to ensure controller for tab $index: $e');
      // Continue anyway, the individual pages will handle missing controllers
    }
  }

  void _navigateToMarketplace() {
    // Restore status bar style before navigating away
    _restoreStatusBarStyle();

    if (widget.onMarketplaceTap != null) {
      widget.onMarketplaceTap!();
    } else {
      try {
        context.go(RouteConstants.home);
      } catch (e) {
        // Fallback navigation
        Navigator.of(context).pushReplacementNamed('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading screen while initializing
    if (_isInitializing) {
      return _buildLoadingScreen();
    }

    // Show error screen if initialization failed
    if (_initializationError != null || controller == null) {
      return _buildErrorScreen();
    }

    // Show normal navigation
    return _buildMainNavigation();
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: VCartColors.background,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: VCartColors.primary,
              strokeWidth: 3,
            ),
            SizedBox(height: 16),
            Text(
              'Initializing VCart...',
              style: TextStyle(color: VCartColors.textSecondary, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScreen() {
    return Scaffold(
      backgroundColor: VCartColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: VCartColors.error,
                size: 48,
              ),
              const SizedBox(height: 16),
              const Text(
                'Failed to initialize VCart',
                style: TextStyle(
                  color: VCartColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                _initializationError ?? 'Unknown error occurred',
                style: const TextStyle(
                  color: VCartColors.textSecondary,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _initializeAsync,
                style: ElevatedButton.styleFrom(
                  backgroundColor: VCartColors.primary,
                  foregroundColor: VCartColors.onPrimary,
                ),
                child: const Text('Retry'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: _navigateToMarketplace,
                child: const Text(
                  'Go to Marketplace',
                  style: TextStyle(color: VCartColors.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainNavigation() {
    return GetBuilder<VCartBottomNavController>(
      init: controller,
      builder: (navController) {
        return PopScope(
          canPop: false,
          onPopInvoked: (bool didPop) async {
            if (!didPop) {
              await _handleSystemBack();
            }
          },
          child: Scaffold(
            backgroundColor: VCartColors.background,
            body: IndexedStack(
              index: navController.currentIndex,
              children: widget.pages,
            ),
            floatingActionButton: FloatingActionButton(
              shape: const CircleBorder(),
              onPressed: () {
                debugPrint('🏠 Floating action button pressed - exiting VCart');
                if (context.mounted) {
                  _navigateToMarketplace();
                }
              },
              backgroundColor: VCartColors.primaryOpacity(0.2),
              foregroundColor: VCartColors.onPrimary,
              elevation: 4,
              child: Image.asset(
                'assets/animation/vivera-animation.gif',
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.home, color: VCartColors.primary);
                },
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: _buildBottomNavigationBar(navController),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavigationBar(VCartBottomNavController navController) {
    return BottomAppBar(
      color: VCartColors.surface,
      shape: const CircularNotchedRectangle(),
      notchMargin: 6.0,
      child: SizedBox(
        height: 60,
        child: Obx(() {
          if (navController.isLoading || navController.navItems.isEmpty) {
            return const SizedBox.shrink();
          }

          return BottomNavigationBar(
            currentIndex: navController.currentIndex,
            onTap: _onTabTapped,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: VCartColors.primary,
            unselectedItemColor: VCartColors.textSecondary,
            selectedFontSize: 12,
            unselectedFontSize: 10,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  navController.currentIndex == 0
                      ? Icons.home
                      : Icons.home_outlined,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  navController.currentIndex == 1
                      ? Icons.category
                      : Icons.category_outlined,
                ),
                label: 'Categories',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  navController.currentIndex == 2
                      ? Icons.shopping_cart
                      : Icons.shopping_cart_outlined,
                ),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  navController.currentIndex == 3
                      ? Icons.person
                      : Icons.person_outline,
                ),
                label: 'Profile',
              ),
            ],
          );
        }),
      ),
    );
  }
}

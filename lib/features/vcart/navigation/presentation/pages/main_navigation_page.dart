import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:livera/features/vcart/core/router/v_cart_router_g.dart';

import '../../../../../core/constants/route_constants.dart';
import '../../../cart/presentation/controllers/cart_controller.dart';
import '../../../categories/presentation/controllers/categories_controller.dart';
import '../../../core/bindings/vcart_bindings.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeAsync();
  }

  Future<void> _initializeAsync() async {
    await _ensureDependenciesInitialized();
    await _initializeController();
    _setupSystemBackHandler();

    if (mounted) {
      setState(() {
        _isInitializing = false;
      });
    }
  }

  Future<void> _ensureDependenciesInitialized() async {
    // Check if core dependencies are registered
    if (!VCartDI.areCoreDependenciesRegistered()) {
      debugPrint('⚠️ Core dependencies not found, initializing VCart DI...');
      VCartDI.init();

      // Wait a bit to ensure dependencies are properly registered
      await Future.delayed(const Duration(milliseconds: 100));
    }

    // Ensure navigation controller is registered
    if (!Get.isRegistered<VCartBottomNavController>()) {
      debugPrint('⚠️ Navigation controller not found, re-initializing...');
      VCartDI.init();
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  Future<void> _initializeController() async {
    try {
      // Try to get the controller with a timeout
      await Future.delayed(const Duration(milliseconds: 50));

      if (Get.isRegistered<VCartBottomNavController>()) {
        controller = Get.find<VCartBottomNavController>();
        debugPrint('✅ VCartBottomNavController found successfully');

        // Schedule post-frame callback for initialization
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (controller != null && mounted) {
            controller!.resetToHome();
            VCartRouterClassG.resetNavigationFlags();
            VCartControllerHelper.preloadController<VCartHomeController>();
          }
        });
      } else {
        debugPrint(
          '❌ VCartBottomNavController still not found after initialization',
        );
        // Try one more time with manual initialization
        await _fallbackInitialization();
      }
    } catch (e) {
      debugPrint('❌ Error finding VCartBottomNavController: $e');
      await _fallbackInitialization();
    }
  }

  Future<void> _fallbackInitialization() async {
    try {
      debugPrint('🔄 Attempting fallback initialization...');

      // Force re-initialize the entire DI system
      VCartDI.clearAll();
      await Future.delayed(const Duration(milliseconds: 100));
      VCartDI.init();
      await Future.delayed(const Duration(milliseconds: 200));

      if (Get.isRegistered<VCartBottomNavController>()) {
        controller = Get.find<VCartBottomNavController>();
        debugPrint('✅ Fallback initialization successful');
      } else {
        debugPrint('❌ Fallback initialization failed');
      }
    } catch (e) {
      debugPrint('❌ Fallback initialization error: $e');
    }
  }

  void _setupSystemBackHandler() {
    SystemChannels.navigation.setMethodCallHandler((call) async {
      if (call.method == 'routePopped') {
        debugPrint(
          '🔙 Main Navigation: System back detected via SystemChannels',
        );
        await _handleSystemBack();
        return true;
      }
      return null;
    });
  }

  Future<void> _handleSystemBack() async {
    debugPrint('🔙 Main Navigation: Handle system back');
    if (controller != null) {
      debugPrint('Current tab index: ${controller!.currentIndex}');
      debugPrint('Is in VCart context: ${VCartRouterClassG.isInVCartContext}');
      if (controller!.currentIndex != 0) {
        debugPrint('Not on home tab, switching to home');
        controller!.setCurrentIndex(0);
      } else {
        debugPrint('On home tab, staying in VCart');
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    SystemChannels.navigation.setMethodCallHandler(null);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    debugPrint('🔄 Main Navigation: App lifecycle state changed to $state');
    if (state == AppLifecycleState.resumed && controller != null) {
      controller!.resetToHome();
    }
  }

  void _onTabTapped(int index) {
    switch (index) {
      case 0: // Home
        VCartControllerHelper.ensureController<VCartHomeController>();
        break;
      case 1: // Categories
        VCartControllerHelper.ensureController<VCartCategoriesController>();
        break;
      case 2: // Cart
        VCartControllerHelper.ensureController<VCartCartController>();
        break;
      case 3: // Profile
        VCartControllerHelper.ensureController<VCartProfileController>();
        break;
    }

    controller?.setCurrentIndex(index);
    if (index == 0) {
      debugPrint(
        '🏠 Main Navigation: Home tab tapped, resetting navigation flags',
      );
      VCartRouterClassG.resetNavigationFlags();
    }
  }

  Widget _buildLoadingScreen() {
    return const Scaffold(
      backgroundColor: VCartColors.background,
      body: Center(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: VCartColors.error, size: 48),
            const SizedBox(height: 16),
            const Text(
              'Failed to initialize VCart',
              style: TextStyle(
                color: VCartColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please try again or restart the app',
              style: TextStyle(color: VCartColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isInitializing = true;
                });
                _initializeAsync();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: VCartColors.primary,
                foregroundColor: VCartColors.onPrimary,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show loading screen while initializing
    if (_isInitializing) {
      return _buildLoadingScreen();
    }

    // Show error screen if controller is still null after initialization
    if (controller == null) {
      return _buildErrorScreen();
    }

    return GetBuilder<VCartBottomNavController>(
      init: controller,
      builder: (navController) {
        return PopScope(
          canPop: false,
          onPopInvoked: (bool didPop) async {
            if (!didPop) {
              debugPrint('🔙 Main Navigation: PopScope system back pressed');
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
                debugPrint(
                  '🏠 Main Navigation: Floating action button pressed - exiting VCart',
                );
                if (context.mounted) {
                  try {
                    context.go(RouteConstants.home);
                  } catch (e) {
                    if (widget.onMarketplaceTap != null) {
                      widget.onMarketplaceTap!();
                    }
                  }
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
            bottomNavigationBar: BottomAppBar(
              color: VCartColors.surface,
              shape: const CircularNotchedRectangle(),
              notchMargin: 6.0,
              child: SizedBox(
                height: 60,
                child: Obx(() {
                  if (navController.isLoading ||
                      navController.navItems.isEmpty) {
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
                    selectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
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
            ),
          ),
        );
      },
    );
  }
}

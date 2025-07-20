import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:livera/features/vcart/core/router/v_cart_router_g.dart';

import '../../../../../core/constants/route_constants.dart';
import '../../../core/constants/vcart_colors.dart';
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
  late VCartBottomNavController controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller = Get.find<VCartBottomNavController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.resetToHome();
      VCartRouterClassG.resetNavigationFlags();
    });
    _setupSystemBackHandler();
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
    debugPrint('Current tab index: ${controller.currentIndex}');
    debugPrint('Is in VCart context: ${VCartRouterClassG.isInVCartContext}');
    if (controller.currentIndex != 0) {
      debugPrint('Not on home tab, switching to home');
      controller.setCurrentIndex(0);
    } else {
      debugPrint('On home tab, staying in VCart');
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
    if (state == AppLifecycleState.resumed) {
      controller.resetToHome();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    onTap: (index) {
                      navController.setCurrentIndex(index);
                      if (index == 0) {
                        debugPrint(
                          '🏠 Main Navigation: Home tab tapped, resetting navigation flags',
                        );
                        VCartRouterClassG.resetNavigationFlags();
                      }
                    },
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

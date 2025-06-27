import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_constants.dart';
import '../../constants/route_constants.dart';
import '../common/text_widget.dart';

class BottomNavigation extends StatefulWidget {
  final Widget child;

  const BottomNavigation({super.key, required this.child});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation>
    with TickerProviderStateMixin {
  late AnimationController _fabAnimationController;
  late AnimationController _borderRadiusAnimationController;
  late Animation<double> _fabAnimation;
  late CurvedAnimation _fabCurve;

  @override
  void initState() {
    super.initState();

    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _borderRadiusAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fabCurve = CurvedAnimation(
      parent: _fabAnimationController,
      curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );
    _fabAnimation = Tween<double>(begin: 0, end: 1).animate(_fabCurve);
    _fabAnimationController.forward();
    _borderRadiusAnimationController.forward();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    _borderRadiusAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildFloatingActionButton() {
    return ScaleTransition(
      scale: _fabAnimation,
      child: SizedBox(
        height: 69,
        width: 69,
        child: FloatingActionButton(
          backgroundColor: AppConstants.appPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          onPressed: () => _onSpecialTap(context),
          elevation: 8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 35,
                width: 48,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppConstants.viveraLogo),
                    fit: BoxFit.contain,
                  ),
                ),
                child: const Icon(
                  Icons.apps,
                  color: AppConstants.black,
                  size: 24,
                ),
              ),
              const SizedBox(height: 2),
              const CommonTextWidget(
                fontSize: 10,
                align: TextAlign.center,
                text: "Community",
                fontWeight: FontWeight.w600,
                color: AppConstants.black,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.toString();
    final currentIndex = _getSelectedIndex(currentLocation);

    return AnimatedBottomNavigationBar.builder(
      itemCount: _getBottomNavItems().length,
      tabBuilder: (index, isActive) => _buildTabItem(index, isActive),
      activeIndex: currentIndex,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.sharpEdge,
      onTap: (index) => _onItemTapped(context, index),
      backgroundColor: AppConstants.black,
      elevation: 8,
      height: 80,
      splashColor: AppConstants.appPrimaryColor.withOpacity(0.3),
      splashSpeedInMilliseconds: 300,
      notchMargin: 8,
      leftCornerRadius: 0,
      rightCornerRadius: 0,
      shadow: BoxShadow(
        color: AppConstants.appPrimaryColor.withOpacity(0.2),
        blurRadius: 20,
        spreadRadius: 0,
        offset: const Offset(0, -5),
      ),
    );
  }

  Widget _buildTabItem(int index, bool isActive) {
    final item = _getBottomNavItems()[index];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.all(isActive ? 8 : 6),
            decoration: BoxDecoration(
              color: isActive
                  ? AppConstants.appPrimaryColor.withOpacity(0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isActive
                  ? Border.all(
                      color: AppConstants.appPrimaryColor.withOpacity(0.3),
                    )
                  : null,
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isActive ? item['activeIcon'] : item['icon'],
                key: ValueKey(isActive),
                size: isActive ? 26 : 24,
                color: isActive
                    ? AppConstants.appPrimaryColor
                    : AppConstants.white.withOpacity(0.6),
              ),
            ),
          ),
          const SizedBox(height: 4),
          // Animated label
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: isActive ? 12 : 11,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              color: isActive
                  ? AppConstants.appPrimaryColor
                  : AppConstants.white.withOpacity(0.6),
            ),
            child: Text(item['label'], textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getBottomNavItems() {
    return [
      {
        'icon': Icons.home_outlined,
        'activeIcon': Icons.home,
        'label': 'Home',
        'route': RouteConstants.home,
      },
      {
        'icon': Icons.local_offer_outlined,
        'activeIcon': Icons.local_offer,
        'label': 'Coupons',
        'route': RouteConstants.coupons,
      },
      {
        'icon': Icons.person_outline,
        'activeIcon': Icons.person,
        'label': 'Profile',
        'route': RouteConstants.profile,
      },
      {
        'icon': Icons.more_horiz,
        'activeIcon': Icons.menu,
        'label': 'More',
        'route': RouteConstants.profile,
      },
    ];
  }

  int _getSelectedIndex(String location) {
    final items = _getBottomNavItems();
    for (int i = 0; i < items.length; i++) {
      if (location.startsWith(items[i]['route'])) {
        return i;
      }
    }
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    final items = _getBottomNavItems();
    if (index < items.length) {
      context.go(items[index]['route']);
    }
  }

  void _onSpecialTap(BuildContext context) {
    context.go(RouteConstants.promos);
  }
}

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_constants.dart';
import '../../constants/route_constants.dart';

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

  int _currentIndex = 0;
  String? _lastLocation; // Track last location to prevent unnecessary updates

  // Cache the bottom nav items to prevent recreation
  static const List<Map<String, dynamic>> _bottomNavItems = [
    {
      'icon': Icons.home_outlined,
      'activeIcon': Icons.home,
      'label': 'Home',
      'route': RouteConstants.home,
    },
    {
      'icon': Icons.card_giftcard_outlined,
      'activeIcon': Icons.card_giftcard,
      'label': 'Promos',
      'route': RouteConstants.promos,
    },
    {
      'icon': Icons.account_balance_wallet_outlined,
      'activeIcon': Icons.account_balance_wallet,
      'label': 'Redemption',
      'route': RouteConstants.redemption,
    },
    {
      'icon': Icons.person_outline,
      'activeIcon': Icons.person,
      'label': 'Profile',
      'route': RouteConstants.profile,
    },
  ];

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateIndexFromLocation();
  }

  void _updateIndexFromLocation() {
    try {
      final currentLocation = GoRouterState.of(context).uri.toString();

      // Only update if location actually changed
      if (_lastLocation == currentLocation) return;

      _lastLocation = currentLocation;
      final newIndex = _getSelectedIndex(currentLocation);

      if (_currentIndex != newIndex) {
        if (mounted) {
          setState(() {
            _currentIndex = newIndex;
          });
        }
      }
    } catch (e) {
      if (_currentIndex != 0 && mounted) {
        setState(() {
          _currentIndex = 0;
        });
      }
    }
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
      backgroundColor: AppConstants.black,
      body: widget.child, // Use the provided child instead of IndexedStack
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildFloatingActionButton() {
    return ScaleTransition(
      scale: _fabAnimation,
      child: SizedBox(
        height: 65,
        width: 65,
        child: FloatingActionButton(
          heroTag: "bottom_navigation_vizzle_fab",
          backgroundColor: AppConstants.appPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          onPressed: () => _onVizzleTap(context),
          elevation: 8,
          child: const Icon(Icons.store, color: AppConstants.white, size: 35),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return AnimatedBottomNavigationBar.builder(
      itemCount: _bottomNavItems.length,
      tabBuilder: (index, isActive) =>
          _buildTabItem(index, _currentIndex == index),
      activeIndex: _currentIndex,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.sharpEdge,
      onTap: (index) => _onItemTapped(context, index),
      backgroundColor: AppConstants.primary,
      elevation: 8,
      height: 78,
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
    final item = _bottomNavItems[index];
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
                  ? AppConstants.black.withOpacity(0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isActive
                  ? Border.all(color: AppConstants.greyDark.withOpacity(0.3))
                  : null,
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isActive ? item['activeIcon'] : item['icon'],
                key: ValueKey(isActive),
                size: isActive ? 24 : 22,
                color: isActive
                    ? AppConstants.black
                    : AppConstants.black.withOpacity(0.6),
              ),
            ),
          ),
          const SizedBox(height: 4),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: isActive ? 12 : 11,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              color: isActive
                  ? AppConstants.black
                  : AppConstants.black.withOpacity(0.6),
            ),
            child: Text(item['label'], textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }

  int _getSelectedIndex(String location) {
    if (location.startsWith('/vizzle')) {
      return 4;
    }

    for (int i = 0; i < _bottomNavItems.length; i++) {
      if (location.startsWith(_bottomNavItems[i]['route'])) {
        return i;
      }
    }
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
      if (index < _bottomNavItems.length) {
        context.go(_bottomNavItems[index]['route']);
      }
    }
  }

  void _onVizzleTap(BuildContext context) {
    if (_currentIndex != 4) {
      setState(() {
        _currentIndex = 4;
      });
      context.go('/vizzle');
    }
  }
}

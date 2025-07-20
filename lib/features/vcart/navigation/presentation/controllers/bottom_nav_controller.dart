import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/error/failures.dart';
import '../../domain/entities/nav_item.dart';
import '../../domain/repositories/navigation_repository.dart';

class VCartBottomNavController extends GetxController {
  final NavigationRepository repository;

  VCartBottomNavController({required this.repository});

  final _currentIndex = 0.obs;
  final _navItems = <NavItem>[].obs;
  final _isLoading = false.obs;

  int get currentIndex => _currentIndex.value;
  List<NavItem> get navItems => _navItems;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    _loadNavigationItems();
    _loadCurrentIndex();
  }

  Future<void> _loadNavigationItems() async {
    _isLoading.value = true;

    final result = await repository.getNavigationItems();
    result.fold((failure) => _handleFailure(failure), (items) {
      _navItems.value = items;
      _isLoading.value = false;
    });
  }

  Future<void> _loadCurrentIndex() async {
    final result = await repository.getCurrentIndex();
    result.fold((failure) => {}, (index) {
      _currentIndex.value = index;
      _updateNavItemsActiveState(index);
    });
  }

  void setCurrentIndex(int index) {
    if (index == _currentIndex.value) return;

    debugPrint('🧭 Navigation: Setting current index to $index');

    _currentIndex.value = index;

    // Save to repository
    repository.setCurrentIndex(index);

    // Update nav items active state
    _updateNavItemsActiveState(index);

    // Update the UI
    update();
  }

  void _updateNavItemsActiveState(int activeIndex) {
    _navItems.value = _navItems.map((item) {
      return item.copyWith(isActive: item.id == activeIndex);
    }).toList();
  }

  // Method to reset to home tab from external calls
  void resetToHome() {
    debugPrint('🏠 Navigation: Resetting to home tab');
    setCurrentIndex(0);
  }

  // Method to force update current index without triggering page change
  void forceUpdateIndex(int index) {
    debugPrint('🧭 Navigation: Force updating index to $index');
    _currentIndex.value = index;
    _updateNavItemsActiveState(index);
    repository.setCurrentIndex(index);
    update();
  }

  // Method to get current tab name for debugging
  String get currentTabName {
    switch (_currentIndex.value) {
      case 0:
        return 'Home';
      case 1:
        return 'Categories';
      case 2:
        return 'Cart';
      case 3:
        return 'Profile';
      default:
        return 'Unknown';
    }
  }

  void _handleFailure(Failure failure) {
    _isLoading.value = false;
    debugPrint('Navigation error: ${failure.message}');
  }

  @override
  void onClose() {
    debugPrint('🧭 Navigation Controller: Closing');
    super.onClose();
  }
}

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

  late PageController pageController;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: currentIndex);
    _loadNavigationItems();
    _loadCurrentIndex();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
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

    _currentIndex.value = index;

    // Update page controller if it has clients
    if (pageController.hasClients) {
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    // Save to repository
    repository.setCurrentIndex(index);

    // Update nav items active state
    _updateNavItemsActiveState(index);
  }

  void onPageChanged(int index) {
    if (index != _currentIndex.value) {
      _currentIndex.value = index;
      repository.setCurrentIndex(index);
      _updateNavItemsActiveState(index);
    }
  }

  void _updateNavItemsActiveState(int activeIndex) {
    _navItems.value = _navItems.map((item) {
      return item.copyWith(isActive: item.id == activeIndex);
    }).toList();
  }

  // Method to reset to home tab from external calls
  void resetToHome() {
    setCurrentIndex(0);
  }

  // Method to force update current index without triggering page change
  void forceUpdateIndex(int index) {
    _currentIndex.value = index;
    _updateNavItemsActiveState(index);
    repository.setCurrentIndex(index);
  }

  void _handleFailure(Failure failure) {
    _isLoading.value = false;
    debugPrint('Navigation error: ${failure.message}');
  }
}

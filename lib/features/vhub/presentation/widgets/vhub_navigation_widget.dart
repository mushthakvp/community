import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../providers/vhub_provider.dart';
import 'create_idea/create_idea_page.dart';
import 'faq/faq_page.dart';
import 'home/vhub_home_content.dart';
import 'ideas/ideas_page.dart';

class VHubNavigationWidget extends StatefulWidget {
  const VHubNavigationWidget({super.key});

  @override
  State<VHubNavigationWidget> createState() => _VHubNavigationWidgetState();
}

class _VHubNavigationWidgetState extends State<VHubNavigationWidget> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const VHubHomeContent(),
    const IdeasPage(),
    const FaqPage(),
    const CreateIdeaPage(),
  ];

  final List<String> _titles = ['Home', 'Ideas', 'FAQ', 'Create Idea'];

  final List<IconData> _icons = [
    Icons.home_outlined,
    Icons.lightbulb_outline,
    Icons.help_outline,
    Icons.add_circle_outline,
  ];

  final List<IconData> _selectedIcons = [
    Icons.home,
    Icons.lightbulb,
    Icons.help,
    Icons.add_circle,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppConstants.black, AppConstants.black.withOpacity(0.8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: AppConstants.appPrimaryColor,
          unselectedItemColor: AppConstants.white.withOpacity(0.6),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w400,
          ),
          items: List.generate(_titles.length, (index) {
            final isSelected = _selectedIndex == index;
            return BottomNavigationBarItem(
              icon: AnimatedContainer(
                duration: AppConstants.defaultAnimationDuration,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppConstants.appPrimaryColor.withOpacity(0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isSelected ? _selectedIcons[index] : _icons[index],
                  size: 24,
                ),
              ),
              label: _titles[index],
            );
          }),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Load data based on selected tab
    switch (index) {
      case 1: // Ideas
        context.read<VHubProvider>().loadIdeas();
        break;
      case 2: // FAQ
        context.read<VHubProvider>().loadFaqs();
        break;
    }
  }
}

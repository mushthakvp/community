// lib/features/vhub/presentation/widgets/vhub_navigation_widget.dart (Updated)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../providers/create_idea_provider.dart';
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

  // Method to navigate to specific tab (can be called from child widgets)
  void navigateToTab(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Load data based on selected tab
    switch (index) {
      case 0: // Home
        context.read<VHubProvider>().loadIdeas(forceRefresh: true);
        break;
      case 1: // Ideas
        context.read<VHubProvider>().loadIdeas();
        break;
      case 2: // FAQ
        context.read<VHubProvider>().loadFaqs();
        break;
      case 3: // Create Idea - don't reset if it's already set up for editing
        // Only reset if not in editing mode
        final createProvider = context.read<CreateIdeaProvider>();
        if (!createProvider.isReapply) {
          createProvider.reset();
        }
        break;
    }
  }

  // Method to navigate to home (can be called from child widgets)
  void navigateToHome() {
    navigateToTab(0);
  }

  List<Widget> get _pages => [
    const VHubHomeContent(),
    IdeasPageWrapper(onNavigateToTab: navigateToTab),
    const FaqPage(),
    CreateIdeaPageWrapper(onNavigateToHome: navigateToHome),
  ];

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final isCreateIdeaPage = _selectedIndex == 3;

    return Scaffold(
      backgroundColor: AppConstants.black,
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar:
          // Hide bottom navigation when keyboard is open and on create idea page
          (isKeyboardOpen && isCreateIdeaPage)
          ? null
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppConstants.black,
                    AppConstants.black.withOpacity(0.8),
                  ],
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
    navigateToTab(index);
  }
}

// Wrapper widget to provide navigation callback to IdeasPage
class IdeasPageWrapper extends StatelessWidget {
  final Function(int) onNavigateToTab;

  const IdeasPageWrapper({super.key, required this.onNavigateToTab});

  @override
  Widget build(BuildContext context) {
    return IdeasPage(onNavigateToTab: onNavigateToTab);
  }
}

// Wrapper widget to provide navigation callback to CreateIdeaPage
class CreateIdeaPageWrapper extends StatelessWidget {
  final VoidCallback onNavigateToHome;

  const CreateIdeaPageWrapper({super.key, required this.onNavigateToHome});

  @override
  Widget build(BuildContext context) {
    return CreateIdeaPage(onNavigateToHome: onNavigateToHome);
  }
}

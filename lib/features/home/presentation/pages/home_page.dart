import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../widgets/dashboard_stats.dart';
import '../widgets/quick_actions.dart';
import '../widgets/recent_activity.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: _buildAppBar(),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return RefreshIndicator(
            onRefresh: () async {
              // Implement refresh logic
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeHeader(authProvider),
                  const SizedBox(height: 24),
                  const DashboardStats(),
                  const SizedBox(height: 24),
                  const QuickActions(),
                  const SizedBox(height: 24),
                  const RecentActivity(),
                  const SizedBox(height: 100), // Bottom padding for navigation
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppConstants.black,
      elevation: 0,
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppConstants.appPrimaryColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.home,
              color: AppConstants.appPrimaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const CommonTextWidget(
            text: 'Community',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppConstants.white,
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            // Navigate to notifications
          },
          icon: Stack(
            children: [
              const Icon(
                Icons.notifications_outlined,
                color: AppConstants.white,
                size: 24,
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildWelcomeHeader(AuthProvider authProvider) {
    final user = authProvider.user;
    final now = DateTime.now();
    final greeting = now.hour < 12
        ? 'Good Morning'
        : now.hour < 17
        ? 'Good Afternoon'
        : 'Good Evening';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppConstants.appPrimaryColor.withOpacity(0.2),
            AppConstants.appPrimaryColor.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppConstants.appPrimaryColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonTextWidget(
                  text: greeting,
                  fontSize: 16,
                  color: AppConstants.white.withOpacity(0.8),
                ),
                const SizedBox(height: 4),
                CommonTextWidget(
                  text: user?.name ?? 'Welcome',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.white,
                ),
                const SizedBox(height: 8),
                CommonTextWidget(
                  text: 'Welcome back to your community',
                  fontSize: 14,
                  color: AppConstants.white.withOpacity(0.7),
                ),
              ],
            ),
          ),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppConstants.appPrimaryColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppConstants.white.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: user?.profileImage != null
                ? ClipOval(
                    child: Image.network(
                      user!.profileImage!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.person,
                        color: AppConstants.black,
                        size: 30,
                      ),
                    ),
                  )
                : const Icon(Icons.person, color: AppConstants.black, size: 30),
          ),
        ],
      ),
    );
  }
}

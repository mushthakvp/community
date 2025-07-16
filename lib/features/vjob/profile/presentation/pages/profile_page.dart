import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/loading/loading_widget.dart';
import '../providers/profile_provider.dart';
import '../widgets/menu_options_widget.dart';
import '../widgets/profile_header_widget.dart';
import '../widgets/stats_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: AppBar(
        backgroundColor: AppConstants.black,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: AppConstants.white),
        ),
        title: const CommonTextWidget(
          text: 'Profile',
          color: AppConstants.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: false,
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(
              child: LoadingWidget(message: 'Loading profile...'),
            );
          }

          if (provider.hasError) {
            return _buildErrorView(provider.errorMessage);
          }

          if (provider.profile == null) {
            return const Center(
              child: CommonTextWidget(
                text: 'No profile data available',
                color: AppConstants.white,
                fontSize: 16,
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.getProfile(),
            color: AppConstants.appPrimaryColor,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  ProfileHeaderWidget(user: provider.profile!.user),
                  const SizedBox(height: 30),
                  StatsWidget(
                    totalApplied: provider.profile!.totalApplied,
                    totalPosted: provider.profile!.totalPosted,
                  ),
                  const SizedBox(height: 30),
                  const CommonTextWidget(
                    text: 'More Options',
                    color: AppConstants.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(height: 20),
                  const MenuOptionsWidget(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.withOpacity(0.7),
            ),
            const SizedBox(height: 16),
            CommonTextWidget(
              text: message,
              fontSize: 16,
              color: AppConstants.white.withOpacity(0.8),
              align: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.read<ProfileProvider>().getProfile(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.appPrimaryColor,
                foregroundColor: AppConstants.black,
              ),
              child: const CommonTextWidget(
                text: 'Retry',
                color: AppConstants.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../providers/splash_provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<SplashProvider>();
      provider.initializeApp().then((_) {
        _navigateToNextScreen();
      });
    });
  }

  void _navigateToNextScreen() {
    final provider = context.read<SplashProvider>();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        if (provider.isAuthenticated) {
          context.go(RouteConstants.home);
        } else {
          context.go(RouteConstants.login);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.appPrimaryColor,
      body: Consumer<SplashProvider>(
        builder: (context, provider, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 140,
                  height: 140,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/animation/vivera-animation.gif',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppConstants.appPrimaryColor,
                          ),
                          child: const Icon(
                            Icons.business,
                            size: 80,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // App Name
                const CommonTextWidget(
                  text: 'LIVERA',
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 3.0,
                ),
                const SizedBox(height: 8),

                // Subtitle
                const CommonTextWidget(
                  text: 'Community Empowerment Platform',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black45,
                  letterSpacing: 1.2,
                  align: TextAlign.center,
                ),
                const SizedBox(height: 60),

                // Loading indicator (only show when loading)
                if (provider.isLoading)
                  Column(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const CommonTextWidget(
                        text: 'Initializing Platform...',
                        fontSize: 12,
                        color: Colors.white70,
                        letterSpacing: 1.0,
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

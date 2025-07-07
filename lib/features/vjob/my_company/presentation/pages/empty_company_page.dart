import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';

class EmptyCompanyPage extends StatelessWidget {
  const EmptyCompanyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: AppBar(
        backgroundColor: AppConstants.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppConstants.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const CommonTextWidget(
          text: 'My Company',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppConstants.white,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppConstants.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.business_outlined,
                  size: 64,
                  color: AppConstants.white,
                ),
              ),
              const SizedBox(height: 24),
              const CommonTextWidget(
                text: 'No Companies Found',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppConstants.white,
                align: TextAlign.center,
              ),
              const SizedBox(height: 12),
              CommonTextWidget(
                text:
                    'No companies have been registered yet.\nPlease register your company to start posting jobs',
                fontSize: 16,
                color: AppConstants.white.withOpacity(0.6),
                align: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  context.pushNamed('/vjob/create-company');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.appPrimaryColor,
                  foregroundColor: AppConstants.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const CommonTextWidget(
                  text: 'Register Company',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

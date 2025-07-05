import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/loading/loading_widget.dart';
import '../../providers/create_idea_provider.dart';
import '../../providers/vhub_provider.dart';
import 'create_idea_navigation.dart';
import 'create_idea_stepper.dart';

class CreateIdeaPage extends StatefulWidget {
  const CreateIdeaPage({super.key});

  @override
  State<CreateIdeaPage> createState() => _CreateIdeaPageState();
}

class _CreateIdeaPageState extends State<CreateIdeaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      body: Consumer2<CreateIdeaProvider, VHubProvider>(
        builder: (context, createProvider, vhubProvider, child) {
          return Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppConstants.black,
                      AppConstants.black.withOpacity(0.8),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CommonTextWidget(
                          text: 'Create Your Idea',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.appPrimaryColor,
                        ),
                        const Spacer(),
                        if (vhubProvider.isCreating)
                          const LoadingWidget(size: 20),
                      ],
                    ),
                    const SizedBox(height: 8),
                    CommonTextWidget(
                      text:
                          'Step ${createProvider.currentStep + 1} of ${createProvider.totalSteps}',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppConstants.white.withOpacity(0.7),
                    ),
                    const SizedBox(height: 16),

                    // Progress Indicator
                    LinearProgressIndicator(
                      value:
                          (createProvider.currentStep + 1) /
                          createProvider.totalSteps,
                      backgroundColor: AppConstants.white.withOpacity(0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppConstants.appPrimaryColor,
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(child: const CreateIdeaStepper()),

              // Navigation
              const CreateIdeaNavigation(),
            ],
          );
        },
      ),
    );
  }
}

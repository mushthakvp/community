import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/buttons/primary_button.dart';
import '../../providers/create_idea_provider.dart';
import '../../providers/vhub_provider.dart';

class CreateIdeaNavigation extends StatelessWidget {
  const CreateIdeaNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<CreateIdeaProvider, VHubProvider>(
      builder: (context, createProvider, vhubProvider, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppConstants.black.withOpacity(0.8), AppConstants.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Row(
            children: [
              // Back Button
              if (createProvider.currentStep > 0)
                Expanded(
                  child: PrimaryButton(
                    text: 'Previous',
                    onPressed: vhubProvider.isCreating
                        ? null
                        : createProvider.previousStep,
                    backgroundColor: Colors.transparent,
                    borderColor: AppConstants.white.withOpacity(0.3),
                    textColor: AppConstants.white,
                    height: 48,
                  ),
                )
              else
                const Spacer(),

              const SizedBox(width: 16),

              // Next/Submit Button
              Expanded(
                flex: 2,
                child: PrimaryButton(
                  text:
                      createProvider.currentStep ==
                          createProvider.totalSteps - 1
                      ? 'Submit Idea'
                      : 'Next',
                  onPressed: _getNextAction(
                    context,
                    createProvider,
                    vhubProvider,
                  ),
                  backgroundColor: AppConstants.appPrimaryColor,
                  textColor: AppConstants.black,
                  height: 48,
                  isLoading: vhubProvider.isCreating,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  VoidCallback? _getNextAction(
    BuildContext context,
    CreateIdeaProvider createProvider,
    VHubProvider vhubProvider,
  ) {
    if (vhubProvider.isCreating) return null;

    return () {
      if (createProvider.validateStep(createProvider.currentStep)) {
        if (createProvider.currentStep == createProvider.totalSteps - 1) {
          // Submit the idea
          final params = createProvider.buildCreateIdeaParams();
          vhubProvider.createIdea(params).then((_) {
            if (!vhubProvider.hasError) {
              createProvider.reset();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Idea submitted successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          });
        } else {
          createProvider.nextStep();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill in all required fields'),
            backgroundColor: Colors.red,
          ),
        );
      }
    };
  }
}

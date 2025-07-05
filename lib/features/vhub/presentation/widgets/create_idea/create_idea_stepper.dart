import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/create_idea_provider.dart';
import 'steps/step_about_project.dart';
import 'steps/step_development.dart';
import 'steps/step_help_needed.dart';
import 'steps/step_market.dart';
import 'steps/step_project_details.dart';
import 'steps/step_reason.dart';
import 'steps/step_signatures.dart';
import 'steps/step_summary.dart';

class CreateIdeaStepper extends StatelessWidget {
  const CreateIdeaStepper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateIdeaProvider>(
      builder: (context, provider, child) {
        switch (provider.currentStep) {
          case 0:
            return const StepProjectDetails();
          case 1:
            return const StepSummary();
          case 2:
            return const StepDevelopment();
          case 3:
            return const StepHelpNeeded();
          case 4:
            return const StepAboutProject();
          case 5:
            return const StepReason();
          case 6:
            return const StepMarket();
          case 7:
            return const StepSignatures();
          default:
            return const StepProjectDetails();
        }
      },
    );
  }
}

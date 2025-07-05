import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/constants/app_constants.dart';
import '../../../../../../core/widgets/common/text_widget.dart';
import '../../../../../../core/widgets/inputs/text_field.dart';
import '../../../providers/create_idea_provider.dart';

class StepAboutProject extends StatelessWidget {
  const StepAboutProject({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateIdeaProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CommonTextWidget(
                text: 'About Your Project',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppConstants.appPrimaryColor,
              ),

              const SizedBox(height: 8),

              CommonTextWidget(
                text: 'Tell us more about your project in detail.',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppConstants.white.withOpacity(0.7),
              ),

              const SizedBox(height: 24),

              CommonTextField(
                controller: provider.aboutController,
                hintText: 'Provide detailed information about your project...',
                maxLines: 10,
                minLines: 6,
              ),

              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.lock_outline,
                      color: Colors.orange,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CommonTextWidget(
                        text:
                            'These details will be kept confidential within V-Hub & Management.',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppConstants.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

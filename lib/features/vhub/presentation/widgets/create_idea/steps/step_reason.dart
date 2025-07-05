import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/constants/app_constants.dart';
import '../../../../../../core/widgets/common/text_widget.dart';
import '../../../../../../core/widgets/inputs/text_field.dart';
import '../../../providers/create_idea_provider.dart';

class StepReason extends StatelessWidget {
  const StepReason({super.key});

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
                text: 'Why You?',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppConstants.appPrimaryColor,
              ),

              const SizedBox(height: 8),

              CommonTextWidget(
                text: 'Why are you the person/team to do this project?',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppConstants.white.withOpacity(0.7),
              ),

              const SizedBox(height: 24),

              CommonTextField(
                controller: provider.reasonController,
                hintText:
                    'Explain why you are uniquely positioned to execute this idea...',
                maxLines: 8,
                minLines: 5,
              ),

              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.purple.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.star_outline,
                          color: Colors.purple,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        CommonTextWidget(
                          text: 'Consider highlighting:',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.purple,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildHighlight('• Relevant experience and expertise'),
                    _buildHighlight('• Educational background'),
                    _buildHighlight('• Previous projects or achievements'),
                    _buildHighlight('• Unique insights or advantages'),
                    _buildHighlight('• Team composition and skills'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHighlight(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: CommonTextWidget(
        text: text,
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: AppConstants.white.withOpacity(0.8),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/constants/app_constants.dart';
import '../../../../../../core/widgets/common/text_widget.dart';
import '../../../../../../core/widgets/inputs/text_field.dart';
import '../../../providers/create_idea_provider.dart';

class StepHelpNeeded extends StatelessWidget {
  const StepHelpNeeded({super.key});

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
                text: 'Help Needed',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppConstants.appPrimaryColor,
              ),

              const SizedBox(height: 8),

              CommonTextWidget(
                text: 'What help do you need to move your idea forward?',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppConstants.white.withOpacity(0.7),
              ),

              const SizedBox(height: 24),

              CommonTextField(
                controller: provider.helpController,
                hintText: 'Describe the help you need...',
                maxLines: 8,
                minLines: 5,
              ),

              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.help_outline,
                          color: Colors.green,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        CommonTextWidget(
                          text: 'Types of help we can provide:',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildHelpType('• Technical expertise and development'),
                    _buildHelpType('• Business strategy and planning'),
                    _buildHelpType('• Market research and validation'),
                    _buildHelpType('• Funding and investment guidance'),
                    _buildHelpType('• Legal and regulatory support'),
                    _buildHelpType('• Mentoring and networking'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHelpType(String text) {
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

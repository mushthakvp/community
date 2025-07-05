import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/constants/app_constants.dart';
import '../../../../../../core/widgets/common/text_widget.dart';
import '../../../../../../core/widgets/inputs/text_field.dart';
import '../../../providers/create_idea_provider.dart';

class StepMarket extends StatelessWidget {
  const StepMarket({super.key});

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
                text: 'Target Market',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppConstants.appPrimaryColor,
              ),

              const SizedBox(height: 8),

              CommonTextWidget(
                text: 'Who will buy your product or service?',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppConstants.white.withOpacity(0.7),
              ),

              const SizedBox(height: 24),

              CommonTextField(
                controller: provider.buyController,
                hintText: 'Describe your target customers and market...',
                maxLines: 8,
                minLines: 5,
              ),

              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.teal.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.groups_outlined,
                          color: Colors.teal,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        CommonTextWidget(
                          text: 'Think about:',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.teal,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildMarketPoint('• Who are your ideal customers?'),
                    _buildMarketPoint(
                      '• What problem does your product solve?',
                    ),
                    _buildMarketPoint('• How big is your target market?'),
                    _buildMarketPoint('• What is your pricing strategy?'),
                    _buildMarketPoint('• How will you reach customers?'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMarketPoint(String text) {
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

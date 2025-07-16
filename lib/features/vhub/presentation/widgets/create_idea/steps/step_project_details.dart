import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/constants/app_constants.dart';
import '../../../../../../core/widgets/common/text_widget.dart';
import '../../../../../../core/widgets/inputs/text_field.dart';
import '../../../providers/create_idea_provider.dart';

class StepProjectDetails extends StatelessWidget {
  const StepProjectDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateIdeaProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Project Name
              const CommonTextWidget(
                text: 'Project Name',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppConstants.white,
              ),
              const SizedBox(height: 8),
              CommonTextField(
                controller: provider.nameController,
                hintText: 'Enter your project name',
                textCapitalization: TextCapitalization.words,
              ),

              const SizedBox(height: 30),

              // Founders Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CommonTextWidget(
                    text: 'Founders',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.white,
                  ),
                  GestureDetector(
                    onTap: provider.addFounder,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppConstants.appPrimaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: AppConstants.black,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Founders List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.founderControllers.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 20),
                itemBuilder: (context, index) {
                  final founder = provider.founderControllers[index];
                  return _buildFounderCard(context, founder, index, provider);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFounderCard(
    BuildContext context,
    FounderController founder,
    int index,
    CreateIdeaProvider provider,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CommonTextWidget(
                text: 'Founder ${index + 1}',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppConstants.appPrimaryColor,
              ),
              const Spacer(),
              if (provider.founderControllers.length > 1)
                GestureDetector(
                  onTap: () => provider.removeFounder(index),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(Icons.close, color: Colors.red, size: 16),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Name Field
          const CommonTextWidget(
            text: 'Name',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppConstants.white,
          ),
          const SizedBox(height: 6),
          CommonTextField(
            controller: founder.nameController,
            hintText: 'Enter founder name',
            textCapitalization: TextCapitalization.words,
          ),

          const SizedBox(height: 12),

          // Email Field
          const CommonTextWidget(
            text: 'Email',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppConstants.white,
          ),
          const SizedBox(height: 6),
          CommonTextField(
            controller: founder.emailController,
            hintText: 'Enter email address',
            keyboardType: TextInputType.emailAddress,
          ),

          const SizedBox(height: 12),

          // Contact Field
          const CommonTextWidget(
            text: 'Contact',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppConstants.white,
          ),
          const SizedBox(height: 6),
          CommonTextField(
            controller: founder.contactController,
            hintText: 'Enter contact number',
            keyboardType: TextInputType.phone,
          ),

          const SizedBox(height: 12),

          // Affiliation Dropdown
          const CommonTextWidget(
            text: 'Affiliation',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppConstants.white,
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppConstants.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppConstants.white.withOpacity(0.2)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: founder.affiliation.isEmpty ? null : founder.affiliation,
                hint: const CommonTextWidget(
                  text: 'Select affiliation',
                  fontSize: 14,
                  color: AppConstants.white,
                ),
                isExpanded: true,
                dropdownColor: AppConstants.black,
                style: const TextStyle(color: AppConstants.white),
                items: const [
                  DropdownMenuItem(value: 'Student', child: Text('Student')),
                  DropdownMenuItem(value: 'Staff', child: Text('Staff')),
                  DropdownMenuItem(value: 'Alum', child: Text('Alum')),
                  DropdownMenuItem(value: 'None', child: Text('None')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    provider.setFounderAffiliation(index, value);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

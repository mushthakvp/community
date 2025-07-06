import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/create_job_provider.dart';
import 'benefits_selector.dart';
import 'company_selector.dart';
import 'description_input.dart';
import 'education_selector.dart';
import 'job_title_selector.dart';
import 'languages_selector.dart';
import 'location_selector.dart';
import 'position_selector.dart';
import 'responsibilities_input.dart';
import 'salary_input.dart';
import 'schedule_selector.dart';
import 'skills_input.dart';
import 'work_style_selector.dart';

class CreateJobForm extends StatelessWidget {
  const CreateJobForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateJobProvider>(
      builder: (context, provider, child) {
        return Form(
          key: provider.formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: provider.currentStep == 0
                ? _buildProfileInsights(provider)
                : _buildJobDetails(provider),
          ),
        );
      },
    );
  }

  Widget _buildProfileInsights(CreateJobProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const JobTitleSelector(),
        const SizedBox(height: 20),
        const CompanySelector(),
        const SizedBox(height: 20),
        const LocationSelector(),
        const SizedBox(height: 20),
        const WorkStyleSelector(),
        const SizedBox(height: 20),
        const PositionSelector(),
        const SizedBox(height: 16),
        const ScheduleSelector(),
        const SizedBox(height: 16),
        const BenefitsSelector(),
        const SizedBox(height: 16),
        const LanguagesSelector(),
        const SizedBox(height: 20),
        const Divider(color: Colors.grey),
        const SizedBox(height: 20),
        const SalaryInput(),
        const SizedBox(height: 20),
        const EducationSelector(),
        const SizedBox(height: 20),
        const Divider(color: Colors.grey),
        const SizedBox(height: 20),
        const SkillsInput(),
        const SizedBox(height: 100), // Space for bottom button
      ],
    );
  }

  Widget _buildJobDetails(CreateJobProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DescriptionInput(),
        const SizedBox(height: 20),
        const ResponsibilitiesInput(),
        const SizedBox(height: 100), // Space for bottom button
      ],
    );
  }
}

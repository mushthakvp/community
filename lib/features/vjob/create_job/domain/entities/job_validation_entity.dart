import 'package:equatable/equatable.dart';

import 'create_job_entity.dart';

class JobValidationEntity extends Equatable {
  final bool isValid;
  final List<String> errors;
  final Map<String, String> fieldErrors;

  const JobValidationEntity({
    required this.isValid,
    required this.errors,
    required this.fieldErrors,
  });

  factory JobValidationEntity.fromJob(CreateJobEntity job) {
    final errors = <String>[];
    final fieldErrors = <String, String>{};

    // Validate required fields
    if (job.companyId.trim().isEmpty) {
      errors.add('Company is required');
      fieldErrors['companyId'] = 'Company is required';
    }

    if (job.title.trim().isEmpty) {
      errors.add('Job title is required');
      fieldErrors['title'] = 'Job title is required';
    }

    if (job.state.trim().isEmpty) {
      errors.add('State is required');
      fieldErrors['state'] = 'State is required';
    }

    if (job.city.trim().isEmpty) {
      errors.add('City is required');
      fieldErrors['city'] = 'City is required';
    }

    if (job.workStyle.trim().isEmpty) {
      errors.add('Work style is required');
      fieldErrors['workStyle'] = 'Work style is required';
    }

    if (job.description.trim().isEmpty) {
      errors.add('Job description is required');
      fieldErrors['description'] = 'Job description is required';
    } else if (job.description.trim().split(' ').length < 50) {
      errors.add('Description must be at least 50 words');
      fieldErrors['description'] = 'Description must be at least 50 words';
    }

    if (job.position.isEmpty) {
      errors.add('At least one position type is required');
      fieldErrors['position'] = 'At least one position type is required';
    }

    if (job.schedule.isEmpty) {
      errors.add('At least one schedule option is required');
      fieldErrors['schedule'] = 'At least one schedule option is required';
    }

    if (job.benefits.isEmpty) {
      errors.add('At least one benefit is required');
      fieldErrors['benefits'] = 'At least one benefit is required';
    }

    if (job.minimumSalary <= 0) {
      errors.add('Minimum salary must be greater than 0');
      fieldErrors['minimumSalary'] = 'Minimum salary must be greater than 0';
    }

    if (job.education.trim().isEmpty) {
      errors.add('Education requirement is required');
      fieldErrors['education'] = 'Education requirement is required';
    }

    if (job.skills.isEmpty) {
      errors.add('At least one skill is required');
      fieldErrors['skills'] = 'At least one skill is required';
    }

    if (job.languages.isEmpty) {
      errors.add('At least one language is required');
      fieldErrors['languages'] = 'At least one language is required';
    }

    if (job.responsibilities.isEmpty) {
      errors.add('At least one responsibility is required');
      fieldErrors['responsibilities'] =
          'At least one responsibility is required';
    }

    return JobValidationEntity(
      isValid: errors.isEmpty,
      errors: errors,
      fieldErrors: fieldErrors,
    );
  }

  @override
  List<Object?> get props => [isValid, errors, fieldErrors];
}

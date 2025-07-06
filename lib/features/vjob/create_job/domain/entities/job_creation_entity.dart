import 'package:equatable/equatable.dart';

class JobCreationEntity extends Equatable {
  final String companyId;
  final String title;
  final String state;
  final String city;
  final String workStyle;
  final String description;
  final List<String> position;
  final List<String> schedule;
  final List<String> benefits;
  final int minimumSalary;
  final String education;
  final List<String> skills;
  final List<String> languages;
  final List<String> responsibilities;

  const JobCreationEntity({
    required this.companyId,
    required this.title,
    required this.state,
    required this.city,
    required this.workStyle,
    required this.description,
    required this.position,
    required this.schedule,
    required this.benefits,
    required this.minimumSalary,
    required this.education,
    required this.skills,
    required this.languages,
    required this.responsibilities,
  });

  JobCreationEntity copyWith({
    String? companyId,
    String? title,
    String? state,
    String? city,
    String? workStyle,
    String? description,
    List<String>? position,
    List<String>? schedule,
    List<String>? benefits,
    int? minimumSalary,
    String? education,
    List<String>? skills,
    List<String>? languages,
    List<String>? responsibilities,
  }) {
    return JobCreationEntity(
      companyId: companyId ?? this.companyId,
      title: title ?? this.title,
      state: state ?? this.state,
      city: city ?? this.city,
      workStyle: workStyle ?? this.workStyle,
      description: description ?? this.description,
      position: position ?? this.position,
      schedule: schedule ?? this.schedule,
      benefits: benefits ?? this.benefits,
      minimumSalary: minimumSalary ?? this.minimumSalary,
      education: education ?? this.education,
      skills: skills ?? this.skills,
      languages: languages ?? this.languages,
      responsibilities: responsibilities ?? this.responsibilities,
    );
  }

  // Validation methods
  bool get isValid => _validateFields().isEmpty;

  List<String> _validateFields() {
    final errors = <String>[];

    if (companyId.trim().isEmpty) errors.add('Company is required');
    if (title.trim().isEmpty) errors.add('Job title is required');
    if (state.trim().isEmpty) errors.add('State is required');
    if (city.trim().isEmpty) errors.add('City is required');
    if (workStyle.trim().isEmpty) errors.add('Work style is required');
    if (description.trim().isEmpty) errors.add('Job description is required');
    if (description.trim().split(' ').length < 50) {
      errors.add('Description must be at least 50 words');
    }
    if (position.isEmpty) errors.add('At least one position type is required');
    if (schedule.isEmpty) {
      errors.add('At least one schedule option is required');
    }
    if (benefits.isEmpty) errors.add('At least one benefit is required');
    if (minimumSalary <= 0) errors.add('Minimum salary must be greater than 0');
    if (education.trim().isEmpty) {
      errors.add('Education requirement is required');
    }
    if (skills.isEmpty) errors.add('At least one skill is required');
    if (languages.isEmpty) errors.add('At least one language is required');
    if (responsibilities.isEmpty) {
      errors.add('At least one responsibility is required');
    }

    return errors;
  }

  String? get validationError {
    final errors = _validateFields();
    return errors.isNotEmpty ? errors.first : null;
  }

  @override
  List<Object?> get props => [
    companyId,
    title,
    state,
    city,
    workStyle,
    description,
    position,
    schedule,
    benefits,
    minimumSalary,
    education,
    skills,
    languages,
    responsibilities,
  ];

  @override
  String toString() {
    return 'JobCreationEntity(title: $title, companyId: $companyId, workStyle: $workStyle)';
  }
}

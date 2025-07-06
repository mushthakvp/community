import 'package:equatable/equatable.dart';

class CreateJobEntity extends Equatable {
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

  const CreateJobEntity({
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

  CreateJobEntity copyWith({
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
    return CreateJobEntity(
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
}

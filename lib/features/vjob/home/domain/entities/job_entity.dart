import 'package:equatable/equatable.dart';

import 'company_entity.dart';

class JobEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final CompanyEntity company;
  final String state;
  final String city;
  final String workStyle;
  final List<String> position;
  final List<String> schedule;
  final List<String> benefits;
  final int minimumSalary;
  final String education;
  final List<String> skills;
  final List<String> languages;
  final List<String> responsibilities;
  final bool isAccepted;
  final bool isRejected;
  final String? rejectReason;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool? isSaved;
  final int totalApplication;

  const JobEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.company,
    required this.state,
    required this.city,
    required this.workStyle,
    required this.position,
    required this.schedule,
    required this.benefits,
    required this.minimumSalary,
    required this.education,
    required this.skills,
    required this.languages,
    required this.responsibilities,
    this.isAccepted = false,
    this.isRejected = false,
    this.rejectReason,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.isSaved,
    this.totalApplication = 0,
  });

  JobEntity copyWith({
    String? id,
    String? title,
    String? description,
    CompanyEntity? company,
    String? state,
    String? city,
    String? workStyle,
    List<String>? position,
    List<String>? schedule,
    List<String>? benefits,
    int? minimumSalary,
    String? education,
    List<String>? skills,
    List<String>? languages,
    List<String>? responsibilities,
    bool? isAccepted,
    bool? isRejected,
    String? rejectReason,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSaved,
    int? totalApplication,
  }) {
    return JobEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      company: company ?? this.company,
      state: state ?? this.state,
      city: city ?? this.city,
      workStyle: workStyle ?? this.workStyle,
      position: position ?? this.position,
      schedule: schedule ?? this.schedule,
      benefits: benefits ?? this.benefits,
      minimumSalary: minimumSalary ?? this.minimumSalary,
      education: education ?? this.education,
      skills: skills ?? this.skills,
      languages: languages ?? this.languages,
      responsibilities: responsibilities ?? this.responsibilities,
      isAccepted: isAccepted ?? this.isAccepted,
      isRejected: isRejected ?? this.isRejected,
      rejectReason: rejectReason ?? this.rejectReason,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSaved: isSaved ?? this.isSaved,
      totalApplication: totalApplication ?? this.totalApplication,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    company,
    state,
    city,
    workStyle,
    position,
    schedule,
    benefits,
    minimumSalary,
    education,
    skills,
    languages,
    responsibilities,
    isAccepted,
    isRejected,
    rejectReason,
    isActive,
    createdAt,
    updatedAt,
    isSaved,
    totalApplication,
  ];
}

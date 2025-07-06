import 'package:equatable/equatable.dart';
import 'package:livera/features/vjob/domain/entities/company_entity.dart';

class JobEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final CompanyEntity company;
  final String city;
  final String state;
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
  final bool isSaved;
  final int totalApplications;

  const JobEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.company,
    required this.city,
    required this.state,
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
    this.isSaved = false,
    this.totalApplications = 0,
  });

  JobEntity copyWith({
    String? id,
    String? title,
    String? description,
    CompanyEntity? company,
    String? city,
    String? state,
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
    int? totalApplications,
  }) {
    return JobEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      company: company ?? this.company,
      city: city ?? this.city,
      state: state ?? this.state,
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
      totalApplications: totalApplications ?? this.totalApplications,
    );
  }

  String get formattedSalary => '\$$minimumSalary/M';
  String get location => '$city, $state';
  bool get hasValidCompany => company.isValid;
  bool get isValid => id.isNotEmpty && title.isNotEmpty;

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    company,
    city,
    state,
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
    totalApplications,
  ];
}

class LocationEntity extends Equatable {
  final String latitude;
  final String longitude;

  const LocationEntity({required this.latitude, required this.longitude});

  @override
  List<Object?> get props => [latitude, longitude];
}

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String? profileImage;

  const UserEntity({required this.id, required this.name, this.profileImage});

  @override
  List<Object?> get props => [id, name, profileImage];
}

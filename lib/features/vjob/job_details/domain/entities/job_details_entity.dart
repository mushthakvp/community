import 'package:equatable/equatable.dart';

class JobDetailsEntity extends Equatable {
  final String id;
  final String title;
  final String description;
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
  final bool isApplied;
  final bool isSaved;
  final int totalApplication;
  final int totalSave;
  final int totalView;
  final CompanyDetailsEntity company;
  final DateTime createdAt;
  final DateTime updatedAt;

  const JobDetailsEntity({
    required this.id,
    required this.title,
    required this.description,
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
    required this.isApplied,
    required this.isSaved,
    required this.totalApplication,
    required this.totalSave,
    required this.totalView,
    required this.company,
    required this.createdAt,
    required this.updatedAt,
  });

  JobDetailsEntity copyWith({
    String? id,
    String? title,
    String? description,
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
    bool? isApplied,
    bool? isSaved,
    int? totalApplication,
    int? totalSave,
    int? totalView,
    CompanyDetailsEntity? company,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return JobDetailsEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
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
      isApplied: isApplied ?? this.isApplied,
      isSaved: isSaved ?? this.isSaved,
      totalApplication: totalApplication ?? this.totalApplication,
      totalSave: totalSave ?? this.totalSave,
      totalView: totalView ?? this.totalView,
      company: company ?? this.company,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
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
    isApplied,
    isSaved,
    totalApplication,
    totalSave,
    totalView,
    company,
    createdAt,
    updatedAt,
  ];
}

class CompanyDetailsEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String website;
  final String description;
  final String? image;
  final LocationEntity location;

  const CompanyDetailsEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.website,
    required this.description,
    this.image,
    required this.location,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    website,
    description,
    image,
    location,
  ];
}

class LocationEntity extends Equatable {
  final String lat;
  final String lng;

  const LocationEntity({required this.lat, required this.lng});

  @override
  List<Object?> get props => [lat, lng];
}

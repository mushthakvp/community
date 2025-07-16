import 'package:equatable/equatable.dart';

class SearchJobEntity extends Equatable {
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
  final bool isSaved;
  final int totalApplication;
  final SearchCompanyEntity company;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SearchJobEntity({
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
    required this.isSaved,
    required this.totalApplication,
    required this.company,
    required this.createdAt,
    required this.updatedAt,
  });

  SearchJobEntity copyWith({
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
    bool? isSaved,
    int? totalApplication,
    SearchCompanyEntity? company,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SearchJobEntity(
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
      isSaved: isSaved ?? this.isSaved,
      totalApplication: totalApplication ?? this.totalApplication,
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
    isSaved,
    totalApplication,
    company,
    createdAt,
    updatedAt,
  ];
}

class SearchCompanyEntity extends Equatable {
  final String id;
  final String name;
  final String? image;

  const SearchCompanyEntity({required this.id, required this.name, this.image});

  @override
  List<Object?> get props => [id, name, image];
}

class SearchJobsResponseEntity extends Equatable {
  final bool success;
  final String message;
  final List<SearchJobEntity> jobs;
  final int total;
  final int totalPage;

  const SearchJobsResponseEntity({
    required this.success,
    required this.message,
    required this.jobs,
    required this.total,
    required this.totalPage,
  });

  @override
  List<Object?> get props => [success, message, jobs, total, totalPage];
}

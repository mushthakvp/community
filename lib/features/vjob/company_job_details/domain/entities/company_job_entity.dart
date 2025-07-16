import 'package:equatable/equatable.dart';

class CompanyJobEntity extends Equatable {
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
  final bool isRejected;
  final String? rejectReason;
  final int totalView;
  final int totalApplication;
  final int totalSave;
  final CompanyEntity company;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CompanyJobEntity({
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
    required this.isRejected,
    this.rejectReason,
    required this.totalView,
    required this.totalApplication,
    required this.totalSave,
    required this.company,
    required this.createdAt,
    required this.updatedAt,
  });

  CompanyJobEntity copyWith({
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
    bool? isRejected,
    String? rejectReason,
    int? totalView,
    int? totalApplication,
    int? totalSave,
    CompanyEntity? company,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CompanyJobEntity(
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
      isRejected: isRejected ?? this.isRejected,
      rejectReason: rejectReason ?? this.rejectReason,
      totalView: totalView ?? this.totalView,
      totalApplication: totalApplication ?? this.totalApplication,
      totalSave: totalSave ?? this.totalSave,
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
    isRejected,
    rejectReason,
    totalView,
    totalApplication,
    totalSave,
    company,
    createdAt,
    updatedAt,
  ];
}

class CompanyEntity extends Equatable {
  final String id;
  final String name;
  final String? image;

  const CompanyEntity({required this.id, required this.name, this.image});

  CompanyEntity copyWith({String? id, String? name, String? image}) {
    return CompanyEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
    );
  }

  @override
  List<Object?> get props => [id, name, image];
}

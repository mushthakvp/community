import 'package:livera/features/vjob/data/models/company_model.dart';

import '../../domain/entities/job_entity.dart';

class JobModel extends JobEntity {
  const JobModel({
    required super.id,
    required super.title,
    required super.description,
    required super.company,
    required super.city,
    required super.state,
    required super.workStyle,
    required super.position,
    required super.schedule,
    required super.benefits,
    required super.minimumSalary,
    required super.education,
    required super.skills,
    required super.languages,
    required super.responsibilities,
    super.isAccepted,
    super.isRejected,
    super.rejectReason,
    super.isActive,
    required super.createdAt,
    required super.updatedAt,
    super.isSaved,
    super.totalApplications,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      company: CompanyModel.fromJson(json['company'] ?? {}),
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      workStyle: json['workStyle'] ?? '',
      position: List<String>.from(json['position'] ?? []),
      schedule: List<String>.from(json['schedule'] ?? []),
      benefits: List<String>.from(json['benefits'] ?? []),
      minimumSalary: json['minimumSalary'] ?? 0,
      education: json['education'] ?? '',
      skills: List<String>.from(json['skills'] ?? []),
      languages: List<String>.from(json['languages'] ?? []),
      responsibilities: List<String>.from(json['responsibilities'] ?? []),
      isAccepted: json['isAccepted'] ?? false,
      isRejected: json['isRejected'] ?? false,
      rejectReason: json['rejectReason'],
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      isSaved: json['isSaved'] ?? false,
      totalApplications: json['totalApplication'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'company': (company as CompanyModel).toJson(),
      'city': city,
      'state': state,
      'workStyle': workStyle,
      'position': position,
      'schedule': schedule,
      'benefits': benefits,
      'minimumSalary': minimumSalary,
      'education': education,
      'skills': skills,
      'languages': languages,
      'responsibilities': responsibilities,
      'isAccepted': isAccepted,
      'isRejected': isRejected,
      'rejectReason': rejectReason,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isSaved': isSaved,
      'totalApplication': totalApplications,
    };
  }
}

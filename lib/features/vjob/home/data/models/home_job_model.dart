import '../../domain/entities/home_job_entity.dart';

class HomeJobModel extends HomeJobEntity {
  const HomeJobModel({
    required super.id,
    required super.title,
    required super.description,
    required super.state,
    required super.city,
    required super.workStyle,
    required super.position,
    required super.schedule,
    required super.benefits,
    required super.minimumSalary,
    required super.education,
    required super.skills,
    required super.languages,
    required super.responsibilities,
    required super.isSaved,
    required super.totalApplication,
    required super.company,
    required super.createdAt,
    required super.updatedAt,
  });

  factory HomeJobModel.fromJson(Map<String, dynamic> json) {
    return HomeJobModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      workStyle: json['workStyle'] ?? '',
      position: List<String>.from(json['position'] ?? []),
      schedule: List<String>.from(json['schedule'] ?? []),
      benefits: List<String>.from(json['benefits'] ?? []),
      minimumSalary: json['minimumSalary'] ?? 0,
      education: json['education'] ?? '',
      skills: List<String>.from(json['skills'] ?? []),
      languages: List<String>.from(json['languages'] ?? []),
      responsibilities: List<String>.from(json['responsibilities'] ?? []),
      isSaved: json['isSaved'] ?? false,
      totalApplication: json['totalApplication'] ?? 0,
      company: CompanyModel.fromJson(json['company'] ?? {}),
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'state': state,
      'city': city,
      'workStyle': workStyle,
      'position': position,
      'schedule': schedule,
      'benefits': benefits,
      'minimumSalary': minimumSalary,
      'education': education,
      'skills': skills,
      'languages': languages,
      'responsibilities': responsibilities,
      'isSaved': isSaved,
      'totalApplication': totalApplication,
      'company': (company as CompanyModel).toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class CompanyModel extends CompanyEntity {
  const CompanyModel({required super.id, required super.name, super.image});

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'image': image};
  }
}

class JobsResponseModel {
  final bool success;
  final String message;
  final List<HomeJobModel> jobs;
  final int total;
  final int totalPage;

  JobsResponseModel({
    required this.success,
    required this.message,
    required this.jobs,
    required this.total,
    required this.totalPage,
  });

  factory JobsResponseModel.fromJson(Map<String, dynamic> json) {
    return JobsResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      jobs:
          (json['jobs'] as List?)
              ?.map((job) => HomeJobModel.fromJson(job))
              .toList() ??
          [],
      total: json['total'] ?? 0,
      totalPage: json['totalPage'] ?? 0,
    );
  }
}

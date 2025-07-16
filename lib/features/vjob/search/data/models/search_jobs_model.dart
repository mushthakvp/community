import '../../domain/entities/search_job_entity.dart';

class SearchJobModel extends SearchJobEntity {
  const SearchJobModel({
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

  factory SearchJobModel.fromJson(Map<String, dynamic> json) {
    return SearchJobModel(
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
      company: SearchCompanyModel.fromJson(json['company'] ?? {}),
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
      'company': (company as SearchCompanyModel).toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class SearchCompanyModel extends SearchCompanyEntity {
  const SearchCompanyModel({
    required super.id,
    required super.name,
    super.image,
  });

  factory SearchCompanyModel.fromJson(Map<String, dynamic> json) {
    return SearchCompanyModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'image': image};
  }
}

class SearchJobsResponseModel extends SearchJobsResponseEntity {
  const SearchJobsResponseModel({
    required super.success,
    required super.message,
    required super.jobs,
    required super.total,
    required super.totalPage,
  });

  factory SearchJobsResponseModel.fromJson(Map<String, dynamic> json) {
    return SearchJobsResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      jobs:
          (json['jobs'] as List?)
              ?.map((job) => SearchJobModel.fromJson(job))
              .toList() ??
          [],
      total: json['total'] ?? 0,
      totalPage: json['totalPage'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'jobs': jobs.map((job) => (job as SearchJobModel).toJson()).toList(),
      'total': total,
      'totalPage': totalPage,
    };
  }
}

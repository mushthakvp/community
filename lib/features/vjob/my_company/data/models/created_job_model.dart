import '../../domain/entities/created_job_entity.dart';

class CreatedJobModel extends CreatedJobEntity {
  const CreatedJobModel({
    required super.id,
    required super.userId,
    required super.companyId,
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
    required super.isAccepted,
    required super.isRejected,
    super.rejectReason,
    required super.rejectCount,
    required super.reAppliedCount,
    required super.isActive,
    required super.status,
    required super.totalSave,
    required super.totalApply,
    required super.totalView,
    required super.company,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CreatedJobModel.fromJson(Map<String, dynamic> json) {
    return CreatedJobModel(
      id: json['_id'] ?? '',
      userId: json['user'] ?? '',
      companyId: json['company']?['_id'] ?? '',
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
      isAccepted: json['isAccepted'] ?? false,
      isRejected: json['isRejected'] ?? false,
      rejectReason: json['rejectReason'],
      rejectCount: json['rejectCount'] ?? 0,
      reAppliedCount: json['reAppliedCount'] ?? 0,
      isActive: json['isActive'] ?? true,
      status: json['status'] ?? 'Requested',
      totalSave: json['totalSave'] ?? 0,
      totalApply: json['totalApply'] ?? 0,
      totalView: json['totalView'] ?? 0,
      company: JobCompanyModel.fromJson(json['company'] ?? {}),
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
      'user': userId,
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
      'isAccepted': isAccepted,
      'isRejected': isRejected,
      'rejectReason': rejectReason,
      'rejectCount': rejectCount,
      'reAppliedCount': reAppliedCount,
      'isActive': isActive,
      'status': status,
      'totalSave': totalSave,
      'totalApply': totalApply,
      'totalView': totalView,
      'company': (company as JobCompanyModel).toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class JobCompanyModel extends JobCompanyEntity {
  const JobCompanyModel({required super.id, required super.name, super.image});

  factory JobCompanyModel.fromJson(Map<String, dynamic> json) {
    return JobCompanyModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'image': image};
  }
}

class CreatedJobsResponseModel {
  final bool success;
  final String message;
  final List<CreatedJobModel> jobs;
  final int total;
  final int totalPage;

  CreatedJobsResponseModel({
    required this.success,
    required this.message,
    required this.jobs,
    required this.total,
    required this.totalPage,
  });

  factory CreatedJobsResponseModel.fromJson(Map<String, dynamic> json) {
    return CreatedJobsResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      jobs:
          (json['jobs'] as List?)
              ?.map((job) => CreatedJobModel.fromJson(job))
              .toList() ??
          [],
      total: json['total'] ?? 0,
      totalPage: json['totalPage'] ?? 0,
    );
  }
}

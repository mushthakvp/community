import '../../domain/entities/company_job_entity.dart';
import 'company_job_candidate_model.dart';

class CompanyJobModel extends CompanyJobEntity {
  const CompanyJobModel({
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
    required super.isRejected,
    super.rejectReason,
    required super.totalView,
    required super.totalApplication,
    required super.totalSave,
    required super.company,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CompanyJobModel.fromJson(Map<String, dynamic> json) {
    return CompanyJobModel(
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
      isRejected: json['isRejected'] ?? false,
      rejectReason: json['rejectReason'],
      totalView: json['totalView'] ?? 0,
      totalApplication: json['totalApplication'] ?? 0,
      totalSave: json['totalSave'] ?? 0,
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
      'isRejected': isRejected,
      'rejectReason': rejectReason,
      'totalView': totalView,
      'totalApplication': totalApplication,
      'totalSave': totalSave,
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

class JobCandidatesResponseModel {
  final bool success;
  final String message;
  final List<CandidateModel> candidates;
  final int total;
  final int totalPage;

  JobCandidatesResponseModel({
    required this.success,
    required this.message,
    required this.candidates,
    required this.total,
    required this.totalPage,
  });

  factory JobCandidatesResponseModel.fromJson(Map<String, dynamic> json) {
    return JobCandidatesResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      candidates:
          (json['candidates'] as List?)
              ?.map((candidate) => CandidateModel.fromJson(candidate))
              .toList() ??
          [],
      total: json['total'] ?? 0,
      totalPage: json['totalPage'] ?? 0,
    );
  }
}

class JobDetailsResponseModel {
  final bool success;
  final String message;
  final CompanyJobModel job;
  final int totalView;
  final int totalApplication;
  final int totalSave;

  JobDetailsResponseModel({
    required this.success,
    required this.message,
    required this.job,
    required this.totalView,
    required this.totalApplication,
    required this.totalSave,
  });

  factory JobDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return JobDetailsResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      job: CompanyJobModel.fromJson(json['job'] ?? {}),
      totalView: json['totalView'] ?? 0,
      totalApplication: json['totalApplication'] ?? 0,
      totalSave: json['totalSave'] ?? 0,
    );
  }
}

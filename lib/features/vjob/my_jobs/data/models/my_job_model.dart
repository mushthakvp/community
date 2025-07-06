import '../../domain/entities/my_job_entity.dart';
import '../../domain/repositories/my_jobs_repository.dart';

class MyJobModel extends MyJobEntity {
  const MyJobModel({
    required super.id,
    required super.userId,
    required super.jobDetails,
    super.resume,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Create model from JSON response
  factory MyJobModel.fromJson(Map<String, dynamic> json) {
    return MyJobModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      jobDetails: MyJobDetailsModel.fromJson(json['jobId'] ?? {}),
      resume: json['resume'],
      status: _parseStatus(json),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  /// Convert model to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'jobId': (jobDetails as MyJobDetailsModel).toJson(),
      'resume': resume,
      'status': status.value,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create a copy with updated values
  @override
  MyJobModel copyWith({
    String? id,
    String? userId,
    MyJobDetailsEntity? jobDetails,
    String? resume,
    MyJobStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MyJobModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      jobDetails: jobDetails ?? this.jobDetails,
      resume: resume ?? this.resume,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Helper method to parse status from different possible sources
  static MyJobStatus _parseStatus(Map<String, dynamic> json) {
    // Try to get status from direct field
    if (json.containsKey('status')) {
      return MyJobStatusExtension.fromString(json['status']);
    }

    // Fallback to Applied status
    return MyJobStatus.applied;
  }
}

/// Data model for Job Details
class MyJobDetailsModel extends MyJobDetailsEntity {
  const MyJobDetailsModel({
    required super.id,
    required super.title,
    super.description,
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
    required super.isBlocked,
    required super.isActive,
    required super.rejectReasons,
    required super.company,
    required super.createdAt,
    required super.updatedAt,
  });

  factory MyJobDetailsModel.fromJson(Map<String, dynamic> json) {
    return MyJobDetailsModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
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
      isBlocked: json['isBlocked'] ?? false,
      isActive: json['isActive'] ?? true,
      rejectReasons:
          (json['rejectReasons'] as List?)
              ?.map((reason) => RejectReasonModel.fromJson(reason))
              .toList() ??
          [],
      company: CompanyModel.fromJson(json['company'] ?? {}),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
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
      'isAccepted': isAccepted,
      'isRejected': isRejected,
      'rejectReason': rejectReason,
      'rejectCount': rejectCount,
      'reAppliedCount': reAppliedCount,
      'isBlocked': isBlocked,
      'isActive': isActive,
      'rejectReasons': rejectReasons
          .map((reason) => (reason as RejectReasonModel).toJson())
          .toList(),
      'company': (company as CompanyModel).toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

/// Data model for Company
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

/// Data model for Reject Reason
class RejectReasonModel extends RejectReasonEntity {
  const RejectReasonModel({
    required super.reason,
    required super.date,
    required super.id,
  });

  factory RejectReasonModel.fromJson(Map<String, dynamic> json) {
    return RejectReasonModel(
      reason: json['reason'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      id: json['_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'reason': reason, 'date': date.toIso8601String(), '_id': id};
  }
}

/// Response model for API responses
class MyJobsResponseModel {
  final bool success;
  final String message;
  final List<MyJobModel> jobs;
  final int total;
  final int totalPage;

  const MyJobsResponseModel({
    required this.success,
    required this.message,
    required this.jobs,
    required this.total,
    required this.totalPage,
  });

  factory MyJobsResponseModel.fromJson(Map<String, dynamic> json) {
    return MyJobsResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      jobs:
          (json['jobs'] as List?)
              ?.map((job) => MyJobModel.fromJson(job))
              .toList() ??
          [],
      total: json['total'] ?? 0,
      totalPage: json['totalPage'] ?? 0,
    );
  }

  /// Convert to domain result
  MyJobsResult toDomainResult(int currentPage) {
    return MyJobsResult(
      jobs: jobs,
      total: total,
      totalPages: totalPage,
      currentPage: currentPage,
      hasMoreData: currentPage < totalPage,
    );
  }
}

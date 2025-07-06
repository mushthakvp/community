import '../../domain/entities/application_entity.dart';
import 'job_model.dart';

class ApplicationModel extends ApplicationEntity {
  const ApplicationModel({
    required super.id,
    required super.userId,
    required super.job,
    super.resume,
    super.status,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      job: JobModel.fromJson(json['jobId'] ?? {}),
      resume: json['resume'],
      status: _parseApplicationStatus(json['status']),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'jobId': (job as JobModel).toJson(),
      'resume': resume,
      'status': _applicationStatusToString(status),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  static ApplicationStatus _parseApplicationStatus(dynamic status) {
    if (status == null) return ApplicationStatus.pending;

    switch (status.toString().toLowerCase()) {
      case 'accepted':
        return ApplicationStatus.accepted;
      case 'rejected':
        return ApplicationStatus.rejected;
      case 'withdrawn':
        return ApplicationStatus.withdrawn;
      default:
        return ApplicationStatus.pending;
    }
  }

  static String _applicationStatusToString(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.pending:
        return 'pending';
      case ApplicationStatus.accepted:
        return 'accepted';
      case ApplicationStatus.rejected:
        return 'rejected';
      case ApplicationStatus.withdrawn:
        return 'withdrawn';
    }
  }
}

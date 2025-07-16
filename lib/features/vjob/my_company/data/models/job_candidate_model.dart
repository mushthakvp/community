import '../../domain/entities/job_candidate_entity.dart';

class JobCandidateModel extends JobCandidateEntity {
  const JobCandidateModel({
    required super.id,
    required super.user,
    required super.jobId,
    super.resume,
    required super.createdAt,
    required super.updatedAt,
  });

  factory JobCandidateModel.fromJson(Map<String, dynamic> json) {
    return JobCandidateModel(
      id: json['_id'] ?? '',
      user: CandidateUserModel.fromJson(json['userId'] ?? {}),
      jobId: json['jobId'] ?? '',
      resume: json['resume'],
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
      'userId': (user as CandidateUserModel).toJson(),
      'jobId': jobId,
      'resume': resume,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class CandidateUserModel extends CandidateUserEntity {
  const CandidateUserModel({
    required super.id,
    required super.name,
    super.profileImage,
  });

  factory CandidateUserModel.fromJson(Map<String, dynamic> json) {
    return CandidateUserModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'profileImage': profileImage};
  }
}

class JobCandidatesResponseModel {
  final bool success;
  final String message;
  final List<JobCandidateModel> candidates;
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
              ?.map((candidate) => JobCandidateModel.fromJson(candidate))
              .toList() ??
          [],
      total: json['total'] ?? 0,
      totalPage: json['totalPage'] ?? 0,
    );
  }
}

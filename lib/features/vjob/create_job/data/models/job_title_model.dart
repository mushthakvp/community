import '../../domain/entities/job_title_entity.dart';

class JobTitleModel extends JobTitleEntity {
  const JobTitleModel({
    required super.id,
    required super.name,
    required super.createdAt,
    required super.updatedAt,
  });

  factory JobTitleModel.fromJson(Map<String, dynamic> json) {
    return JobTitleModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
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
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class JobTitlesResponseModel {
  final bool success;
  final String message;
  final List<JobTitleModel> jobTitles;

  JobTitlesResponseModel({
    required this.success,
    required this.message,
    required this.jobTitles,
  });

  factory JobTitlesResponseModel.fromJson(Map<String, dynamic> json) {
    return JobTitlesResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      jobTitles:
          (json['jobTitles'] as List?)
              ?.map((title) => JobTitleModel.fromJson(title))
              .toList() ??
          [],
    );
  }
}

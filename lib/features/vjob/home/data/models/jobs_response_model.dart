import 'job_model.dart';

class JobsResponseModel {
  final bool success;
  final String message;
  final List<JobModel> jobs;
  final int total;
  final int totalPage;

  const JobsResponseModel({
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
          (json['jobs'] as List<dynamic>?)
              ?.map((job) => JobModel.fromJson(job))
              .toList() ??
          [],
      total: json['total'] ?? 0,
      totalPage: json['totalPage'] ?? 0,
    );
  }
}

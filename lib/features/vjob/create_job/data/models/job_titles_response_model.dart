import 'job_title_model.dart';

class JobTitlesResponseModel {
  final bool success;
  final String message;
  final List<JobTitleModel> jobTitles;

  const JobTitlesResponseModel({
    required this.success,
    required this.message,
    required this.jobTitles,
  });

  factory JobTitlesResponseModel.fromJson(Map<String, dynamic> json) {
    return JobTitlesResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      jobTitles:
          (json['jobTitles'] as List<dynamic>?)
              ?.map((item) => JobTitleModel.fromJson(item))
              .toList() ??
          [],
    );
  }
}

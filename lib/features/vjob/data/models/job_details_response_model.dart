import 'package:livera/features/vjob/data/models/job_model.dart';

class JobDetailsResponseModel {
  final bool success;
  final String message;
  final JobModel job;
  final bool isApplied;
  final bool isSaved;
  final int totalApplication;
  final int totalSave;
  final int totalView;

  JobDetailsResponseModel({
    required this.success,
    required this.message,
    required this.job,
    required this.isApplied,
    required this.isSaved,
    required this.totalApplication,
    required this.totalSave,
    required this.totalView,
  });

  factory JobDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return JobDetailsResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      job: JobModel.fromJson(json['job'] ?? {}),
      isApplied: json['isApplied'] ?? false,
      isSaved: json['isSaved'] ?? false,
      totalApplication: json['totalApplication'] ?? 0,
      totalSave: json['totalSave'] ?? 0,
      totalView: json['totalView'] ?? 0,
    );
  }
}

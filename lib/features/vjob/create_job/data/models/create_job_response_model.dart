class CreateJobResponseModel {
  final bool success;
  final String message;
  final String? jobId;

  const CreateJobResponseModel({
    required this.success,
    required this.message,
    this.jobId,
  });

  factory CreateJobResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateJobResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      jobId: json['jobId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'jobId': jobId};
  }
}

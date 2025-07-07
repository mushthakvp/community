import '../../domain/entities/apply_job_entity.dart';

class ApplyJobModel extends ApplyJobEntity {
  const ApplyJobModel({required super.success, required super.message});

  factory ApplyJobModel.fromJson(Map<String, dynamic> json) {
    return ApplyJobModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message};
  }
}

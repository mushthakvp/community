import '../../domain/entities/spin_result_entity.dart';
import 'spin_option_model.dart';

class SpinResultModel extends SpinResultEntity {
  const SpinResultModel({
    required super.id,
    required super.spinOption,
    required super.timestamp,
    required super.userId,
    required super.spinType,
    super.isSuccess,
    super.errorMessage,
  });

  factory SpinResultModel.fromJson(Map<String, dynamic> json) {
    return SpinResultModel(
      id:
          json['id'] ??
          json['_id'] ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      spinOption: SpinOptionModel.fromJson(
        json['spinOption'] ?? json['selectedOption'] ?? json['option'] ?? {},
      ),
      timestamp: DateTime.parse(
        json['timestamp'] ??
            json['createdAt'] ??
            DateTime.now().toIso8601String(),
      ),
      userId: json['userId'] ?? json['user'] ?? '',
      spinType: json['spinType'] ?? json['type'] ?? 'daily_spin',
      isSuccess: json['isSuccess'] ?? json['success'] ?? true,
      errorMessage: json['errorMessage'] ?? json['message'] ?? json['error'],
    );
  }

  // Factory method to create from a selected option when API doesn't return full result
  factory SpinResultModel.fromSelectedOption({
    required SpinOptionModel selectedOption,
    required String spinType,
    String? userId,
    bool isSuccess = true,
    String? errorMessage,
  }) {
    return SpinResultModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      spinOption: selectedOption.toEntity(),
      timestamp: DateTime.now(),
      userId: userId ?? '',
      spinType: spinType,
      isSuccess: isSuccess,
      errorMessage: errorMessage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'spinOption': SpinOptionModel.fromEntity(spinOption).toJson(),
      'timestamp': timestamp.toIso8601String(),
      'userId': userId,
      'spinType': spinType,
      'isSuccess': isSuccess,
      'errorMessage': errorMessage,
    };
  }

  SpinResultEntity toEntity() {
    return SpinResultEntity(
      id: id,
      spinOption: spinOption,
      timestamp: timestamp,
      userId: userId,
      spinType: spinType,
      isSuccess: isSuccess,
      errorMessage: errorMessage,
    );
  }

  factory SpinResultModel.fromEntity(SpinResultEntity entity) {
    return SpinResultModel(
      id: entity.id,
      spinOption: entity.spinOption,
      timestamp: entity.timestamp,
      userId: entity.userId,
      spinType: entity.spinType,
      isSuccess: entity.isSuccess,
      errorMessage: entity.errorMessage,
    );
  }
}

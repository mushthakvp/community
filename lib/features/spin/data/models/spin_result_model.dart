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
      id: json['id'] ?? json['_id'] ?? '',
      spinOption: SpinOptionModel.fromJson(json['spinOption'] ?? {}),
      timestamp: DateTime.parse(
        json['timestamp'] ??
            json['createdAt'] ??
            DateTime.now().toIso8601String(),
      ),
      userId: json['userId'] ?? '',
      spinType: json['spinType'] ?? 'daily_spin',
      isSuccess: json['isSuccess'] ?? json['success'] ?? true,
      errorMessage: json['errorMessage'] ?? json['message'],
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

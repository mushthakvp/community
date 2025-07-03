import '../../domain/entities/spin_config_entity.dart';
import 'spin_option_model.dart';

class SpinConfigModel extends SpinConfigEntity {
  const SpinConfigModel({
    required super.id,
    required super.type,
    super.maxSpinsPerDay,
    super.requiredPoints,
    super.isActive,
    required super.options,
    super.spinDuration,
    super.soundEnabled,
    super.hapticEnabled,
  });

  factory SpinConfigModel.fromJson(Map<String, dynamic> json) {
    return SpinConfigModel(
      id: json['id'] ?? json['_id'] ?? '',
      type: json['type'] ?? 'daily_spin',
      maxSpinsPerDay: json['maxSpinsPerDay'] ?? 1,
      requiredPoints: json['requiredPoints'] ?? 0,
      isActive: json['isActive'] ?? json['canSpin'] ?? true,
      options:
          (json['options'] as List<dynamic>?)
              ?.map((option) => SpinOptionModel.fromJson(option))
              .toList() ??
          [],
      spinDuration: Duration(seconds: json['spinDuration'] ?? 3),
      soundEnabled: json['soundEnabled'] ?? true,
      hapticEnabled: json['hapticEnabled'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'maxSpinsPerDay': maxSpinsPerDay,
      'requiredPoints': requiredPoints,
      'isActive': isActive,
      'options': options
          .map((option) => SpinOptionModel.fromEntity(option).toJson())
          .toList(),
      'spinDuration': spinDuration.inSeconds,
      'soundEnabled': soundEnabled,
      'hapticEnabled': hapticEnabled,
    };
  }

  SpinConfigEntity toEntity() {
    return SpinConfigEntity(
      id: id,
      type: type,
      maxSpinsPerDay: maxSpinsPerDay,
      requiredPoints: requiredPoints,
      isActive: isActive,
      options: options,
      spinDuration: spinDuration,
      soundEnabled: soundEnabled,
      hapticEnabled: hapticEnabled,
    );
  }

  factory SpinConfigModel.fromEntity(SpinConfigEntity entity) {
    return SpinConfigModel(
      id: entity.id,
      type: entity.type,
      maxSpinsPerDay: entity.maxSpinsPerDay,
      requiredPoints: entity.requiredPoints,
      isActive: entity.isActive,
      options: entity.options,
      spinDuration: entity.spinDuration,
      soundEnabled: entity.soundEnabled,
      hapticEnabled: entity.hapticEnabled,
    );
  }
}

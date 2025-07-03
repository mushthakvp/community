import 'package:equatable/equatable.dart';

import 'spin_option_entity.dart';

class SpinConfigEntity extends Equatable {
  final String id;
  final String type;
  final int maxSpinsPerDay;
  final int requiredPoints;
  final bool isActive;
  final List<SpinOptionEntity> options;
  final Duration spinDuration;
  final bool soundEnabled;
  final bool hapticEnabled;

  const SpinConfigEntity({
    required this.id,
    required this.type,
    this.maxSpinsPerDay = 1,
    this.requiredPoints = 0,
    this.isActive = true,
    required this.options,
    this.spinDuration = const Duration(seconds: 3),
    this.soundEnabled = true,
    this.hapticEnabled = true,
  });

  SpinConfigEntity copyWith({
    String? id,
    String? type,
    int? maxSpinsPerDay,
    int? requiredPoints,
    bool? isActive,
    List<SpinOptionEntity>? options,
    Duration? spinDuration,
    bool? soundEnabled,
    bool? hapticEnabled,
  }) {
    return SpinConfigEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      maxSpinsPerDay: maxSpinsPerDay ?? this.maxSpinsPerDay,
      requiredPoints: requiredPoints ?? this.requiredPoints,
      isActive: isActive ?? this.isActive,
      options: options ?? this.options,
      spinDuration: spinDuration ?? this.spinDuration,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      hapticEnabled: hapticEnabled ?? this.hapticEnabled,
    );
  }

  @override
  List<Object?> get props => [
    id,
    type,
    maxSpinsPerDay,
    requiredPoints,
    isActive,
    options,
    spinDuration,
    soundEnabled,
    hapticEnabled,
  ];
}

import 'package:equatable/equatable.dart';

import 'spin_option_entity.dart';

class SpinResultEntity extends Equatable {
  final String id;
  final SpinOptionEntity spinOption;
  final DateTime timestamp;
  final String userId;
  final String spinType;
  final bool isSuccess;
  final String? errorMessage;

  const SpinResultEntity({
    required this.id,
    required this.spinOption,
    required this.timestamp,
    required this.userId,
    required this.spinType,
    this.isSuccess = true,
    this.errorMessage,
  });

  SpinResultEntity copyWith({
    String? id,
    SpinOptionEntity? spinOption,
    DateTime? timestamp,
    String? userId,
    String? spinType,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return SpinResultEntity(
      id: id ?? this.id,
      spinOption: spinOption ?? this.spinOption,
      timestamp: timestamp ?? this.timestamp,
      userId: userId ?? this.userId,
      spinType: spinType ?? this.spinType,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  // Helper methods
  String get formattedTimestamp {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  bool get isWinning => isSuccess && spinOption.isWinningOption;

  @override
  List<Object?> get props => [
    id,
    spinOption,
    timestamp,
    userId,
    spinType,
    isSuccess,
    errorMessage,
  ];
}

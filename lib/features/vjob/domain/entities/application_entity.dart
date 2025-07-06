import 'package:equatable/equatable.dart';
import 'package:livera/features/vjob/domain/entities/job_entity.dart';

enum ApplicationStatus { pending, accepted, rejected, withdrawn }

class ApplicationEntity extends Equatable {
  final String id;
  final String userId;
  final JobEntity job;
  final String? resume;
  final ApplicationStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ApplicationEntity({
    required this.id,
    required this.userId,
    required this.job,
    this.resume,
    this.status = ApplicationStatus.pending,
    required this.createdAt,
    required this.updatedAt,
  });

  ApplicationEntity copyWith({
    String? id,
    String? userId,
    JobEntity? job,
    String? resume,
    ApplicationStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ApplicationEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      job: job ?? this.job,
      resume: resume ?? this.resume,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get statusDisplayName {
    switch (status) {
      case ApplicationStatus.pending:
        return 'Pending';
      case ApplicationStatus.accepted:
        return 'Accepted';
      case ApplicationStatus.rejected:
        return 'Rejected';
      case ApplicationStatus.withdrawn:
        return 'Withdrawn';
    }
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    job,
    resume,
    status,
    createdAt,
    updatedAt,
  ];
}

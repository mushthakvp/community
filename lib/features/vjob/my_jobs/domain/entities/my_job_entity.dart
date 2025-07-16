import 'package:equatable/equatable.dart';

/// Core entity representing a job application/save record
class MyJobEntity extends Equatable {
  final String id;
  final String userId;
  final MyJobDetailsEntity jobDetails;
  final String? resume;
  final MyJobStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MyJobEntity({
    required this.id,
    required this.userId,
    required this.jobDetails,
    this.resume,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  MyJobEntity copyWith({
    String? id,
    String? userId,
    MyJobDetailsEntity? jobDetails,
    String? resume,
    MyJobStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MyJobEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      jobDetails: jobDetails ?? this.jobDetails,
      resume: resume ?? this.resume,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    jobDetails,
    resume,
    status,
    createdAt,
    updatedAt,
  ];
}

/// Job details entity with comprehensive information
class MyJobDetailsEntity extends Equatable {
  final String id;
  final String title;
  final String? description;
  final String state;
  final String city;
  final String workStyle;
  final List<String> position;
  final List<String> schedule;
  final List<String> benefits;
  final int minimumSalary;
  final String education;
  final List<String> skills;
  final List<String> languages;
  final List<String> responsibilities;
  final bool isAccepted;
  final bool isRejected;
  final String? rejectReason;
  final int rejectCount;
  final int reAppliedCount;
  final bool isBlocked;
  final bool isActive;
  final List<RejectReasonEntity> rejectReasons;
  final CompanyEntity company;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MyJobDetailsEntity({
    required this.id,
    required this.title,
    this.description,
    required this.state,
    required this.city,
    required this.workStyle,
    required this.position,
    required this.schedule,
    required this.benefits,
    required this.minimumSalary,
    required this.education,
    required this.skills,
    required this.languages,
    required this.responsibilities,
    required this.isAccepted,
    required this.isRejected,
    this.rejectReason,
    required this.rejectCount,
    required this.reAppliedCount,
    required this.isBlocked,
    required this.isActive,
    required this.rejectReasons,
    required this.company,
    required this.createdAt,
    required this.updatedAt,
  });

  String get location => '$city, $state';

  String get salaryFormatted => '\$$minimumSalary';

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    state,
    city,
    workStyle,
    position,
    schedule,
    benefits,
    minimumSalary,
    education,
    skills,
    languages,
    responsibilities,
    isAccepted,
    isRejected,
    rejectReason,
    rejectCount,
    reAppliedCount,
    isBlocked,
    isActive,
    rejectReasons,
    company,
    createdAt,
    updatedAt,
  ];
}

/// Company entity
class CompanyEntity extends Equatable {
  final String id;
  final String name;
  final String? image;

  const CompanyEntity({required this.id, required this.name, this.image});

  @override
  List<Object?> get props => [id, name, image];
}

/// Reject reason entity
class RejectReasonEntity extends Equatable {
  final String reason;
  final DateTime date;
  final String id;

  const RejectReasonEntity({
    required this.reason,
    required this.date,
    required this.id,
  });

  @override
  List<Object?> get props => [reason, date, id];
}

/// Job status enum
enum MyJobStatus { applied, saved }

extension MyJobStatusExtension on MyJobStatus {
  String get value {
    switch (this) {
      case MyJobStatus.applied:
        return 'Applied';
      case MyJobStatus.saved:
        return 'Saved';
    }
  }

  static MyJobStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'applied':
        return MyJobStatus.applied;
      case 'saved':
        return MyJobStatus.saved;
      default:
        return MyJobStatus.applied;
    }
  }
}

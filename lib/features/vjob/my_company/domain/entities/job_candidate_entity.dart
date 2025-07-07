import 'package:equatable/equatable.dart';

class JobCandidateEntity extends Equatable {
  final String id;
  final CandidateUserEntity user;
  final String jobId;
  final String? resume;
  final DateTime createdAt;
  final DateTime updatedAt;

  const JobCandidateEntity({
    required this.id,
    required this.user,
    required this.jobId,
    this.resume,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, user, jobId, resume, createdAt, updatedAt];
}

class CandidateUserEntity extends Equatable {
  final String id;
  final String name;
  final String? profileImage;

  const CandidateUserEntity({
    required this.id,
    required this.name,
    this.profileImage,
  });

  @override
  List<Object?> get props => [id, name, profileImage];
}

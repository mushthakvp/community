import 'package:equatable/equatable.dart';

class CandidateEntity extends Equatable {
  final String id;
  final UserEntity user;
  final String jobId;
  final String? resume;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CandidateEntity({
    required this.id,
    required this.user,
    required this.jobId,
    this.resume,
    required this.createdAt,
    required this.updatedAt,
  });

  CandidateEntity copyWith({
    String? id,
    UserEntity? user,
    String? jobId,
    String? resume,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CandidateEntity(
      id: id ?? this.id,
      user: user ?? this.user,
      jobId: jobId ?? this.jobId,
      resume: resume ?? this.resume,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, user, jobId, resume, createdAt, updatedAt];
}

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String? profileImage;

  const UserEntity({required this.id, required this.name, this.profileImage});

  UserEntity copyWith({String? id, String? name, String? profileImage}) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
    );
  }

  @override
  List<Object?> get props => [id, name, profileImage];
}

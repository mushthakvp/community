import '../../domain/entities/candidate_entity.dart';

class CandidateModel extends CandidateEntity {
  const CandidateModel({
    required super.id,
    required super.user,
    required super.jobId,
    super.resume,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CandidateModel.fromJson(Map<String, dynamic> json) {
    return CandidateModel(
      id: json['_id'] ?? '',
      user: UserModel.fromJson(json['userId'] ?? {}),
      jobId: json['jobId'] ?? '',
      resume: json['resume'],
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': (user as UserModel).toJson(),
      'jobId': jobId,
      'resume': resume,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  CandidateModel copyWithModel({
    String? id,
    UserModel? user,
    String? jobId,
    String? resume,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CandidateModel(
      id: id ?? this.id,
      user: user ?? this.user as UserModel,
      jobId: jobId ?? this.jobId,
      resume: resume ?? this.resume,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class UserModel extends UserEntity {
  const UserModel({required super.id, required super.name, super.profileImage});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'profileImage': profileImage};
  }

  UserModel copyWithModel({String? id, String? name, String? profileImage}) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}

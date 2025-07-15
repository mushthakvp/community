import '../../domain/entities/community_entity.dart';

class MemberModel extends MemberEntity {
  const MemberModel({
    required super.id,
    required super.name,
    super.profileImage,
    super.role,
    super.isOnline,
    super.lastSeen,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      profileImage: json['profileImage'],
      role: json['role'],
      isOnline: json['isOnline'] ?? false,
      lastSeen: json['lastSeen'] != null
          ? DateTime.parse(json['lastSeen'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'profileImage': profileImage,
      'role': role,
      'isOnline': isOnline,
      'lastSeen': lastSeen?.toIso8601String(),
    };
  }

  @override
  MemberModel copyWith({
    String? id,
    String? name,
    String? profileImage,
    String? role,
    bool? isOnline,
    DateTime? lastSeen,
  }) {
    return MemberModel(
      id: id ?? this.id,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
      role: role ?? this.role,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }
}

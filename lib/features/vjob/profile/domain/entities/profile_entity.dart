import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? profileImage;
  final int totalApplied;
  final int totalPosted;
  final DateTime? lastActive;

  const ProfileEntity({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
    this.totalApplied = 0,
    this.totalPosted = 0,
    this.lastActive,
  });

  ProfileEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImage,
    int? totalApplied,
    int? totalPosted,
    DateTime? lastActive,
  }) {
    return ProfileEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      totalApplied: totalApplied ?? this.totalApplied,
      totalPosted: totalPosted ?? this.totalPosted,
      lastActive: lastActive ?? this.lastActive,
    );
  }

  // Helper methods
  String get displayName => name.isNotEmpty ? name : 'Unknown User';
  String get safeProfileImage => profileImage ?? '';
  bool get hasProfileImage => profileImage != null && profileImage!.isNotEmpty;

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    profileImage,
    totalApplied,
    totalPosted,
    lastActive,
  ];

  @override
  String toString() {
    return 'ProfileEntity(id: $id, name: $name, email: $email)';
  }
}

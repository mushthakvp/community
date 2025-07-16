import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final bool success;
  final String message;
  final int totalApplied;
  final int totalPosted;
  final UserEntity user;

  const ProfileEntity({
    required this.success,
    required this.message,
    required this.totalApplied,
    required this.totalPosted,
    required this.user,
  });

  @override
  List<Object?> get props => [
    success,
    message,
    totalApplied,
    totalPosted,
    user,
  ];
}

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? profileImage;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
  });

  @override
  List<Object?> get props => [id, name, email, profileImage];
}

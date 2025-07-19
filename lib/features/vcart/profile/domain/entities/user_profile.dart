import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profilePicture;
  final String role;
  final DateTime createdAt;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profilePicture,
    required this.role,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    profilePicture,
    role,
    createdAt,
  ];
}

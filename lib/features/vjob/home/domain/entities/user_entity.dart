import 'package:equatable/equatable.dart';

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

  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImage,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
    );
  }

  @override
  List<Object?> get props => [id, name, email, profileImage];
}

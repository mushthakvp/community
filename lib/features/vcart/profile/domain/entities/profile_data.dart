import 'package:equatable/equatable.dart';

import 'user_profile.dart';

class ProfileData extends Equatable {
  final bool success;
  final String message;
  final UserProfile user;

  const ProfileData({
    required this.success,
    required this.message,
    required this.user,
  });

  @override
  List<Object?> get props => [success, message, user];
}

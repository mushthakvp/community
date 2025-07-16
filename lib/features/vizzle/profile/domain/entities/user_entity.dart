import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String name;
  final String profileImage;
  final DateTime? joinedDate;

  const UserEntity({
    required this.name,
    required this.profileImage,
    this.joinedDate,
  });

  String get joinedDateDisplay {
    if (joinedDate == null) return 'Unknown';
    final now = DateTime.now();
    final difference = now.difference(joinedDate!);

    if (difference.inDays < 30) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }

  @override
  List<Object?> get props => [name, profileImage, joinedDate];
}

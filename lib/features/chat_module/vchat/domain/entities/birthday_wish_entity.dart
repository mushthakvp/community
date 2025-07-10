import 'package:equatable/equatable.dart';

class BirthdayWishEntity extends Equatable {
  final String id;
  final String friendId;
  final String friendName;
  final String? friendAvatar;
  final DateTime birthday;
  final bool hasWished;
  final String? wishMessage;
  final DateTime? wishedAt;

  const BirthdayWishEntity({
    required this.id,
    required this.friendId,
    required this.friendName,
    this.friendAvatar,
    required this.birthday,
    this.hasWished = false,
    this.wishMessage,
    this.wishedAt,
  });

  BirthdayWishEntity copyWith({
    String? id,
    String? friendId,
    String? friendName,
    String? friendAvatar,
    DateTime? birthday,
    bool? hasWished,
    String? wishMessage,
    DateTime? wishedAt,
  }) {
    return BirthdayWishEntity(
      id: id ?? this.id,
      friendId: friendId ?? this.friendId,
      friendName: friendName ?? this.friendName,
      friendAvatar: friendAvatar ?? this.friendAvatar,
      birthday: birthday ?? this.birthday,
      hasWished: hasWished ?? this.hasWished,
      wishMessage: wishMessage ?? this.wishMessage,
      wishedAt: wishedAt ?? this.wishedAt,
    );
  }

  bool get isBirthdayToday {
    final now = DateTime.now();
    return birthday.month == now.month && birthday.day == now.day;
  }

  String get displayName =>
      friendName.isNotEmpty ? friendName : 'Unknown Friend';
  String get safeAvatar => friendAvatar ?? '';

  @override
  List<Object?> get props => [
    id,
    friendId,
    friendName,
    friendAvatar,
    birthday,
    hasWished,
    wishMessage,
    wishedAt,
  ];
}

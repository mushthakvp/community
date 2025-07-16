import 'package:equatable/equatable.dart';

class SocialLinksEntity extends Equatable {
  final String youtubeChannel;
  final String instagram;
  final String facebook;
  final String twitter;

  const SocialLinksEntity({
    required this.youtubeChannel,
    required this.instagram,
    required this.facebook,
    required this.twitter,
  });

  SocialLinksEntity copyWith({
    String? youtubeChannel,
    String? instagram,
    String? facebook,
    String? twitter,
  }) {
    return SocialLinksEntity(
      youtubeChannel: youtubeChannel ?? this.youtubeChannel,
      instagram: instagram ?? this.instagram,
      facebook: facebook ?? this.facebook,
      twitter: twitter ?? this.twitter,
    );
  }

  @override
  List<Object?> get props => [youtubeChannel, instagram, facebook, twitter];

  @override
  String toString() {
    return 'SocialLinksEntity(youtube: $youtubeChannel, instagram: $instagram)';
  }
}

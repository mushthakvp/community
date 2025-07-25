import 'package:equatable/equatable.dart';

import 'prize_position.dart';

class PrizeOverview extends Equatable {
  final String? message;
  final PrizePosition? myPosition;
  final List<PrizePosition> prizes;

  const PrizeOverview({this.message, this.myPosition, this.prizes = const []});

  PrizePosition? get winner => prizes.isNotEmpty
      ? prizes.firstWhere((p) => p.position == 1, orElse: () => prizes.first)
      : null;

  List<PrizePosition> get leaderboard =>
      List<PrizePosition>.from(prizes)
        ..sort((a, b) => (a.position ?? 999).compareTo(b.position ?? 999));

  bool get hasMyPosition => myPosition != null;
  bool get isUserWinner => myPosition?.position == 1;

  @override
  List<Object?> get props => [message, myPosition, prizes];
}

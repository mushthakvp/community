import 'package:equatable/equatable.dart';

import 'challenge.dart';

class CookingHome extends Equatable {
  final String? message;
  final List<Challenge> currentChallenges;
  final List<Challenge> upcomingChallenges;
  final int totalCurrentPages;
  final int totalUpcomingPages;
  final int totalCurrentChallenges;
  final int totalUpcomingChallenges;

  const CookingHome({
    this.message,
    required this.currentChallenges,
    required this.upcomingChallenges,
    required this.totalCurrentPages,
    required this.totalUpcomingPages,
    required this.totalCurrentChallenges,
    required this.totalUpcomingChallenges,
  });

  @override
  List<Object?> get props => [
    message,
    currentChallenges,
    upcomingChallenges,
    totalCurrentPages,
    totalUpcomingPages,
    totalCurrentChallenges,
    totalUpcomingChallenges,
  ];
}

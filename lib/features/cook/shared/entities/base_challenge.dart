import 'package:equatable/equatable.dart';

class BaseChallenge extends Equatable {
  final String id;
  final String? image;
  final String title;
  final int joinedUsers;
  final DateTime? startDate;
  final DateTime? endDate;
  final int maximumParticipants;

  const BaseChallenge({
    required this.id,
    this.image,
    required this.title,
    required this.joinedUsers,
    this.startDate,
    this.endDate,
    required this.maximumParticipants,
  });

  int get daysLeft {
    if (endDate == null) return 0;
    return endDate!.difference(DateTime.now()).inDays;
  }

  String get formattedEndDate {
    if (endDate == null) return '01/04/2020';
    return '${endDate!.day.toString().padLeft(2, '0')}/'
        '${endDate!.month.toString().padLeft(2, '0')}/'
        '${endDate!.year}';
  }

  @override
  List<Object?> get props => [
    id,
    image,
    title,
    joinedUsers,
    startDate,
    endDate,
    maximumParticipants,
  ];
}

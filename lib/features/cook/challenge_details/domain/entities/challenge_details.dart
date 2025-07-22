import 'package:equatable/equatable.dart';

class ChallengeDetails extends Equatable {
  final String id;
  final String? createdBy;
  final String title;
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? image;
  final int firstPrizeLoyaltyPoints;
  final int secondPrizeLoyaltyPoints;
  final int thirdPrizeLoyaltyPoints;
  final int maximumParticipants;
  final int joinedUsers;
  final bool isAlreadyJoined;
  final bool isResultAdded;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ChallengeDetails({
    required this.id,
    this.createdBy,
    required this.title,
    this.description,
    this.startDate,
    this.endDate,
    this.image,
    required this.firstPrizeLoyaltyPoints,
    required this.secondPrizeLoyaltyPoints,
    required this.thirdPrizeLoyaltyPoints,
    required this.maximumParticipants,
    required this.joinedUsers,
    required this.isAlreadyJoined,
    required this.isResultAdded,
    this.createdAt,
    this.updatedAt,
  });

  bool get isWithinChallengeDate {
    final now = DateTime.now();
    return startDate != null &&
        endDate != null &&
        now.isAfter(startDate!) &&
        now.isBefore(endDate!);
  }

  String get formattedStartDate {
    if (startDate == null) return 'N/A';
    return '${startDate!.day.toString().padLeft(2, '0')}/'
        '${startDate!.month.toString().padLeft(2, '0')}/'
        '${startDate!.year}';
  }

  String get formattedEndDate {
    if (endDate == null) return 'N/A';
    return '${endDate!.day.toString().padLeft(2, '0')}/'
        '${endDate!.month.toString().padLeft(2, '0')}/'
        '${endDate!.year}';
  }

  int get daysLeft {
    if (endDate == null) return 0;
    return endDate!.difference(DateTime.now()).inDays;
  }

  @override
  List<Object?> get props => [
    id,
    createdBy,
    title,
    description,
    startDate,
    endDate,
    image,
    firstPrizeLoyaltyPoints,
    secondPrizeLoyaltyPoints,
    thirdPrizeLoyaltyPoints,
    maximumParticipants,
    joinedUsers,
    isAlreadyJoined,
    isResultAdded,
    createdAt,
    updatedAt,
  ];
}

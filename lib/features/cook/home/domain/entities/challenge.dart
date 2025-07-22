import '../../../shared/entities/base_challenge.dart';

class Challenge extends BaseChallenge {
  const Challenge({
    required super.id,
    super.image,
    required super.title,
    required super.joinedUsers,
    super.startDate,
    super.endDate,
    required super.maximumParticipants,
  });
}

import '../../../home/data/models/challenge_model.dart';
import '../../../shared/entities/base_challenge.dart';
import '../../domain/entities/search_result.dart';

class SearchResultModel extends SearchResult {
  const SearchResultModel({
    required super.challenges,
    required super.query,
    required super.totalResults,
    required super.currentPage,
    required super.totalPages,
  });

  factory SearchResultModel.fromJson(Map<String, dynamic> json, String query) {
    final currentChallenges = json['current'] as List? ?? [];
    final upcomingChallenges = json['upcoming'] as List? ?? [];

    final allChallenges = <BaseChallenge>[
      ...currentChallenges.map((x) => ChallengeModel.fromJson(x)),
      ...upcomingChallenges.map((x) => ChallengeModel.fromJson(x)),
    ];

    return SearchResultModel(
      challenges: allChallenges,
      query: query,
      totalResults:
          (json['totalCurrentChallenges'] ?? 0) +
          (json['totalUpcomingChallenges'] ?? 0),
      currentPage: 1,
      totalPages: 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'challenges': challenges
          .map(
            (c) => {
              '_id': c.id,
              'image': c.image,
              'title': c.title,
              'joinedUsers': c.joinedUsers,
              'startDate': c.startDate?.toIso8601String(),
              'endDate': c.endDate?.toIso8601String(),
              'maximumParticipants': c.maximumParticipants,
            },
          )
          .toList(),
      'query': query,
      'totalResults': totalResults,
      'currentPage': currentPage,
      'totalPages': totalPages,
    };
  }
}

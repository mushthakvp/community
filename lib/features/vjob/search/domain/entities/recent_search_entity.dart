import 'package:equatable/equatable.dart';

class RecentSearchEntity extends Equatable {
  final String id;
  final String userId;
  final String searchTerm;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RecentSearchEntity({
    required this.id,
    required this.userId,
    required this.searchTerm,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, userId, searchTerm, createdAt, updatedAt];
}

class RecentSearchesResponseEntity extends Equatable {
  final bool success;
  final String message;
  final List<RecentSearchEntity> recentSearches;

  const RecentSearchesResponseEntity({
    required this.success,
    required this.message,
    required this.recentSearches,
  });

  @override
  List<Object?> get props => [success, message, recentSearches];
}

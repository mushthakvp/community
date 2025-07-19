import 'package:equatable/equatable.dart';

class RecentSearch extends Equatable {
  final String id;
  final String userId;
  final String searchTerm;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RecentSearch({
    required this.id,
    required this.userId,
    required this.searchTerm,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, userId, searchTerm, createdAt, updatedAt];
}

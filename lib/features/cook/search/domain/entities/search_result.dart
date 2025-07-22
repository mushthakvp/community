import 'package:equatable/equatable.dart';

import '../../../shared/entities/base_challenge.dart';

class SearchResult extends Equatable {
  final List<BaseChallenge> challenges;
  final String query;
  final int totalResults;
  final int currentPage;
  final int totalPages;

  const SearchResult({
    required this.challenges,
    required this.query,
    required this.totalResults,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  List<Object> get props => [
    challenges,
    query,
    totalResults,
    currentPage,
    totalPages,
  ];
}

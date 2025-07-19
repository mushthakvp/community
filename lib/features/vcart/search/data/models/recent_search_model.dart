import '../../domain/entities/recent_search.dart';

class RecentSearchModel extends RecentSearch {
  const RecentSearchModel({
    required super.id,
    required super.userId,
    required super.searchTerm,
    required super.createdAt,
    required super.updatedAt,
  });

  factory RecentSearchModel.fromJson(Map<String, dynamic> json) {
    return RecentSearchModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      searchTerm: json['search'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'search': searchTerm,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

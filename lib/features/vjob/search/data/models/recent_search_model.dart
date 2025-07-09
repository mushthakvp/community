import '../../domain/entities/recent_search_entity.dart';

class RecentSearchModel extends RecentSearchEntity {
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
      searchTerm: json['searchTerm'] ?? '',
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'searchTerm': searchTerm,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class RecentSearchesResponseModel extends RecentSearchesResponseEntity {
  const RecentSearchesResponseModel({
    required super.success,
    required super.message,
    required super.recentSearches,
  });

  factory RecentSearchesResponseModel.fromJson(Map<String, dynamic> json) {
    return RecentSearchesResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      recentSearches:
          (json['recentSearches'] as List?)
              ?.map((search) => RecentSearchModel.fromJson(search))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'recentSearches': recentSearches
          .map((search) => (search as RecentSearchModel).toJson())
          .toList(),
    };
  }
}

import 'package:equatable/equatable.dart';

class SearchSection extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SearchSection({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    imageUrl,
    isDeleted,
    createdAt,
    updatedAt,
  ];
}

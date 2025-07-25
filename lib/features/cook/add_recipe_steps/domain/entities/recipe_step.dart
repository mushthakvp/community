import 'package:equatable/equatable.dart';

class RecipeStep extends Equatable {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final int order;
  final DateTime? createdAt;

  const RecipeStep({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.order,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': imageUrl,
      'order': order,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory RecipeStep.fromMap(Map<String, dynamic> map) {
    return RecipeStep(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['image'] ?? '',
      order: map['order'] ?? 0,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : null,
    );
  }

  RecipeStep copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    int? order,
    DateTime? createdAt,
  }) {
    return RecipeStep(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  bool get hasImage => imageUrl.isNotEmpty;

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    imageUrl,
    order,
    createdAt,
  ];

  @override
  String toString() {
    return 'RecipeStep(id: $id, title: $title, description: $description, imageUrl: $imageUrl, order: $order)';
  }
}

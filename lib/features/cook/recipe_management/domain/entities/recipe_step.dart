import 'package:equatable/equatable.dart';

class RecipeStep extends Equatable {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final int order;

  const RecipeStep({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.order,
  });

  @override
  List<Object?> get props => [id, title, description, imageUrl, order];
}

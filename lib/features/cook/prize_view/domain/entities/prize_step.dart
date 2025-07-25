import 'package:equatable/equatable.dart';

class PrizeStep extends Equatable {
  final String? image;
  final String title;
  final String description;
  final String id;

  const PrizeStep({
    this.image,
    required this.title,
    required this.description,
    required this.id,
  });

  @override
  List<Object?> get props => [image, title, description, id];
}

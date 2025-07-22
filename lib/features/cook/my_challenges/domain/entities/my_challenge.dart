import 'package:equatable/equatable.dart';

class MyChallenge extends Equatable {
  final String id;
  final String? image;
  final String title;
  final String? description;
  final String status;
  final DateTime? createdAt;
  final bool isResultAdded;

  const MyChallenge({
    required this.id,
    this.image,
    required this.title,
    this.description,
    required this.status,
    this.createdAt,
    required this.isResultAdded,
  });

  bool get isActive =>
      status.toLowerCase() == 'joined' || status.toLowerCase() == 'incomplete';

  bool get isCompleted => status.toLowerCase() == 'completed';

  @override
  List<Object?> get props => [
    id,
    image,
    title,
    description,
    status,
    createdAt,
    isResultAdded,
  ];
}

import 'package:equatable/equatable.dart';

class Specification extends Equatable {
  final String id;
  final String title;
  final String solution;

  const Specification({
    required this.id,
    required this.title,
    required this.solution,
  });

  @override
  List<Object?> get props => [id, title, solution];
}

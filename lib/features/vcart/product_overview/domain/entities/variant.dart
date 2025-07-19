import 'package:equatable/equatable.dart';

class Variant extends Equatable {
  final String variantId;
  final List<String> images;

  const Variant({required this.variantId, required this.images});

  @override
  List<Object?> get props => [variantId, images];
}

import 'package:equatable/equatable.dart';

class FilterColor extends Equatable {
  final String color;
  final String colorCode;

  const FilterColor({required this.color, required this.colorCode});

  @override
  List<Object?> get props => [color, colorCode];
}

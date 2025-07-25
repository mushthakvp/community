import 'package:equatable/equatable.dart';

class PrizeIngredient extends Equatable {
  final String name;
  final String amount;
  final String unit;
  final String id;

  const PrizeIngredient({
    required this.name,
    required this.amount,
    required this.unit,
    required this.id,
  });

  @override
  List<Object> get props => [name, amount, unit, id];
}

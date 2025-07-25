import 'package:equatable/equatable.dart';

class Ingredient extends Equatable {
  final String name;
  final String amount;
  final String unit;

  const Ingredient({
    required this.name,
    required this.amount,
    required this.unit,
  });

  Map<String, String> toMap() {
    return {'name': name, 'amount': amount, 'unit': unit};
  }

  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      name: map['name'] ?? '',
      amount: map['amount'] ?? '',
      unit: map['unit'] ?? '',
    );
  }

  Ingredient copyWith({String? name, String? amount, String? unit}) {
    return Ingredient(
      name: name ?? this.name,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
    );
  }

  @override
  List<Object> get props => [name, amount, unit];

  @override
  String toString() => 'Ingredient(name: $name, amount: $amount, unit: $unit)';
}

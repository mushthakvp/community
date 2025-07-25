import '../../domain/entities/prize_ingredient.dart';

class PrizeIngredientModel extends PrizeIngredient {
  const PrizeIngredientModel({
    required super.name,
    required super.amount,
    required super.unit,
    required super.id,
  });

  factory PrizeIngredientModel.fromJson(Map<String, dynamic> json) {
    return PrizeIngredientModel(
      name: json['name'] ?? '',
      amount: json['amount'] ?? '',
      unit: json['unit'] ?? '',
      id: json['_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'amount': amount, 'unit': unit, '_id': id};
  }

  factory PrizeIngredientModel.fromEntity(PrizeIngredient ingredient) {
    return PrizeIngredientModel(
      name: ingredient.name,
      amount: ingredient.amount,
      unit: ingredient.unit,
      id: ingredient.id,
    );
  }
}

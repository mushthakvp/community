import 'package:flutter/material.dart';

import '../../../domain/entities/ingredient.dart';
import 'ingredient_form_section.dart';

class IngredientList extends StatelessWidget {
  final List<Ingredient> ingredients;
  final Function(Ingredient) onAddIngredient;
  final Function(int, Ingredient) onUpdateIngredient;
  final Function(int) onRemoveIngredient;

  const IngredientList({
    super.key,
    required this.ingredients,
    required this.onAddIngredient,
    required this.onUpdateIngredient,
    required this.onRemoveIngredient,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => IngredientFormSection(
            ingredient: ingredients[index],
            onSave: (ingredient) => onUpdateIngredient(index, ingredient),
            onDelete: () => onRemoveIngredient(index),
            canDelete: ingredients.length > 1,
          ),
          separatorBuilder: (context, index) => const SizedBox(height: 18),
          itemCount: ingredients.length,
        ),
        if (ingredients.isNotEmpty) const SizedBox(height: 18),
        IngredientFormSection(onSave: onAddIngredient, isNewIngredient: true),
      ],
    );
  }
}

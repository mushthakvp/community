import 'package:flutter/material.dart';

import '../../../domain/entities/recipe_step.dart';
import 'step_card.dart';

class StepsList extends StatelessWidget {
  final List<RecipeStep> steps;
  final Function(int index) onEditStep;
  final Function(int index) onDeleteStep;

  const StepsList({
    super.key,
    required this.steps,
    required this.onEditStep,
    required this.onDeleteStep,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: steps.length,
      padding: EdgeInsets.zero,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return StepCard(
          step: steps[index],
          stepNumber: index + 1,
          onEdit: () => onEditStep(index),
          onDelete: () => onDeleteStep(index),
        );
      },
    );
  }
}

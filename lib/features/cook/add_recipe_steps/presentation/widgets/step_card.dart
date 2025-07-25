import 'package:flutter/material.dart';

import '../../domain/entities/recipe_step.dart';

class StepCard extends StatelessWidget {
  final RecipeStep step;
  final int stepNumber;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const StepCard({
    super.key,
    required this.step,
    required this.stepNumber,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xff0F0F0F),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.only(left: 21, right: 12, bottom: 16, top: 16),
      child: Column(
        children: [
          _buildStepHeader(),
          const SizedBox(height: 15),
          _buildStepContent(),
        ],
      ),
    );
  }

  Widget _buildStepHeader() {
    return Row(
      children: [
        Text(
          'Step $stepNumber',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const Spacer(),
        Row(
          children: [
            GestureDetector(
              onTap: onEdit,
              child: const Icon(Icons.edit, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onDelete,
              child: const Icon(Icons.delete, color: Colors.red, size: 20),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStepContent() {
    return Row(
      children: [
        _buildStepImage(),
        const SizedBox(width: 17),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                step.description,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontWeight: FontWeight.w300,
                  fontSize: 12,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepImage() {
    return Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[800],
        image: step.hasImage
            ? DecorationImage(
                image: NetworkImage(step.imageUrl),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: !step.hasImage
          ? const Center(child: Icon(Icons.image, color: Colors.grey, size: 30))
          : null,
    );
  }
}

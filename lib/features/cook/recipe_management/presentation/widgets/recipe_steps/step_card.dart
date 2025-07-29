import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_constants.dart';
import '../../../domain/entities/recipe_step.dart';

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
        color: AppConstants.darkBlack,
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
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const Spacer(),
        Row(
          children: [
            GestureDetector(
              onTap: onEdit,
              child: const Icon(Icons.edit, color: Colors.amber, size: 20),
            ),
            const SizedBox(width: 12),
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
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                step.description,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w300,
                  color: Colors.white.withOpacity(0.6),
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
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[800],
      ),
      child: step.imageUrl != null && step.imageUrl!.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                step.imageUrl!,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholderImage();
                },
              ),
            )
          : _buildPlaceholderImage(),
    );
  }

  Widget _buildPlaceholderImage() {
    return const Center(
      child: Icon(Icons.restaurant, color: Colors.grey, size: 30),
    );
  }
}

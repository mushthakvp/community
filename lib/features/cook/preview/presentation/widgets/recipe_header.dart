import 'package:flutter/material.dart';

class RecipeHeader extends StatelessWidget {
  final String title;
  final String cookingTime;

  const RecipeHeader({
    super.key,
    required this.title,
    required this.cookingTime,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 16),
        _buildCookingTimeChip(),
      ],
    );
  }

  Widget _buildCookingTimeChip() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.access_time, color: Colors.white, size: 16),
        const SizedBox(width: 8),
        Text(
          '$cookingTime min',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
